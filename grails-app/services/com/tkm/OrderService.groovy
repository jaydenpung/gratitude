package com.tkm

import com.tkm.Hamper
import com.tkm.SearchContext
import com.tkm.SearchableField
import com.tkm.SecUser

class OrderService {

    def imageService
    def mailService
    def hamperService
    def springSecurityService

    final static fcn = [
        'like': 'like',
        'ilike': 'ilike',
        '=': 'eq',
        '!=': 'ne',
        '<=': 'le',
        '>=': 'ge',
        '<': 'lt',
        '>': 'gt',
        'isNull': 'isNull'
    ]

    static decorator = [
        'like': { '%' + it + '%' },
        'ilike': { '%' + it + '%' },
        '=': { it },
        '!=': { it },
        '<=': { it },
        '>=': { it },
        '<': { it },
        '>': { it },
        'isNull': { it },
        'isNotNull': { it }
    ]

    def search(SearchContext searchContext) {
        def rsp = [:]
        try {
            def criteria = Order.createCriteria()

            def resultList = criteria.list(max: searchContext.max ?: null, offset: searchContext.offset) {

                searchContext.fields.each {
                    def value = it.value
                    def name = it.name
                    def operator = it.operator

                    if (it.name == 'totalAmount') {
                        value = new BigDecimal(it.value)
                        "${fcn[operator]}"(name, decorator[operator](value))
                    }
                    else if (it.name == 'userId') {
                        value = value.toLong()
                        "${fcn[operator]}"(name, decorator[operator](value))
                    }
                }
                if (searchContext.sort != null && !searchContext.sort.isEmpty()) {
                    order(searchContext.sort, searchContext.order)
                }

                ne("status", EntityStatus.DELETED)
            }

            rsp.results = resultList
        }
        catch (Exception ex) {
            log.error("search() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def getOrderByIdAndUserId(Long id, Long userId) {
        def rsp = [:]
        try {
            def isAdmin = SecUser.findById(userId).getAuthorities().any { it.authority == "ROLE_ADMIN" }

            def order = Order.withCriteria {
                eq('id', id)
                ne('status', EntityStatus.DELETED)
                if (!isAdmin) {
                    eq('userId', userId)
                }
            }[0]

            if (!order) {
                throw new Exception ("Error getting Order with id: ${id}")
            }

            rsp.result = order
        }
        catch (Exception ex) {
            log.error("getOrderById() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def confirmOrders(List<Long> ids) {
        def rsp = [:]
        try {
            def orders = Order.withCriteria {
                inList('id', ids)
                ne('status', EntityStatus.DELETED)
                eq('pendingStatus', PendingStatus.PENDING_CONFIRM)
            }

            if (orders.size() != ids.size()) {
                log.warn("confirmOrders(): Error getting Order with ids: ${ids - orders.id}")
            }

            orders.each {
                it.pendingStatus = PendingStatus.PENDING_DELIVERY
                it.save(flush: true)

                sendOrderMail(it.id)
            }

            rsp.result = orders
        }
        catch (Exception ex) {
            log.error("confirmOrders() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def completeOrders(List<Long> ids) {
        def rsp = [:]
        try {
            def orders = Order.withCriteria {
                inList('id', ids)
                ne('status', EntityStatus.DELETED)
                eq('pendingStatus', PendingStatus.PENDING_DELIVERY)
            }

            if (orders.size() != ids.size()) {
                log.warn("completeOrders(): Error getting Order with ids: ${ids - orders.id}")
            }

            orders.each {
                it.pendingStatus = PendingStatus.PENDING_NONE
                it.save(flush: true)
                sendOrderMail(it.id)
            }

            rsp.result = orders
        }
        catch (Exception ex) {
            log.error("completeOrders() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def sendOrderMail(Long id) {
        try {
            def userId = springSecurityService.getPrincipal().id
            def rsp = getOrderByIdAndUserId(id, userId)
            def order = rsp.result

            def products = []

            order.shoppingCart.giftItems.each { item ->
                def hamper = hamperService.getHamperById(item.hamperId).result
                products << [
                    id: hamper.id,
                    imageGeneratedName: hamper.image.generatedName,
                    name: hamper.name,
                    shortDescription: hamper.shortDescription,
                    price: item.price,
                    recipient: item.recipient,
                    giftMessage: item.giftMessage
                ]
            }

            def totalAmount = order.totalAmount

            def customer = SecUser.findById(order.userId)
            def emailSubject = "Gratitude Hampers - Your order ID " + order.id + " from GratitudeHampers has been "
            def message = "This is to inform you that your order at www.gratitudehampers.com with Order ID: " + order.id + " has been "

            switch (order.pendingStatus) {
                case PendingStatus.PENDING_DELIVERY:
                    message += "confirmed"
                    emailSubject += "confirmed"
                    break;
                case PendingStatus.PENDING_NONE:
                    message += "delivered"
                    emailSubject += "delivered"
                    break;
                default:
                    message += "updated"
                    emailSubject += "updated"
                    break;
            }

            sendMail {
                async true
                to customer.username
                subject emailSubject
                body( view:"/shared/orderEmail", model: [ message: message, order: order, products: products, totalAmount: totalAmount ])
            }
        }
        catch (Exception ex) {
            log.error("sendOrderMail() failed: ${ex.message}", ex)
        }

    }
}
