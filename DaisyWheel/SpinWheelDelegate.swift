//
//  SpinWheelDelegate.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import Foundation

protocol SpinWheelDelegate {
    func spinWheelDidStartSpinningFromInertia(_ wheel: SpinningWheel)
    func spinWheelDidFinishSpinning(_ wheel: SpinningWheel)
    func spinWheelAngleDidChange(_ wheel: SpinningWheel)
    func spinWheelShouldBeginTouch(_ wheel: SpinningWheel) -> Bool
}
