package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

import com.metasieve.shoppingcart.ShoppingCart
import grails.util.Environment

class Transaction implements Serializable, IEntity {

    Long id
    SecUser user
    BigDecimal totalAmount
    ShoppingCart shoppingCart

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus = PendingStatus.PENDING_CONFIRM
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'TRANSACTION'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'TRANSACTION_SEQ']
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
