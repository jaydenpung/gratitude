package com.tkm

import com.metasieve.shoppingcart.IShoppable
import com.metasieve.shoppingcart.ShoppingItem
import grails.util.Environment

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

class Hamper implements Serializable, IEntity, IShoppable {

    Long id
    String name
    String shortDescription
    String description
    Image image
    BigDecimal price
    Long quantity
    SortedSet<Product> products = new TreeSet<Product>()
    boolean enabled = true

    ShoppingItem shoppingItem

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static hasMany = [
        products: Product,
    ]

    static mapping = {
        table 'HAMPER'
        products lazy: false
        description type: 'text'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'HAMPER_SEQ']
        }
    }

    static constraints = {
        name(size: 1..100)
        shortDescription(nullable: true, size: 1..150)
        description(nullable: true, size: 1..100000)
        price(size: 1..20)
        products(nullable: true)
        quantity(size: 1..20)
        enabled()
        image(nullable: true)
        shoppingItem(nullable: true)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
