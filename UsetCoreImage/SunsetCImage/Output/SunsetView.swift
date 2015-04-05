//
//  SunsetView.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import UIKit

class SunsetView: UIView, SunsetInputDelegate {
    
    
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) {
        
        println("processMovieFrame")
        var ciImage =  CIImage(CVPixelBuffer: pixelBuffer)
        var tempContext = CIContext(options: nil)
        var width = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        var height =  CGFloat( CVPixelBufferGetHeight(pixelBuffer) )
        var videoImage = tempContext.createCGImage(ciImage, fromRect: CGRectMake(0, 0, width, height))
        
        self.layer.contents = videoImage
        
    }
    
    func dispatchCGImage(cgImage: CGImage){
        
        self.layer.contents = cgImage
    }
    
    
    
}