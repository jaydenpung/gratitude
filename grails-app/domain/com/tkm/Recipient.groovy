package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

import com.metasieve.shoppingcart.ShoppingCart
import grails.util.Environment

class Recipient implements Serializable, IEntity, Comparable<Recipient> {

    Long id
    String name
    String contactNo
    String address

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'RECIPIENT'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'RECIPIENT_SEQ']
        }
    }

    static constraints = {

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }

    public int compareTo(Recipient o) {
        return id - o.id
    }
}
