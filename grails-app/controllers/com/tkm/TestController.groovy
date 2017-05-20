package com.tkm

import org.springframework.web.multipart.commons.CommonsMultipartFile
import grails.util.Holders
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.Files

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
            log.error("test() failed: ${ex.message}", ex)
        }
    }
}
