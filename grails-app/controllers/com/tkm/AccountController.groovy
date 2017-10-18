package com.tkm

import grails.converters.JSON
import java.text.SimpleDateFormat
import java.text.DecimalFormat

import com.tkm.Hamper
import com.tkm.SearchContext

class AccountController {

    def orderService
    def grailsApplication
    def cartService
    def springSecurityService
    def hamperService

    def list() {
        try {
            render(view: 'orderList')
        }
        catch (Exception ex) {
            log.error("list() failed: ${ex.message}", ex)
        }
    }

    def search() {
        try {
            def searchContext = new SearchContext()

            [
                [ name: "userId", value: springSecurityService.getPrincipal().id.toString(), operator: "=" ]
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
                        dateCreated: new SimpleDateFormat(g.message(code: 'default.simpleDateTime.format')).format(order.dateCreated),
                        totalAmount: 'RM ' + new DecimalFormat('0.00').format(order.totalAmount),
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

    def viewOrder(Long id) {
        try {
            if (params.id) {
                id = params.long('id')
            }

            def userId = springSecurityService.getCurrentUser().id
            def rsp = orderService.getOrderByIdAndUserId(id, userId)
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

            [ order: order, products: products, totalAmount: totalAmount ]
        }
        catch (Exception ex) {
            log.error("viewOrder() failed: ${ex.message}", ex)
            flash.message = ex.message
        }
    }
}
