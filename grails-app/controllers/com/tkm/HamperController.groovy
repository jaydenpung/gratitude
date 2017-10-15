package com.tkm

import grails.converters.JSON

import com.tkm.Hamper
import com.tkm.SearchContext

class HamperController {

    def hamperService
    def imageService
    def grailsApplication
    def cartService

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

            def rsp = hamperService.search(searchContext)

            def rows = []

            if (rsp) {
                rsp.results.each { hamper ->
                    rows << [
                        id: hamper.id,
                        name: hamper.name,
                        price: hamper.price,
                        quantity: hamper.quantity
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

    def create() {
        try {
        }
        catch (Exception ex) {
            log.error("create() failed: ${ex.message}", ex)
        }
    }

    def save() {
        try {
            def image = request.getFile('image')
            def uploadRsp
            if (image.size > 0) {
                def storePath = grailsApplication.config.storage.hamperImage
                uploadRsp = imageService.uploadImage(image, storePath)

                if (uploadRsp.errors) {
                    throw new Exception (uploadRsp.errors)
                }
            }
            else {
                throw new Exception("No Image uploaded")
            }

            def hamper = new Hamper(
                name: params.name,
                price: new BigDecimal(params.price),
                quantity: params.long('quantity'),
                shortDescription: params.shortDescription,
                description: params.description,
                image: uploadRsp?.result
            )

            def rsp = hamperService.save(hamper)

            if (rsp.errors) {
                throw new Exception (rsp.errors)
            }
        }
        catch (Exception ex) {
            log.error("save() failed: ${ex.message}", ex)
            flash.errors = ex.message
        }

        flash.errors? redirect(action: 'create') : redirect(action: 'list')
    }

    def edit(Long id) {
        try {
            def rsp = hamperService.getHamperById(id)
            def hamper = rsp.result

            [ hamper: hamper ]
        }
        catch (Exception ex) {
            log.error("edit() failed: ${ex.message}", ex)
        }
    }

    def update() {
        try {
            def image = request.getFile('image')
            def uploadRsp
            if (image.size > 0) {
                def storePath = grailsApplication.config.storage.hamperImage
                uploadRsp = imageService.uploadImage(image, storePath)

                if (uploadRsp.errors) {
                    throw new Exception (uploadRsp.errors)
                }
            }
            //TODO: Allow remove picture
            def hamper = new Hamper(
                name: params.name,
                price: new BigDecimal(params.price),
                quantity: params.long('quantity'),
                shortDescription: params.shortDescription,
                description: params.description,
                image: uploadRsp?.result
            )
            hamper.id = params.long('id')

            def rsp = hamperService.update(hamper)

            if (rsp.errors) {
                throw new Exception (rsp.errors)
            }
        }
        catch (Exception ex) {
            log.error("update() failed: ${ex.message}", ex)
            flash.errors = ex.message
        }

        flash.errors? redirect(action: 'edit', params: [ id: params.id ]) : redirect(action: 'list')
    }

    def delete() {
        try {
            def ids = params.list('id')*.toLong()

            def rsp = hamperService.delete(ids)

            if (rsp.errors) {
                throw new Exception (rsp.errors)
            }
        }
        catch (Exception ex) {
            log.error("delete() failed: ${ex.message}", ex)
            flash.errors = ex.message
        }
        redirect(action: 'list')
    }

    def view(Long id) {
        try {
            def rsp = hamperService.getHamperById(id)
            def hamper = rsp.result

            [ hamper: hamper ]
        }
        catch (Exception ex) {
            log.error("view() failed: ${ex.message}", ex)
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
}
