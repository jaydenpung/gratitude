package com.tkm

class TkmTagLib {
    static namespace = "tkm"

    def shoppingCartService
    def hamperService

    def shoppingList = {
        def x = shoppingCartService.getItems()
        def products = "yyyy"

        out << render(template: '/shared/shoppingList', model: [ products: products ])
    }
}
