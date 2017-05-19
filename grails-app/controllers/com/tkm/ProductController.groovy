package com.tkm

import grails.converters.JSON

import com.tkm.Product
import com.tkm.SearchContext

class ProductController {

    def productService
    def imageService
    def grailsApplication

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

            def rsp = productService.search(searchContext)

            def rows = []

            if (rsp) {
                rsp.results.each { product ->
                    rows << [
                        id: product.id,
                        name: product.name,
                        description: product.description
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
                def storePath = grailsApplication.config.storage.productImage
                uploadRsp = imageService.uploadImage(image, storePath)

                if (uploadRsp.errors) {
                    throw new Exception (uploadRsp.errors)
                }
            }

            def product = new Product(
                name: params.name,
                description: params.description,
                image: uploadRsp?.result
            )

            def rsp = productService.save(product)

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
            def rsp = productService.getProductById(id)
            def product = rsp.result

            [ product: product ]
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
                def storePath = grailsApplication.config.storage.productImage
                uploadRsp = imageService.uploadImage(image, storePath)

                if (uploadRsp.errors) {
                    throw new Exception (uploadRsp.errors)
                }
            }
            //TODO: Allow remove picture
            def product = new Product(
                name: params.name,
                description: params.description,
                image: uploadRsp?.result
            )
            product.id = params.long('id')

            def rsp = productService.update(product)

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

            def rsp = productService.delete(ids)

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
}
