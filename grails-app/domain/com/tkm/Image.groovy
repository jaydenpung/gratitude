package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

class Image implements Serializable, IEntity {

    String name
    String generatedName
    String path
    String type

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus = PendingStatus.PENDING_NONE
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'IMAGE'
    }

    static constraints = {
        name(size: 1..100)
        generatedName(size: 1..1000)
        path(size: 1..200)
        type(nullable: true)

        // IEntity
        status()
        pendingStatus()
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
