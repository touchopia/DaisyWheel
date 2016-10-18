//
//  SpinImageView.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class SpinImageView: SpinningWheel {
    
    override var angle: CGFloat {
        didSet {
            delegate?.spinWheelAngleDidChange(self)
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imageView.layer.transform = CATransform3DMakeRotation(self.angle, 0, 0, 1)
            }) 
        }
    }
    open var image = UIImage() {
        didSet {
            self.imageView.image = image
        }
    }
    fileprivate var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.image = image
        setupView()
    }
    
    func setupView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        self.addSubview(imageView)
    }
}
