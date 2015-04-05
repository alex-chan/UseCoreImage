//
//  SunsetMovieWriter.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import AVFoundation
import AssetsLibrary

class SunsetMovieWriter: SunsetInputDelegate {
    
    

    var assetWriter: AVAssetWriter
    var assetWriterVideoInput: AVAssetWriterInput?
    var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor?
    
    var isRecording = false
    
    var frameBuffer : CGImage?
    
    var saveToPhotoAlbum = true
    
    var movieWriterQueue : dispatch_queue_t
    
    var movieURL : NSURL
    
    var presentationTime = kCMTimeZero
    
    init(newMovieURL: NSURL, newSize: CGSize, fileType : String, outputSettings: [NSObject: AnyObject]?){
        
        movieURL = newMovieURL
        movieWriterQueue = dispatch_queue_create("MovieWriterQueue.sunset", DISPATCH_QUEUE_SERIAL)
        
        var error: NSError?
        assetWriter = AVAssetWriter(URL: newMovieURL, fileType: fileType, error: &error)
        if error != nil{
            println("Error recording movie:\(error!.localizedDescription)")
            // TODO: Error handling
            return
        }
        assetWriter.movieFragmentInterval = CMTimeMakeWithSeconds(1.0, 1000)
        var outSettings : [NSObject: AnyObject]
        if outputSettings == nil {
            outSettings = [ AVVideoCodecKey: AVVideoCodecH264,
                AVVideoWidthKey: Int(newSize.width),
                AVVideoHeightKey: Int(newSize.height)]
        }else{
            let o = outputSettings!
            let condition = (o[AVVideoCodecKey] == nil || o[AVVideoWidthKey] == nil || o[AVVideoHeightKey] == nil)
            assert(!condition, "outputSetting parameter error")
            outSettings = o
        }
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outSettings)
        
        var sourcePixeBufferAttributes :[NSObject: AnyObject] = [
            kCVPixelBufferPixelFormatTypeKey:  kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, //kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey: Int(newSize.width),
            kCVPixelBufferHeightKey: Int(newSize.height)
        ]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput, sourcePixelBufferAttributes: sourcePixeBufferAttributes)
        
        if assetWriter.canAddInput(assetWriterVideoInput){
            assetWriter.addInput(assetWriterVideoInput)
        }
        
        
        
        
        
    }
    
    
    convenience init(newMovieURL: NSURL, newSize size: CGSize){
        self.init(newMovieURL: newMovieURL, newSize: size, fileType: AVFileTypeQuickTimeMovie, outputSettings:nil)
    }
    
    
    func startRecording(){
        println("start recording")
        if !assetWriter.startWriting() {
            println("Error:\(assetWriter.error.localizedDescription)")
            return            
        }
        println("assetWriterStatus:\(assetWriter.status.rawValue)")
        assetWriter.startSessionAtSourceTime(kCMTimeZero)
        isRecording = true
    }
    

//        self.finishRecordingWithCompletionHandler(nil)
//    }
//    
//    typealias FinishRecordingWithCompletionHandler = ( (void)handler ) -> Void
//    
//    func finishRecordingWithCompletionHandler(handler: FinishRecordingWithCompletionHandler){
        
        
    func finishRecording(){
        
        println("finishRecording")
        
        dispatch_async(movieWriterQueue, {
            if self.assetWriter.status == .Completed || self.assetWriter.status == .Cancelled || self.assetWriter.status == .Unknown {
                //            if handler {
                //                // TODO: handler
                //            }
                return
            }
            if self.assetWriter.status == .Writing {
                self.assetWriterVideoInput!.markAsFinished()
                if self.saveToPhotoAlbum {
                    self.saveMovieToPhotoAlbum()
                }
            }
        })
        

    }
    
    
    func saveMovieToPhotoAlbum(){
        println("saveMovieToPhotoAlbum")
        self.assetWriter.finishWritingWithCompletionHandler({
            var lib = ALAssetsLibrary()
            lib.writeVideoAtPathToSavedPhotosAlbum(self.movieURL, completionBlock: {
                (assetURL: NSURL!, error: NSError!) in
                if error != nil {
                    println("saveToPhotoAlbum error:\(error.localizedDescription)")
                }
            })
            
        })
    }
    
    // M?ARK: SunsetInput delegates
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) -> Void{
        println("processMovieFrame:\(assetWriter.status.rawValue)")
        if assetWriter.status == .Failed {
            println("Error: \(assetWriter.error.localizedDescription)")
        }
        
    
        if !assetWriterVideoInput!.readyForMoreMediaData {
            return
        }else if assetWriter.status == .Writing {
            
            assetWriterPixelBufferInput!.appendPixelBuffer(pixelBuffer, withPresentationTime: presentationTime)
            
            presentationTime = CMTimeAdd(presentationTime, CMTimeMake(1, 30))
            
        }else{
            println("assetWriterStatus:\(assetWriter.status.rawValue), Error: \(assetWriter.error.localizedDescription)")
            println("Could not write a frame")
        }
        
        
        return
    }
    func dispatchCGImage(image: CGImage) -> Void {
     
        frameBuffer = image
        
        
        
        return
    }
}