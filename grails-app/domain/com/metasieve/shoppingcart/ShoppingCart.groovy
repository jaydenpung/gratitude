package com.metasieve.shoppingcart

import com.tkm.GiftItem

class ShoppingCart {
	static hasMany = [items : ShoppingItem, giftItems: GiftItem]
	
	Date dateCreated
   	Date lastUpdated
	
	String sessionID
	String lastURL

	SortedSet<GiftItem> giftItems = new TreeSet<GiftItem>()
	
	Boolean checkedOut = false

	static constraints = {
		lastURL(url:true, nullable:true, blank: true)
		sessionID(blank:false)
		giftItems(nullable: true)
	}
}
