//
//  SunetPlayerViewController.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import UIKit


protocol SunsetPlayerViewControllerDelegate {
    func play()
    func pause()
    
}


class SunsetPlayerViewController : UIViewController{
    
    
    
//    @IBOutlet var playerView: UIView!
   
    @IBOutlet weak var playerView: UIView!
  
    @IBOutlet weak var playPauseBtn: UIButton!
    
    var isPlaying = false
    
    var delegate : SunsetPlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI(){
//        controlsToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
//        controlsToolbar.setShadowImage(UIImage(), forToolbarPosition: .Any)
        
    }
    
    override func loadView() {
        var views =  NSBundle.mainBundle().loadNibNamed("SunsetPlayerView", owner: self, options: nil)
        self.view = views[0] as UIView
        
    }
    
    func play(){
        isPlaying = true
        playPauseBtn.setTitle("Pause", forState: .Normal)
        if let delegate = delegate {
            delegate.play()
        }
        
    }
    func pause(){
        isPlaying = false
        playPauseBtn.setTitle("Play", forState: .Normal)
        if let delegate = delegate {
            delegate.pause()
        }
    }
    
    @IBAction func playOrPause(sender: UIButton) {
        if isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }

    
}