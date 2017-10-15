package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

import grails.util.Environment

class UserProfile implements Serializable, IEntity {

    Long id
    String name
    String email
    String address
    String phoneNo

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'USER_PROFILE'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'USER_PROFILE_SEQ']
        }
    }

    static constraints = {
        name(size: 1..100, nullable: true)
        email(size: 1..100)
        address(size: 1..200, nullable: true)
        phoneNo(size: 1..20, nullable: true)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }
}
