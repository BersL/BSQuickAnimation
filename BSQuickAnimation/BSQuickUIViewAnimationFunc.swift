//
//  BSQuickUIViewAnimationFunc.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/9/29.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

public extension UIView {
    
    public struct bs_animationOptions {
        static var defaultDuration : NSTimeInterval = 0.8
        static var defaultTimingCuve : UIViewAnimationOptions = .CurveLinear
        static var defaultDelay : NSTimeInterval = 0.0
        static var defaultCompletinoBlock : ((Bool) -> Void)? = nil
    }
    
    public var then : UIView {
        get {
            bs_delay = bs_uncompletedTime
            return self
        }
    }
    
    public var barrier : UIView {
        get{
            bs_barrier = bs_uncompletedTime > 0
            return self
        }
    }
    
    public var and : UIView {
        get{
            bs_delay = bs_lastDelay
            return self
        }
    }
    
    public func after(period:NSTimeInterval) -> UIView {
        bs_delay += period

        return self
    }
    
    public func delay(period:NSTimeInterval) -> UIView {
        return after(period)
    }
    
    public func completion(clourse: (Bool) -> Void) -> UIView {
        self.bs_completion = clourse
        return self
    }
    
    public var linear : UIView {
        get{
            bs_timingCurve = UIViewAnimationOptions.CurveLinear
            return self
        }
    }
    
    public var easeIn : UIView {
        get{
            bs_timingCurve = UIViewAnimationOptions.CurveEaseIn
            return self
        }
    }
    
    public var easeOut : UIView {
        get{
            bs_timingCurve = UIViewAnimationOptions.CurveEaseOut
            return self
        }
    }
    
    public var easeInOut : UIView {
        get{
            bs_timingCurve = UIViewAnimationOptions.CurveEaseInOut
            return self
        }
    }
}
