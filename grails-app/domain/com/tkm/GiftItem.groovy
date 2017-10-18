package com.tkm

import com.tkm.IEntity
import com.tkm.EntityStatus
import com.tkm.PendingStatus

import com.metasieve.shoppingcart.ShoppingCart
import grails.util.Environment

class GiftItem implements Serializable, IEntity, Comparable<GiftItem> {

    Long id
    Long hamperId
    String giftMessage
    Recipient recipient
    BigDecimal price

    // IEntity
    EntityStatus status = EntityStatus.ACTIVE
    PendingStatus pendingStatus
    Date dateCreated
    Date lastUpdated
    String createdBy = '_SYSTEM_'
    String updatedBy = '_SYSTEM_'

    static mapping = {
        table 'GIFT_ITEM'

        if (Environment.isDevelopmentMode()) {
            id generator:'sequence', params: [sequence: 'GIFT_ITEM_SEQ']
        }
    }

    static constraints = {
        giftMessage(nullable: true)

        // IEntity
        status()
        pendingStatus(nullable: true)
        dateCreated()
        lastUpdated()
        createdBy(size: 1..50)
        updatedBy(size: 1..50)
    }

    public int compareTo(GiftItem o) {
        return id - o.id
    }
}
