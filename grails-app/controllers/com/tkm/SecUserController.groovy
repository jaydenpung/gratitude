package com.tkm

import grails.converters.JSON
import com.metasieve.shoppingcart.SessionUtils

import com.tkm.SearchContext
import com.tkm.SecUser
import com.tkm.UserProfile

class SecUserController {

	def register() {
        def success = true
        def registerMessage = ""
        def email = params['email']
        def password = params['password']
        def rePassword = params['rePassword']
            
        try{
        	

        	if (password != rePassword) {
                registerMessage = "Passwords did not match!"
                success = false
        	}

            if (SecUser.findByUsername(email)) {
                registerMessage = "Email already exist!"
                success = false
            }

        }
        catch (Exception ex) {
            log.error("register() failed: ${ex.message}", ex)
        }

        if (success) {
            render ( [success: createUser(email, password)] as JSON )
        } 
        else {
            render([success: success, registerMessage: registerMessage] as JSON)
        }
    }

    def createUser(String email, String password) {
        try {
            def userProfile = new UserProfile(
                name: "",
                email: email,
                address: "",
                phoneNo: "",
            ).save(flush: true, failOnError: true)

            def secUser = new SecUser(
                username: email,
                password: password,
                userProfile: userProfile,
            ).save(flush: true, failOnError: true)
        }
        catch (Exception ex) {
            log.createUser("createUser() failed: ${ex.message}", ex)
            return false
        }

        return true
    }

    def getSessionId() {
        try {
            render ([sessionId: SessionUtils.getSession().id] as JSON)
        }
        catch (Exception ex) {
            log.createUser("getSessionId() failed: ${ex.message}", ex)
        }
    }
}
