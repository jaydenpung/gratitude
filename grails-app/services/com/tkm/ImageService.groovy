package com.tkm

import org.springframework.web.multipart.commons.CommonsMultipartFile
import grails.util.Holders
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.Files

import com.tkm.Hamper
import com.tkm.SearchContext
import com.tkm.SearchableField

class ImageService {

    def grailsApplication

    final static fcn = [
        'like': 'like',
        'ilike': 'ilike',
        '=': 'eq',
        '!=': 'ne',
        '<=': 'le',
        '>=': 'ge',
        '<': 'lt',
        '>': 'gt',
        'isNull': 'isNull'
    ]

    static decorator = [
        'like': { '%' + it + '%' },
        'ilike': { '%' + it + '%' },
        '=': { it },
        '!=': { it },
        '<=': { it },
        '>=': { it },
        '<': { it },
        '>': { it },
        'isNull': { it },
        'isNotNull': { it }
    ]

    def uploadImage(CommonsMultipartFile file, String imagePath) {
        def rsp = [:]
        try {
            //TODO: File Type Checking (Only image allowed)
            //TODO: File Size Checking (Less than 1mb)
            //TODO: Remove hardcoded .png, replace with image type
            def generatedImageName = java.util.UUID.randomUUID().toString() + ".png"

            //For storage in file systems
            def servletContext = Holders.getServletContext()
            def storagePath = servletContext.getRealPath(imagePath)

            def storagePathDirectory = new File(storagePath)

            if (!storagePathDirectory.exists()) {
                if (!storagePathDirectory.mkdirs()) {
                    throw new Exception ("Unable to create directory: ${storagePathDirectory}")
                }
            }

            storagePath += "/" + generatedImageName
            file.transferTo(new File(storagePath))

            //For database
            imagePath += "/" + generatedImageName
            def oriName = file.getOriginalFilename()

            def image = new Image(
                name: oriName,
                path: imagePath
            ).save(flush: true, failOnError: true)

            rsp.result = image
        }
        catch (Exception ex) {
            log.error("uploadFile() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def deleteImage(Image image) {
        def rsp = [:]
        try {
                def servletContext = Holders.getServletContext()
                def oldImagePath = servletContext.getRealPath(image.path)
                def oldImage = new File(oldImagePath).delete()
        }
        catch (Exception ex) {
            log.error("deleteImage() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }

    def saveImage(String imagePath) {
        def rsp = [:]
        try {
            def servletContext = Holders.getServletContext()
            def storePath = grailsApplication.config.storage.hamperImage
            def generatedImageName = java.util.UUID.randomUUID().toString() + ".png"

            def newFilePath = storePath + "/" + generatedImageName

            def relativePath = servletContext.getRealPath(imagePath)
            def newRelativePath = servletContext.getRealPath(newFilePath)

            def fileEx = new File(relativePath)
            def fileDest = new File(newRelativePath)

            def fileExPath = fileEx.toPath()
            def fileDestPath = fileDest.toPath()

            Files.copy(fileExPath, fileDestPath)

            def image = new Image(
                name: generatedImageName,
                path: newFilePath
            ).save(flush: true, failOnError: true)

            rsp.result = image
        }
        catch (Exception ex) {
            log.error("saveImage() failed: ${ex.message}", ex)
            rsp.errors = ex.message
        }
        return rsp
    }
}
