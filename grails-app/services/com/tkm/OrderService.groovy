package com.tkm

import com.tkm.Hamper
import com.tkm.SearchContext
import com.tkm.SearchableField
import com.tkm.SecUser

class OrderService {

    def imageService

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
            }

            rsp.result = orders
        }
        catch (Exception ex) {
            log.error("completeOrders() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }
}
