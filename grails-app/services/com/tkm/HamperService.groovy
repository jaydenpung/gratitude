package com.tkm

import com.tkm.Hamper
import com.tkm.SearchContext
import com.tkm.SearchableField

class HamperService {

    def imageService

    final static fcn = [
        'like': 'like',
        'ilike': 'ilike',
        '=': 'eq',
        '!=': 'ne',
        '<=': 'le',
        '>=': 'ge',
        '<': 'lt',
        '>': 'gt',
        'isNull': 'isNull'
    ]

    static decorator = [
        'like': { '%' + it + '%' },
        'ilike': { '%' + it + '%' },
        '=': { it },
        '!=': { it },
        '<=': { it },
        '>=': { it },
        '<': { it },
        '>': { it },
        'isNull': { it },
        'isNotNull': { it }
    ]

    def search(SearchContext searchContext) {
        def rsp = [:]
        try {
            def criteria = Hamper.createCriteria()

            def resultList = criteria.list(max: searchContext.max ?: null, offset: searchContext.offset) {

                searchContext.fields.each {
                    def value = it.value
                    def name = it.name
                    def operator = it.operator

                    if (it.name == 'price') {
                        value = new BigDecimal(it.value)
                        "${fcn[operator]}"(name, decorator[operator](value))
                    }
                    else if (it.name == 'quantity') {
                        value = it.value.toLong()
                        "${fcn[operator]}"(name, decorator[operator](value))
                    }
                    else {
                        "${fcn[operator]}"(name, decorator[operator](value))
                    }
                }
                if (searchContext.sort != null && !searchContext.sort.isEmpty()) {
                    order(searchContext.sort, searchContext.order)
                }
                ne("status", EntityStatus.DELETED)
            }

            rsp.results = resultList
        }
        catch (Exception ex) {
            log.error("search() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def getHamperById(Long id) {
        def rsp = [:]
        try {
            def hamper = Hamper.withCriteria {
                eq('id', id)
                ne('status', EntityStatus.DELETED)
            }[0]

            if (!hamper) {
                throw new Exception ("Error getting hamper with id: ${id}")
            }

            rsp.result = hamper
        }
        catch (Exception ex) {
            log.error("getHamperById() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def save(Hamper hamper) {
        def rsp = [:]
        try {
		
			def products;
			
			if(hamper.products.id) {
				products = Product.withCriteria {
					inList('id', hamper.products.id)
				}
			}

            def invalidIds = hamper.products?.id - products?.id
            if (invalidIds) {
                throw new Exception ("Unable to get products with id: ${invalidIds}")
            }
			
			if (products) {
				hamper.products = new TreeSet(products)
			}

            hamper.save(flush: true, failOnError: true)
        }
        catch (Exception ex) {
            log.error("save() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def update(Hamper updatedHamper) {
        def rsp = [:]
        try {
            def hamper = Hamper.withCriteria {
                eq('id', updatedHamper.id)
                ne('status', EntityStatus.DELETED)
            }[0]

            if (!hamper) {
                throw new Exception ("Error getting hamper with id: ${updatedHamper.id}")
            }
			
			def products
			
			if (updatedHamper.products.id) {
				products = Product.withCriteria {
					inList('id', updatedHamper.products.id)
				}
			}            

            def invalidIds = updatedHamper.products?.id - products?.id
            if (invalidIds) {
                throw new Exception ("Unable to get products with id: ${invalidIds}")
            }

            // replace image
            if (hamper.image && updatedHamper.image) {
                def imageRsp = imageService.deleteImage(hamper.image)
                if (imageRsp.errors) {
                    throw new Exception (imageRsp.errors)
                }
                hamper.image = updatedHamper.image
            }
            else if (updatedHamper.image) {
                hamper.image = updatedHamper.image
            }

            hamper.name = updatedHamper.name
            hamper.shortDescription = updatedHamper.shortDescription
            hamper.description = updatedHamper.description
            hamper.price = updatedHamper.price
            hamper.quantity = updatedHamper.quantity
			
			if (products) {
				hamper.products = new TreeSet(products)
			}

            hamper.save(flush: true, failOnError: true)

            rsp.result = hamper
        }
        catch (Exception ex) {
            log.error("update() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }
    def delete(List<Long> ids) {
        def rsp = [:]
        try {
            def hampers = Hamper.withCriteria {
                inList('id', ids)
                ne('status', EntityStatus.DELETED)
            }

            def invalidIds = ids - hampers?.id
            if (invalidIds) {
                throw new Exception ("Unable to get hampers with id: ${invalidIds}")
            }

            hampers.each { hamper ->
                if (hamper.image) {
                    def imageRsp = imageService.deleteImage(hamper.image)
                    if (imageRsp.errors) {
                        throw new Exception (imageRsp.errors)
                    }
                }
                hamper.status = EntityStatus.DELETED
                hamper.save(flush: true, failOnError: true)
            }

            rsp.results = hampers
        }
        catch (Exception ex) {
            log.error("delete() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def enable(List<Long> ids) {
        def rsp = [:]
        try {
            def hampers = Hamper.withCriteria {
                inList('id', ids)
                ne('status', EntityStatus.DELETED)
                ne('enabled', true)
            }

            def invalidIds = ids - hampers?.id
            if (invalidIds) {
                throw new Exception ("Unable to get hampers with id: ${invalidIds}")
            }

            hampers.each { hamper ->
                hamper.enabled = true
                hamper.save(flush: true, failOnError: true)
            }

            rsp.results = hampers
        }
        catch (Exception ex) {
            log.error("delete() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def disable(List<Long> ids) {
        def rsp = [:]
        try {
            def hampers = Hamper.withCriteria {
                inList('id', ids)
                ne('status', EntityStatus.DELETED)
                ne('enabled', false)
            }

            def invalidIds = ids - hampers?.id
            if (invalidIds) {
                throw new Exception ("Unable to get hampers with id: ${invalidIds}")
            }

            hampers.each { hamper ->
                hamper.enabled = false
                hamper.save(flush: true, failOnError: true)
            }

            rsp.results = hampers
        }
        catch (Exception ex) {
            log.error("delete() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def getHampersInCart(List<Long> shoppingItemIds) {
        def rsp = [:]
        try {
            def hampers = Hamper.withCriteria {
                shoppingItem {
                    inList('id', shoppingItemIds)
                }
            }

            rsp.results = hampers
        }
        catch (Exception ex) {
            log.error("getHampersInCart() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }
}
