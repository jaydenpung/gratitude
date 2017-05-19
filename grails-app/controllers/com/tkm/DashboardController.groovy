package com.tkm

import com.tkm.Hamper

class DashboardController {

    def hamperService
    def shoppingCartService

    def index() {
        try {
            def hampers = searchHampers()

            [ hampers: hampers ]
        }
        catch (Exception ex) {
            log.error("index() failed: ${ex.message}", ex)
        }
    }

    def searchHampers() {
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

            /*def orderDirection = params.find { it.key ==~ /order\[\d+\]\[dir\]/ }
            def orderColumn = params.find { it.key ==~ /order\[\d+\]\[column\]/ }
            def orderColumnName = params.find { it.key ==~ /columns\[${orderColumn.value}]\[name\]/ }

            searchContext.order = orderDirection.value
            searchContext.sort = orderColumnName.value
            searchContext.max = maxResults?.toInteger()
            searchContext.offset = offset?.toInteger()*/

            def rsp = hamperService.search(searchContext)

            def hampers = rsp.results

            return hampers
        }
        catch (Exception ex) {
            log.error("searchHampers() failed: ${ex.message}", ex)
        }
    }

    def getCartList() {
        try {
            def shoppingItems = shoppingCartService.getItems()
            def rsp
            if (shoppingItems) {
                rsp = hamperService.getHampersInCart(shoppingItems.id)
            }
            def hampers = rsp?.results

            def products = []

            hampers.each { hamper ->
                //TODO: Performance improvement
                def quantity = shoppingCartService.getQuantity(hamper).value
                products << [
                    id: hamper.id,
                    imagePath: hamper.image.path,
                    name: hamper.name,
                    shortDescription: hamper.shortDescription,
                    quantity: hamper.quantity,
                    price: hamper.price,
                    cartQuantity: quantity,
                    totalPrice: hamper.price * quantity
                ]
            }

            def totalAmount = products.totalPrice.sum()

            render (template: '/shared/shoppingList', model: [ products: products, totalAmount: totalAmount ])
        }
        catch (Exception ex) {
            log.error("getCartList() failed: ${ex.message}", ex)
        }
    }
}
