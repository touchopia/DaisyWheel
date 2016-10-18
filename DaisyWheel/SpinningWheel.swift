//
//  SpinningWheel.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class SpinningWheel: UIView {
    
    open var enableSpinning = false
    open var isSpinning = false
    open var isAnimating = false
    
    open var angle: CGFloat = 0.0 {
        didSet {
            delegate?.spinWheelAngleDidChange(self)
        }
    }
    
    fileprivate var drag: CGFloat = 0.0
    fileprivate var angularVelocity: CGFloat = 0.0
    fileprivate var initialAngle: CGFloat = 0.0
    fileprivate var lastTimerDate: Date?
    fileprivate var displayTimer: CADisplayLink?
    fileprivate var previousTouchDate: Date?
    fileprivate var currentTouch: UITouch?
    
    open var delegate: SpinWheelDelegate?
    
    //MARK: - Animation Methods

    func startAnimating() {
        
        delegate?.spinWheelDidStartSpinningFromInertia(self)
        
        isSpinning = false
        lastTimerDate = nil
        displayTimer = CADisplayLink(target: self, selector: #selector(SpinningWheel.animationTimer))
        displayTimer?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func stopAnimating() {
        delegate?.spinWheelDidFinishSpinning(self)
        
        isSpinning = false
        
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    func animationTimer() {
        
        if lastTimerDate == nil {
            lastTimerDate = Date()
        }
        else if lastTimerDate != nil && angularVelocity == 0 {
            lastTimerDate = Date()
            self.stopAnimating()
        }
        else {
            
            if let timerDate = lastTimerDate {
                let passed = Date().timeIntervalSince(timerDate)
                let angleReduction = drag * CGFloat(passed) * abs(angularVelocity)
            
                if (angularVelocity < 0) {
                    angularVelocity += angleReduction
                }
                
                if angularVelocity > 0 {
                    angularVelocity = 0
                }
                else if angularVelocity > 0 {
                    angularVelocity -= angleReduction;
                
                    if angularVelocity < 0 {
                        angularVelocity = 0
                    }
                }
            
                if abs(angularVelocity) < 0.01 {
                    angularVelocity = 0;
                }
            
                var useAngle = self.angle
                
                useAngle += angularVelocity * CGFloat(passed)
            
                // limit useAngle to +/- 2*PI
            
                let pi = CGFloat(2 * M_PI)
                
                if useAngle < 0 {
                    while useAngle < -pi {
                        useAngle += pi
                    }
                } else {
                    while useAngle > pi {
                        useAngle -= pi
                    }
                }
            
                self.angle = useAngle
                
                print(angularVelocity)
                print(lastTimerDate)
                
                lastTimerDate = Date()
                
                self.setNeedsDisplay()
            }
        }
    }
    
    //MARK: - Calculation Methods
    
    func calculateFinalAngularVelocity(_ touch: UITouch) -> CGFloat {
        var finalVelocity: CGFloat = 0.0
        
        if let touchedDate = previousTouchDate {
            let today = Date()
            let delay = today.timeIntervalSince(touchedDate)
            let prevAngle = self.angleForPoint(touch.previousLocation(in: self))
            let endAngle = self.angleForPoint(touch.location(in: self))
            finalVelocity = CGFloat(endAngle - prevAngle) / CGFloat(delay)
        }
        return finalVelocity
    }
    
    func angleForPoint(_ point: CGPoint) -> CGFloat {
        
        var newAngle = atan2(point.y - self.frame.size.height / 2, point.x - self.frame.size.width / 2)
        
        if (newAngle < 0) {
            newAngle += CGFloat(M_PI * 2)
        }
        return newAngle
    }
    
    //MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesBegan")
        
        var shouldReact = true
        
        if let delegate = delegate {
            shouldReact = delegate.spinWheelShouldBeginTouch(self)
        }
        
        if shouldReact && (currentTouch == nil || (currentTouch?.phase == UITouchPhase.cancelled || currentTouch?.phase == UITouchPhase.ended)) {
            currentTouch = touches.first
            angularVelocity	= 0;
            initialAngle = angle;
            previousTouchDate = Date()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesMoved")
        
        if let touch = currentTouch {
            
            if touches.contains(touch) {
                let touchPoint	= touch.location(in: self)
                let prevPoint	= touch.previousLocation(in: self)
                let	touchAngle	= self.angleForPoint(touchPoint)
                let prevAngle	= self.angleForPoint(prevPoint)
                
                previousTouchDate = Date()
                
                var change = touchAngle - prevAngle
                
                let pi = CGFloat(M_PI)
                
                if change > pi {
                    change -= 2 * pi
                } else if change < -pi {
                    change += 2 * pi
                }
                
                self.angle += change
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesEnded")
        
        if let touch = currentTouch {
            
            if touches.contains(touch) {
                self.angularVelocity = self.calculateFinalAngularVelocity(touch)
                
                if angularVelocity != 0 {
                    previousTouchDate = nil
                }
                
                self.startAnimating()
                
                currentTouch = nil
                
            } else {
                
                let point = self.currentTouch?.location(in: self)
                let leftTapZone = CGRect(x: 0, y: 20, width: 130, height: 200)
                let rightTapZone = CGRect(x: 172, y: 20, width: 130, height: 200)
                
                if let point = point {
                    if leftTapZone.contains(point) {
                        //left tap
                        self.moveFromAngle(self.angle, toAngle:self.angle - CGFloat(M_PI_4))
                    } else if rightTapZone.contains(point) {
                        //right tap
                        self.moveFromAngle(self.angle, toAngle:self.angle + CGFloat(M_PI_4))
                    }
                }
            }
        } else {
            self.stopAnimating()
        }
    }
    
    //MARK: - Angle
    
    func moveFromAngle(_ fromAngle:CGFloat, toAngle:CGFloat) {
        if(fromAngle>toAngle) {
            print("left")
        }
        
        self.angle = toAngle
        
        delegate?.spinWheelAngleDidChange(self)
    }
}
