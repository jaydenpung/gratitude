package com.tkm

import grails.plugin.cache.*

class ImageController {

    def imageService
    def grailsApplication

    def renderImage() {
        try {
                def image = Image.findByGeneratedName(params.id + ".png")
                def etag = "${image.ident()}:${image.version}"             
                def header = request.getHeader('If-None-Match')

                if (header != etag) {
                    response.setHeader('ETag', etag)

                    String profilePicturePath = "${grailsApplication.config.storage.hamperImage}/${params.id}.png"
                    File file = new File(profilePicturePath)
                    response.contentType = URLConnection.guessContentTypeFromName(file.getName())
                    response.outputStream << file.bytes
                    response.outputStream.flush()
                }
                else {
                    response.sendError(304) // Not modified
                }
            }
        catch(Exception ex) {
            log.error("renderImage() failed: ${ex.message}", ex)
        }
    }
}
