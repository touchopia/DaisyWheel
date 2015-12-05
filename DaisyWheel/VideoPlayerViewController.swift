//
//  VideoPlayerViewController.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/1/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {

    var player : AVPlayer?
    var tabBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("toggleTabBar"))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = true
        showOrHideTabBar(false, animated: true)
        playVideo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        showOrHideTabBar(true, animated: false)
    }

    func playVideo() {
        let path = NSBundle.mainBundle().pathForResource("GITGirlsProgram", ofType:"mp4")
        let url = NSURL.fileURLWithPath(path!)
        self.player = AVPlayer(URL: url)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        player?.play()
    }
    
    func toggleTabBar() {
        showOrHideTabBar(!tabBarHidden, animated: true)
    }
    
    func showOrHideTabBar(visible:Bool, animated:Bool) {

        tabBarHidden = visible
        
        if let frame = self.tabBarController?.tabBar.frame {
            let height = frame.size.height
            let offsetY = (visible ? -height : height)
            
            let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
            
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame, 0, offsetY)
                return
            }
        }
    }
    
    func tabBarIsVisible() -> Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }


}

