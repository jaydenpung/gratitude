package com.tkm

import grails.util.Environment

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

class Product implements Serializable, IEntity {

    Long id
    String name
    String description
    Image image

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'PRODUCT'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'HAMPER_SEQ']
        }
    }

    static constraints = {
        name(size: 1..100)
        description(nullable: true, size: 1..1000)
        image(nullable: true)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
