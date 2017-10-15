package com.tkm

import com.metasieve.shoppingcart.*
import grails.plugin.springsecurity.*

class CartService extends ShoppingCartService {

    def springSecurityService
    def hamperService

    @Override
    def createShoppingCart() {
        def sessionID = SessionUtils.getSession().id

        if (springSecurityService.isLoggedIn()) {
            sessionID = springSecurityService.getPrincipal().username;
        }

        def shoppingCart = new ShoppingCart(sessionID:sessionID)
        shoppingCart.save()
        
        return shoppingCart
    }

    @Override
    def addToShoppingCart(IShoppable product, Integer qty = 1, ShoppingCart previousShoppingCart = null) {
        if (!product.shoppingItem) {
            def shoppingItem = new ShoppingItem()
            shoppingItem.save()
            product.shoppingItem = shoppingItem
            product.save()
        }
        
        def shoppingCart = getShoppingCart()

        def quantity = Quantity.findByShoppingCartAndShoppingItem(shoppingCart, product.shoppingItem)
        if (quantity) {
            quantity.value += qty
        } else {
            shoppingCart.addToItems(product.shoppingItem)
            quantity = new Quantity(shoppingCart:shoppingCart, shoppingItem:product.shoppingItem, value:qty)
        }
        quantity.save()
        
        shoppingCart.save()
    }

    @Override
    def removeFromShoppingCart(IShoppable product, Integer qty = 1, ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        
        if (!shoppingCart) {
            return
        }
        
        def quantity = Quantity.findByShoppingCartAndShoppingItem(shoppingCart, product.shoppingItem)
        if (quantity) {
            if (quantity.value - qty >= 0) {
                quantity.value -= qty
            }
            quantity.save()
        }
        
        if (quantity.value == 0) {
            // work-around for $$_javassist types in list
            def itemToRemove = shoppingCart.items.find { item ->
                if (item.id == product.shoppingItem.id) {
                    return true
                }
                return false
            }
            shoppingCart.removeFromItems(itemToRemove)
            quantity.delete()
        }
        
        shoppingCart.save()
    }

    @Override
    def getQuantity(IShoppable product, ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        def quantity = Quantity.findByShoppingCartAndShoppingItem(shoppingCart, product.shoppingItem)
        
        return quantity?.value
    }

    @Override
    def getQuantity(ShoppingItem shoppingItem, ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        def quantity = Quantity.findByShoppingCartAndShoppingItem(shoppingCart, shoppingItem)
        
        return quantity?.value
    }

    @Override
    def setLastURL(def url, ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        shoppingCart.lastURL = url
        shoppingCart.save()
    }

    @Override
    def emptyShoppingCart(ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        shoppingCart.items = []
        
        def quantities = Quantity.findAllByShoppingCart(shoppingCart)
        quantities.each { quantity -> quantity.delete() }
        
        shoppingCart.save()
    }

    @Override
    Set getItems(ShoppingCart previousShoppingCart = null) {
        def shoppingCart = getShoppingCart()
        return shoppingCart.items
    }

    @Override
    Set checkOut(ShoppingCart previousShoppingCart = null) {

        def totalAmount = deductItems();

        def shoppingCart = getShoppingCart()
        
        def checkedOutItems = []
        shoppingCart.items.each { item ->
            def checkedOutItem = [:]
            checkedOutItem['item'] = item
            checkedOutItem['qty'] = getQuantity(item)
            checkedOutItems.add(checkedOutItem)
        }
        
        shoppingCart.checkedOut = true
        shoppingCart.save()

        Transaction transaction = new Transaction(
            user: SecUser.findByUsername(springSecurityService.getPrincipal().username),
            totalAmount: totalAmount,
            shoppingCart: shoppingCart
        )

        transaction.save(flush: true)
        
        return checkedOutItems
    }

    @Override
    def getShoppingCart(def previousSessionID = null) {
        def sessionID = previousSessionID
        if (!sessionID) {

            if (springSecurityService.isLoggedIn()) {
                sessionID = springSecurityService.getPrincipal().username
            }
            else {
                sessionID = SessionUtils.getSession().id
            }
        }
        
        def shoppingCart = ShoppingCart.findBySessionIDAndCheckedOut(sessionID, false)
        
        if (!shoppingCart) {
            shoppingCart = createShoppingCart()
        }
        
        return shoppingCart
    }
    
    @Override
    def getShoppingItem() {
        def shoppingItem = new ShoppingItem()
        shoppingItem.save()
        return shoppingItem
    }

    def deductItems() {
        def shoppingItems = getItems()
        def totalAmount = 0

        def rsp
        if (shoppingItems) {
            rsp = hamperService.getHampersInCart(shoppingItems.id)
        }
        def hampers = rsp?.results

        def products = []

        hampers.each { hamper ->
            //TODO: Performance improvement
            def quantity = getQuantity(hamper).value
            products << [
                totalPrice: hamper.price * quantity
            ]
            hamper.quantity -= quantity
            hamper.save(flush: true)
        }

        return totalAmount = products.totalPrice.sum()
    }
}
