//
//  PinchZoomImageView
//
//
//  Created by Phil Wright on 8/22/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit
import QuartzCore

class PinchZoomImageView: UIImageView, UIGestureRecognizerDelegate {
    
    // Required init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    override init(image: UIImage?) {
        super.init(image: image)
        setupView()
    }
    func setupView() {
        // Important for allow user interaction on images
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.isExclusiveTouch = true

        // Aspect Fit the Image
        self.contentMode = .scaleAspectFit
        
        // Important: One gesture recognizer type is required to monitor this UIImageView
        
        // 1. Add the Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(PinchZoomImageView.handleTap(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)

        // 2. Add the Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(PinchZoomImageView.handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        // 3. Add the Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(PinchZoomImageView.handlePinch(_:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)

        // 4. Add the Rotate Gesture
        let rotateGesture = UIRotationGestureRecognizer(target: self, action:#selector(PinchZoomImageView.handleRotate(_:)))
        rotateGesture.delegate = self
        self.addGestureRecognizer(rotateGesture)
    }

    // Mark - Gesture Methods
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            view.superview!.bringSubview(toFront: self)
        }
    }
    func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view)
        
        if let view = recognizer.view {
            view.transform = view.transform.translatedBy(x: translation.x, y: translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    func handlePinch(_ recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    func handleRotate(_ recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    // Needed to allow multiple touches (i.e. zoom and pinch)
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
}
