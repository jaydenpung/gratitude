package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

import com.metasieve.shoppingcart.ShoppingCart
import org.grails.paypal.Payment
import grails.util.Environment

class Transaction implements Serializable, IEntity {

    Long id
    SecUser user
    BigDecimal totalAmount
    ShoppingCart shoppingCart
    Payment payment
    boolean completed = false

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'CART'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'HAMPER_SEQ']
        }
    }

    static constraints = {
        user()
        totalAmount(size: 1..100)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
