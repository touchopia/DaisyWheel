//
//  WheelImageView.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/6/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit

protocol SpinWheelDelegate {
    func spinWheelDidStartSpinningFromInertia(spinWheel:SpinningWheelView)
    func spinWheelDidFinishSpinning(spinWheel: SpinningWheelView)
    func spinWheelAngleDidChange(spinWheel: SpinningWheelView)
    func spinWheelShouldBeginTouch(spinWheel: SpinningWheelView) -> Bool
}

class SpinningWheelView: UIView {

    var enableSpinning = false
    var isSpinning = false
    var angle: CGFloat = 0.0
    var drag: CGFloat = 0.0
    var initialAngle : Double = 0
    var isAnimating = false
    var angularVelocity: CGFloat = 0.0
    
    var lastTimerDate: NSDate?
    var displayTimer: CADisplayLink?
    var previousTouchDate: NSDate?
    var currentTouch: UITouch?
    
    var delegate: SpinWheelDelegate?
    
    func moveFromAngle(fromAngle: CGFloat,toAngle: CGFloat) {
        
    }
    
    func startAnimating() {
        
    }
    
    func stopAnimating() {
        
    }
    
    func animationTimer() {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var shouldReact = true
        
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func angleForPoint(point: CGPoint) -> CGFloat {
        return 0.0
    }
    
    func calculateFinalAngularVelocity(touch: UITouch) -> CGFloat {
        
        var finalVelocity : CGFloat = 0.0
        
        if let touchDate = previousTouchDate {
            
            let delay = NSDate().timeIntervalSinceDate(touchDate)
            let prevAngle = self.angleForPoint(touch.previousLocationInView(self))
            let endAngle = self.angleForPoint(touch.locationInView(self))
            finalVelocity = (endAngle - prevAngle) / CGFloat(delay)
        }
        
        return finalVelocity
    }

}
