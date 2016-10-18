//
//  WheelViewController.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class WheelViewController: UIViewController, SpinWheelDelegate {
    
    fileprivate var tipImage   = UIImageView()
    fileprivate var wheelCover = SpinImageView()
    fileprivate var wheelImage = SpinImageView()
    
    fileprivate let wheelCoverImage = UIImage(named: "wheelCover")!
    fileprivate let wheelTipsImage = UIImage(named: "wheelTips")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let wheelFrame = self.view.frame
        tipImage = UIImageView(image: wheelTipsImage)
        tipImage.isUserInteractionEnabled = false
        
        let tipFrame = tipImage.frame
        tipImage.frame = CGRect(x: 0, y: 86, width: tipFrame.size.width, height: tipFrame.size.height)
        tipImage.center = CGPoint(x:width / 2, y: 180)
        
        wheelImage = SpinImageView(frame: wheelFrame, image: wheelTipsImage)
        wheelImage.isUserInteractionEnabled = true
        wheelImage.delegate = self
        
        // Wheel Cover
        wheelCover = SpinImageView(frame: wheelFrame, image: wheelCoverImage)
        wheelCover.isUserInteractionEnabled = false
        
        self.view.addSubview(wheelImage)
        self.view.addSubview(wheelCover)
        self.view.addSubview(tipImage)
        self.showTipNumber(1)
    }
    
    func playClick() {
        
    }
    
    func spinWheelDidStartSpinningFromInertia(_ wheel: SpinningWheel) {
        
    }
    
    func showTipNumber(_ number: Int) {
        let tipImageString = "i_tip-\(number).png"
        tipImage.isHidden = false
        if let tip = UIImage(named: tipImageString) {
            tipImage.image = tip
        }
    }
    
    func spinWheelDidFinishSpinning(_ wheel: SpinningWheel) {
        
        let ceilValue = CGFloat(ceil(fabs(wheel.angle)))
        let floorValue = CGFloat(floor(fabs(wheel.angle)))
        var rounded : CGFloat = 0
        let calculatedFloorValue =  CGFloat(fabs(floorValue))*0.78 + 0.39
        let calculatedCeilValue  =  CGFloat(fabs(ceilValue))*0.78 + 0.39
        let theAngle = CGFloat(fabs(wheel.angle))
        
        if theAngle > calculatedFloorValue && theAngle > calculatedCeilValue {
            rounded = ceilValue + 1;
        }
        else if theAngle > calculatedFloorValue && theAngle < calculatedCeilValue {
            if theAngle - calculatedFloorValue > calculatedCeilValue - theAngle {
                rounded = ceilValue
            } else {
                rounded = floorValue
            }
        }
        else if theAngle < calculatedFloorValue {
            rounded = floorValue
        }
        
        if theAngle < 0 {
            rounded = -rounded;
        }
        
        let newAngle = CGFloat(rounded * 0.78)
        
        if (wheel.isSpinning) {
            wheel.moveFromAngle(wheel.angle, toAngle: newAngle)
        }
        print("Rounded: \(rounded)")
        if rounded >= 8 {
            rounded -= 8;
        }
        if rounded >= 0 {
            self.showTipNumber(Int(rounded) + 1)
        } else if rounded < 0 {
            self.showTipNumber(Int(rounded) + 9)
        }
        if rounded == 0 {
            tipImage.isHidden = true
        }
    }
    
    func spinWheelAngleDidChange(_ wheel: SpinningWheel) {
        print("moving angle to \(wheel.angle)")
    }
    
    func spinWheelShouldBeginTouch(_ wheel: SpinningWheel) -> Bool {
        print("spinWheelShouldBeginTouch")
        tipImage.isHidden = false
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transitioning...")
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        switch orientation {
        case .portrait:
            print("Portrait")
        case .landscapeLeft:
            print("LandscapeLeft")
        case .landscapeRight:
            print("LandscapeRight")
        case .portraitUpsideDown:
            print("PortraitUpsideDown")
        case .unknown:
            print("Unknown")
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
