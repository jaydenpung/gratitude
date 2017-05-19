package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

class Image implements Serializable, IEntity {

    Long id
    String name
    String path
    String type

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'IMAGE'
        id generator:'sequence', params: [sequence: 'IMAGE_SEQ']
    }

    static constraints = {
        name(size: 1..100)
        path(size: 1..200)
        type(nullable: true)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
