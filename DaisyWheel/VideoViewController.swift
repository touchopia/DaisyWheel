//
//  VideoViewController.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/1/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoviePlayer" {
            let destination = segue.destination as! AVPlayerViewController
            
            if let path = Bundle.main.path(forResource: "GITGirlsProgram", ofType:"mp4") {
                let url = URL(fileURLWithPath: path)
                destination.player = AVPlayer(url: url)
            }
        }
    }
}
