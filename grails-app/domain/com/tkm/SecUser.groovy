package com.tkm

class SecUser {

    transient springSecurityService

    String username
    String password
    String passwordResetToken
    boolean enabled = true
    boolean accountExpired = false
    boolean accountLocked = false
    boolean passwordExpired = false
    UserProfile userProfile

    static transients = ['springSecurityService']

    static constraints = {
        username blank: false, unique: true
        password blank: false
        passwordResetToken nullable: true
    }

    static mapping = {
        password column: '`password`'
    }

    Set<Role> getAuthorities() {
        SecUserRole.findAllBySecUser(this).collect { it.role }
    }

    def beforeInsert() {
        encodePassword()
    }

    def beforeUpdate() {
        if (isDirty('password')) {
            encodePassword()
        }
    }

    protected void encodePassword() {
        password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
    }
}
