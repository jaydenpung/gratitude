/* Copyright 2013-2014 SpringSource.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.tkm

import grails.converters.JSON
import grails.plugin.springsecurity.*

import javax.servlet.http.HttpServletResponse

import org.springframework.security.access.annotation.Secured
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.web.WebAttributes


import java.security.MessageDigest

@Secured('permitAll')
class LoginController {

    /**
     * Dependency injection for the authenticationTrustResolver.
     */
    def authenticationTrustResolver

    /**
     * Dependency injection for the springSecurityService.
     */
    def springSecurityService

    /**
     * Default action; redirects to 'defaultTargetUrl' if logged in, /login/auth otherwise.
     */
    def index() {
        if (springSecurityService.isLoggedIn()) {
            redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
        }
        else {
            redirect action: 'auth', params: params
        }
    }

    /**
     * Show the login page.
     */
    def auth() {

        def config = SpringSecurityUtils.securityConfig

        if (springSecurityService.isLoggedIn()) {
            redirect uri: config.successHandler.defaultTargetUrl
            return
        }

        String view = 'auth'
        String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"
        render view: view, model: [postUrl: postUrl,
                                   rememberMeParameter: config.rememberMe.parameter]
    }

    /**
     * The redirect action for Ajax requests.
     */
    def authAjax() {
        response.setHeader 'Location', SpringSecurityUtils.securityConfig.auth.ajaxLoginFormUrl
        response.sendError HttpServletResponse.SC_UNAUTHORIZED
    }

    /**
     * Show denied page.
     */
    def denied() {
        if (springSecurityService.isLoggedIn() &&
                authenticationTrustResolver.isRememberMe(SCH.context?.authentication)) {
            // have cookie but the page is guarded with IS_AUTHENTICATED_FULLY
            redirect action: 'full', params: params
        }
    }

    /**
     * Login page for users with a remember-me cookie but accessing a IS_AUTHENTICATED_FULLY page.
     */
    def full() {
        def config = SpringSecurityUtils.securityConfig
        render view: 'auth', params: params,
            model: [hasCookie: authenticationTrustResolver.isRememberMe(SCH.context?.authentication),
                    postUrl: "${request.contextPath}${config.apf.filterProcessesUrl}"]
    }

    /**
     * Callback after a failed login. Redirects to the auth page with a warning message.
     */
    def authfail() {

        String msg = ''
        def exception = session[WebAttributes.AUTHENTICATION_EXCEPTION]
        if (exception) {
            if (exception instanceof AccountExpiredException) {
                msg = g.message(code: "springSecurity.errors.login.expired")
            }
            else if (exception instanceof CredentialsExpiredException) {
                msg = g.message(code: "springSecurity.errors.login.passwordExpired")
            }
            else if (exception instanceof DisabledException) {
                msg = g.message(code: "springSecurity.errors.login.disabled")
            }
            else if (exception instanceof LockedException) {
                msg = g.message(code: "springSecurity.errors.login.locked")
            }
            else {
                msg = g.message(code: "springSecurity.errors.login.fail")
            }
        }

        if (springSecurityService.isAjax(request)) {
            render([error: msg] as JSON)
        }
        else {
            flash.message = msg
            redirect action: 'auth', params: params
        }
    }

    /**
     * The Ajax success redirect url.
     */
    def ajaxSuccess() {
        render([success: true, username: springSecurityService.authentication.name] as JSON)
    }

    /**
     * The Ajax denied redirect url.
     */
    def ajaxDenied() {
        render([error: 'access denied'] as JSON)
    }

    def logout() {
        session.invalidate()
        redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl // '/j_spring_security_logout'
    }

    def forgotPassword() {
    }

    def submitForgotPassword() {

        def email = params.email
        def user = SecUser.findByUsername(email)

        if (user) {
            def generator = { String alphabet, int n ->
                new Random().with {
                    (1..n).collect {
                        alphabet[ nextInt(alphabet.length()) ]}.join()
                }
            }

            def token1 = generator( (('A'..'Z') + ('0'..'9')).join(), 15)
            def token2 = MessageDigest.getInstance("MD5").digest((user.username).bytes).encodeHex().toString()

            user.passwordResetToken = "${token1}${token2}"
            user.save(flush: true)

            sendMail {
                async true
                to email
                subject "Gratitude Hampers - Reset Password"
                body "It seems you have forgot your password? Please click on this link to reset your password: ${createLink(absolute: true, action: 'resetPassword', controller:'login', params: [token: user.passwordResetToken])}"
            }
        }

        flash.message = "We have sent you an email with the password reset link. Please check your email."
        redirect(action: 'forgotPassword')
    }

    def resetPassword() {
        def success = false
        def user
        def token

        try {
            token = params.token
            user = SecUser.findByPasswordResetToken(token)

            if (user) {

                if (user.passwordResetToken) {
                    success = true
                }
                else {
                    throw new Exception ("resetPassword() : User Token is null ${user.passwordResetToken}")
                }
            }
            else {
                throw new Exception ("resetPassword() : Can't find user with token ${token}")
            }
        }
        catch (Exception ex) {
            redirect(action: 'forgotPassword')
        }

        if (!success) {
            redirect(action: 'forgotPassword')
        }

        [ username: user.username, token: token ]
    }

    def submitResetPassword() {
        def token = params.token
        def password = params.password
        def success = false
        def user

        try {
            user = SecUser.findByPasswordResetToken(token)

            if (user && token) {

                if (user.passwordResetToken) {
                    user.passwordResetToken = null
                    user.password = password
                    user.save(flush: true)
                    success = true
                }
                else {
                    throw new Exception ("submitResetPassword() : User Token is null ${user.passwordResetToken}")
                }
            }
            else {
                throw new Exception ("submitResetPassword() : Can't find user with token ${token}")
            }
        }
        catch (Exception ex) {
            redirect(action: 'forgotPassword')
        }

        if (success) {
            sendMail {
                async true
                to user.username
                subject "Gratitude Hampers - Password Changed"
                body "Your password has recently been changed. Please contact us if you are not aware of this."
            }

            flash.message = "Password changed successfully."
            redirect(action: 'auth')
        }
    }
}
