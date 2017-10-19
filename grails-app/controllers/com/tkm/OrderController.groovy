package com.tkm

import grails.converters.JSON
import java.text.SimpleDateFormat
import java.text.DecimalFormat

import com.tkm.Hamper
import com.tkm.SearchContext

class OrderController {

    def orderService
    def grailsApplication
    def cartService
    def springSecurityService
    def hamperService
    def mailService

    def list() {
        try {
        }
        catch (Exception ex) {
            log.error("list() failed: ${ex.message}", ex)
        }
    }

    def search() {
        try {
            def searchContext = new SearchContext()
            [
                [ name: "name", value: params.name, operator: "ilike" ]
            ].each {
                if (it.value) {
                    def searchableField = new SearchableField()
                    searchableField.name = it.name
                    searchableField.value = it.value
                    searchableField.operator = it.operator
                    searchContext.fields.add(searchableField)
                }
            }

            def draw = params.draw
            def offset = params.int('start')
            def maxResults = params.length

            def orderDirection = params.find { it.key ==~ /order\[\d+\]\[dir\]/ }
            def orderColumn = params.find { it.key ==~ /order\[\d+\]\[column\]/ }
            def orderColumnName = params.find { it.key ==~ /columns\[${orderColumn.value}]\[name\]/ }

            searchContext.order = orderDirection.value
            searchContext.sort = orderColumnName.value
            searchContext.max = maxResults?.toInteger()
            searchContext.offset = offset?.toInteger()

            def rsp = orderService.search(searchContext)

            def rows = []

            if (rsp) {
                rsp.results.each { order ->
                    rows << [
                        id: order.id,
                        name: SecUser.findById(order.userId).username,
                        totalAmount: order.totalAmount,
                        dateCreated: new SimpleDateFormat(g.message(code: 'default.simpleDateTime.format')).format(order.dateCreated),
                        status: g.message(code: 'label.pendingStatus.' + (order.pendingStatus))
                    ]
                }
            }

            def result = [
                draw: params.draw,
                data: rows,
                recordsTotal: rsp.results.totalCount,
                recordsFiltered: rsp.results.totalCount
            ]

            render(result as JSON)
        }
        catch(Exception ex) {
            log.error("search() failed: ${ex.message}", ex)
        }
    }

    def edit(Long id) {
        try {
            def user = springSecurityService.getCurrentUser()
            def rsp = orderService.getOrderByIdAndUserId(id, user.id)
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

            [ user: user, order: order, products: products, totalAmount: totalAmount ]
        }
        catch (Exception ex) {
            log.error("view() failed: ${ex.message}", ex)
            flash.message = ex.message
        }
    }

    def confirmOrder() {
        try {
            def ids = params.list('id')*.toLong()

            orderService.confirmOrders(ids)
        }
        catch (Exception ex) {
            log.error("confirmOrder() failed: ${ex.message}", ex)
            flash.message = ex.message
        }

        redirect (action: 'list')
    }

    def completeOrder() {
        try {
            def ids = params.list('id')*.toLong()

            orderService.completeOrders(ids)
        }
        catch (Exception ex) {
            log.error("completeOrder() failed: ${ex.message}", ex)
            flash.message = ex.message
        }

        redirect (action: 'list')
    }
}
