package com.tkm

import com.tkm.Hamper
import com.metasieve.shoppingcart.SessionUtils
import com.metasieve.shoppingcart.ShoppingCart
import grails.plugin.springsecurity.*

class DashboardController {

    def hamperService
    def cartService
    def springSecurityService

    def index() {
        try {
            redirect(action: "landingPage")
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
            def shoppingItems = cartService.getItems()

            def rsp
            if (shoppingItems) {
                rsp = hamperService.getHampersInCart(shoppingItems.id)
            }
            def hampers = rsp?.results

            def products = []

            hampers.each { hamper ->
                //TODO: Performance improvement
                def quantity = cartService.getQuantity(hamper).value
                products << [
                    id: hamper.id,
                    imageGeneratedName: hamper.image.generatedName,
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

    def landingPage() {
        try {
            def searchContext = new SearchContext()

            searchContext.order = "desc"
            searchContext.sort = "dateCreated"
            searchContext.max = 8

            def rsp = hamperService.search(searchContext)
            def hampers = rsp.results

            //Exclusive products
            searchContext = new SearchContext()

            searchContext.order = "asc"
            searchContext.sort = "dateCreated"
            searchContext.max = 8

            def exclusiveHampers = hamperService.search(searchContext).results

            [ hampers: hampers, exclusiveHampers: exclusiveHampers ]
        }
        catch (Exception ex) {
            log.error("landingPage() failed: ${ex.message}", ex)
        }
    }

    def view(Long id) {
        try {
            def rsp = hamperService.getHamperById(id)
            def hamper = rsp.result

            //Get related products
            //TODO: Improve
            def searchContext = new SearchContext()

            searchContext.order = "desc"
            searchContext.sort = "dateCreated"
            searchContext.max = 8

            def relatedHampers = hamperService.search(searchContext).results

            [ hamper: hamper, relatedHampers: relatedHampers ]
        }
        catch (Exception ex) {
            log.error("view() failed: ${ex.message}", ex)
        }
    }

    def list() {
        try{
            def hampers = searchHampers()

            [ hampers: hampers ]
        }
        catch (Exception ex) {
            log.error("list() failed: ${ex.message}", ex)
        }
    }

    def wip() {
        try{
        }
        catch (Exception ex) {
            log.error("wip() failed: ${ex.message}", ex)
        }
    }

    def addToCart() {
        def result
        try {
            def hamperId = params.long('id')
            def quantity = params.int('quantity')?: 1

            def hamperRsp = hamperService.getHamperById(hamperId)
            def hamper = hamperRsp.result

            def rsp = cartService.addToShoppingCart(hamper, quantity)
            result = rsp.items
        }
        catch (Exception ex) {
            log.error("addToCart() failed: ${ex.message}", ex)
        }
        render result
    }

    def removeFromCart() {
        def result
        try {
            def hamperId = params.long('id')
            def quantity = params.int('quantity')?: 1

            def hamperRsp = hamperService.getHamperById(hamperId)
            def hamper = hamperRsp.result

            def rsp = cartService.removeFromShoppingCart(hamper, quantity)
            result = rsp.items
        }
        catch (Exception ex) {
            log.error("removeFromCart() failed: ${ex.message}", ex)
        }
        render result
    }

    def setShoppingItemQuantity() {
        try {
            def hamperId = params.long('id')
            def newQuantity = params.int('quantity')

            def hamperRsp = hamperService.getHamperById(hamperId)
            def hamper = hamperRsp.result

            def oldQuantity = cartService.getQuantity(hamper)
            def quantity = newQuantity - oldQuantity
            def rsp
            if (quantity > 0) {
                rsp = cartService.addToShoppingCart(hamper, quantity)
            }
            else {
                quantity = -quantity
                rsp = cartService.removeFromShoppingCart(hamper, quantity)
            }

            render quantity
        }
        catch (Exception ex) {
            log.error("setShoppingItemQuantity() failed: ${ex.message}", ex)
        }
    }

    def checkout() {
        try {
            def shoppingItems = cartService.getItems()

            def rsp
            if (shoppingItems) {
                rsp = hamperService.getHampersInCart(shoppingItems.id)
            }
            def hampers = rsp?.results

            def products = []

            hampers.each { hamper ->
                //TODO: Performance improvement
                def quantity = cartService.getQuantity(hamper).value
                products << [
                    id: hamper.id,
                    imageGeneratedName: hamper.image.generatedName,
                    name: hamper.name,
                    shortDescription: hamper.shortDescription,
                    quantity: hamper.quantity,
                    price: hamper.price,
                    cartQuantity: quantity,
                    totalPrice: hamper.price * quantity
                ]
            }

            def totalAmount = products.totalPrice.sum()

            [ products: products, totalAmount: totalAmount ]
        }
        catch (Exception ex) {
            log.error("checkout() failed: ${ex.message}", ex)
        }
    }

    def getTotal() {
        try {
            def shoppingItems = cartService.getItems()

            def rsp
            if (shoppingItems) {
                rsp = hamperService.getHampersInCart(shoppingItems.id)
            }
            def hampers = rsp?.results

            def products = []

            hampers.each { hamper ->
                //TODO: Performance improvement
                def quantity = cartService.getQuantity(hamper).value
                products << [
                    totalPrice: hamper.price * quantity
                ]
            }

            def totalAmount = products.totalPrice.sum()

            render totalAmount
        }
        catch (Exception ex) {
            log.error("getTotal() failed: ${ex.message}", ex)
        }
    }

    def test() {
        try{

        }
        catch (Exception ex) {
            log.error("test() failed: ${ex.message}", ex)
        }
    }

    def transferShoppingCart() {
        try{
            String previousSessionId = params.previousSessionId

            def shoppingCart = ShoppingCart.findBySessionIDAndCheckedOut(previousSessionId, false)
            def userShoppingCart

            if (springSecurityService.isLoggedIn()) {
                userShoppingCart = ShoppingCart.findBySessionIDAndCheckedOut(springSecurityService.getPrincipal().username, false)
            }

            if (shoppingCart && userShoppingCart) {
                if (shoppingCart.items.size() > 0) {

                    cartService.emptyShoppingCart(userShoppingCart)
                    userShoppingCart.delete(flush: true)

                    shoppingCart.sessionID = springSecurityService.getPrincipal().username
                    shoppingCart.save(flush: true, failOnError: true)
                }
                else {
                    //do nothing
                }
            }
            else if (shoppingCart && !userShoppingCart) {                
                shoppingCart.sessionID = springSecurityService.getPrincipal().username;
                shoppingCart.save(flush: true, failOnError: true)
            }
            else if (!shoppingCart && userShoppingCart) {
                //do nothing
            }
            else {
                //do nothing
            }

            render (true)
        }
        catch (Exception ex) {
            log.error("transferShoppingCart() failed: ${ex.message}", ex)
        }
    }

    def proceed() {
        try {
            if (springSecurityService.isLoggedIn()) {

            }
            else {
                redirect (controller: 'login', action: 'auth')
            }
        }
        catch (Exception ex) {
            log.error("checkout() failed: ${ex.message}", ex)
        }
    }
}
