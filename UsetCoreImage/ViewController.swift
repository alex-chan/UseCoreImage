//
//  ViewController.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SunsetPlayerViewControllerDelegate {

  
    
    var isPlaying = false
    
    var movie : SunsetMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var testURL = NSBundle.mainBundle().URLForResource("czz", withExtension: "MOV")
        movie = SunsetMovie(URL: testURL!)
        
        var filter = SunsetFilter(name: "CIPhotoEffectProcess") // CIMotionBlur raise exception
        movie!.addTarget(filter)
        
//        var child = childViewControllers[0] as SunsetPlayerViewController
//        
//        child.delegate = self
//        
//        filter.addTarget(child.playerView as SunsetView)
        var outputFilePath: String = NSTemporaryDirectory().stringByAppendingPathComponent( "test".stringByAppendingPathExtension("mov")!)
        
        if NSFileManager.defaultManager().fileExistsAtPath(outputFilePath) {
            var error: NSError? = nil
            if NSFileManager.defaultManager().removeItemAtPath(outputFilePath, error: &error) == false{
                println("remove item at path \(outputFilePath) error: \(error) ")
            }
        }

        var movieURL = NSURL(fileURLWithPath: outputFilePath)!
        
        var movieWriter = SunsetMovieWriter(newMovieURL: movieURL, newSize: CGSizeMake(640 , 360) )
        
//        filter.addTarget(movieWriter)
        
        movie!.addTarget(movieWriter)
        
        movieWriter.startRecording()
        movie!.start()
//        child.play()
        
        
//        var delayInSeconds  = 10
        var t = Int64( 5 * NSEC_PER_SEC )
        var stopTime = dispatch_time(DISPATCH_TIME_NOW, t )
        
        dispatch_after(stopTime, dispatch_get_main_queue(), {
            
            movieWriter.finishRecording()
            println("finish recording")
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func play(){
        movie!.play()
    }
    func pause(){
       
        movie!.pause()
       
    }



}

