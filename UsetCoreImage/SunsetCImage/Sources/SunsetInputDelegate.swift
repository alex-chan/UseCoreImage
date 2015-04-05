//
//  SunsetInput.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import AVFoundation


protocol SunsetInputDelegate {
    
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) -> Void
    func dispatchCGImage(image: CGImage) -> Void

}