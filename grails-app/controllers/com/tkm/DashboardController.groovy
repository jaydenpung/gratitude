package com.tkm

import com.tkm.Hamper
import com.metasieve.shoppingcart.SessionUtils
import com.metasieve.shoppingcart.ShoppingCart
import grails.plugin.springsecurity.*
import grails.converters.JSON

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
                [ name: "name", value: params.name, operator: "ilike" ],
                [ name: "quantity", value: "0", operator: ">" ]
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
            [
                [ name: "quantity", value: "0", operator: ">" ]
            ].each {
                if (it.value) {
                    def searchableField = new SearchableField()
                    searchableField.name = it.name
                    searchableField.value = it.value
                    searchableField.operator = it.operator
                    searchContext.fields.add(searchableField)
                }
            }

            searchContext.order = "asc"
            searchContext.sort = "dateCreated"
            searchContext.max = 8

            def rsp = hamperService.search(searchContext)
            def hampers = rsp.results

            //Exclusive products
            //def exclusiveHampers = hampers[0..7] //TODO: add Recommend feature

            [ hampers: hampers, exclusiveHampers: hampers ]
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
        def result = [:]

        try {
            def hamperId = params.long('id')
            def newQuantity = params.int('quantity')

            def hamperRsp = hamperService.getHamperById(hamperId)
            def hamper = hamperRsp.result

            def oldQuantity = cartService.getQuantity(hamper)
            def quantity = newQuantity - oldQuantity
            def rsp

            if (newQuantity > hamper.quantity) {
                result.success = false
                result.quantity = oldQuantity
            }
            else {

                if (quantity > 0) {
                    rsp = cartService.addToShoppingCart(hamper, quantity)
                }
                else {
                    quantity = -quantity
                    rsp = cartService.removeFromShoppingCart(hamper, quantity)
                }

                result.success = true
                result.quantity = quantity
            }

            render (result as JSON)
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

                while (quantity) {
                    products << [
                        id: hamper.id,
                        imageGeneratedName: hamper.image.generatedName,
                        name: hamper.name,
                        shortDescription: hamper.shortDescription,
                        stockLeft: hamper.quantity,
                        price: hamper.price
                    ]
                    quantity--;
                }
            }

            def totalAmount = products.price.sum()

            //Get Recipients
            def recipients = springSecurityService.getCurrentUser().userProfile.recipients

            [ products: products, totalAmount: totalAmount, recipients: recipients ]
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

            render totalAmount.toString()
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
            log.error("proceed() failed: ${ex.message}", ex)
        }
    }

    def getRecipientList() {
        try {
            def recipients = springSecurityService.getCurrentUser().userProfile.recipients

            render (template: '/shared/recipientList', model: [ recipients: recipients ])
        }
        catch (Exception ex) {
            log.error("getRecipientList() failed: ${ex.message}", ex)
        }
    }

    def addRecipient() {
        def results = [:]

        try {
            def recipient = new Recipient(name: params.name, contactNo: params.contactNo, address: params.address)
            recipient.save(flush: true)

            def userProfile = springSecurityService.getCurrentUser().userProfile
            userProfile.recipients.add(recipient)
            userProfile.save(flush: true)

            results.success = true
            results.id = recipient.id
        }
        catch (Exception ex) {
            log.error("addRecipient() failed: ${ex.message}", ex)
            results.success = false
            results.errorMessage = ex.message
        }

        render (results as JSON)
    }

    def deleteRecipient() {
        def results = [:]

        try {
            def recipient = Recipient.findById(params.id)
            recipient.status = EntityStatus.DELETED
            recipient.save(flush: true)

            def userProfile = springSecurityService.getCurrentUser().userProfile
            userProfile.recipients.remove(recipient)
            userProfile.save(flush: true)

            results.success = true
            results.id = params.id
        }
        catch (Exception ex) {
            log.error("deleteRecipient() failed: ${ex.message}", ex)
            results.success = false
            results.errorMessage = ex.message
        }

        render (results as JSON)
    }

    def updateRecipient() {
        def results = [:]

        try {
            def recipient = Recipient.findById(params.id)
            recipient.name = params.name
            recipient.contactNo = params.contactNo
            recipient.address = params.address
            recipient.save(flush: true)

            results.success = true
            results.id = recipient.id
        }
        catch (Exception ex) {
            log.error("updateRecipient() failed: ${ex.message}", ex)
            results.success = false
            results.errorMessage = ex.message
        }

        render (results as JSON)
    }

    def proceedToPayment() {
        try {
            def hamperIds = params.list('hamperId')*.toLong()
            def recipientIds = params.list('recipient')*.toLong()
            def giftMessages = params.list('giftMessage')
            def giftItems = []

            for (int i = 0; i < hamperIds.size(); i++) {
                
                def giftItem = [
                    hamperId: hamperIds[i],
                    recipient: Recipient.findById(recipientIds[i]),
                    giftMessage: giftMessages[i],
                    price: Hamper.findById(hamperIds[i]).price
                ]

                giftItems.add(giftItem)
            }

            session.giftItems = giftItems

            def totalAmount = cartService.getTotalAmount()

            render (view: 'payment', model: [ totalAmount: totalAmount ])
        }
        catch (Exception ex) {
            log.error("proceedToPayment() failed: ${ex.message}", ex)
        }
    }

    def completePayment() {
        def orderId

        try {
            SortedSet<GiftItem> giftItems = new TreeSet<GiftItem>()

            session.giftItems.each {
                giftItems.add(
                    new GiftItem(
                        hamperId: it.hamperId,
                        recipient: it.recipient,
                        giftMessage: it.giftMessage,
                        price: it.price
                    ).save(flush: true)
                )
            }

            session.giftItems = null

            cartService.processGiftItems(giftItems)
            orderId = cartService.checkOut()[0]
        }
        catch (Exception ex) {
            log.error("completePayment() failed: ${ex.message}", ex)
        }

        redirect (controller: 'account', action: 'viewOrder', params: [id: orderId])
    }
}
