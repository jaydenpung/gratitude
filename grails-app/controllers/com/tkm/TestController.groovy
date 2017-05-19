package com.tkm

import com.tkm.*

class TestController {

    def shoppingCartService
    def hamperService
    def springSecurityService
    def productService

    def test() {
        try {
        }
        catch (Exception ex) {
            log.error("createDefaultSecUsers() failed: ${ex.message}", ex)
        }
    }
}
