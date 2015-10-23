//
//  BSQuickAnimationCommon.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/9/29.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

let bs_mainQueue = dispatch_get_main_queue()

extension Int : BooleanType {
    public var boolValue : Bool {
        return self != 0
    }
    
    public var nonNegtive : Int {
        return self < 0 ? 0 : self
    }
}

extension Double {
    public var nonNegtive : Double {
        return self < 0.0 ? 0.0 : self
    }
}


internal extension UIView {
    
    struct AssociatedKey {
        static var duration = "duration"
        static var timingCurve = "timingCurve"
        static var delay = "delay"
        static var completion = "completion"
        static var uncompletedTime = "uncompletedTime"
        static var lastDelay = "lastDelay"
        static var barrier = "barrier"
    }
    
    class ClosureWrapper {
        var _cls: ((Bool) -> Void)?
        
        var closure: ((Bool) -> Void)? {
            get{
                return { (finished:Bool) -> Void in
                    bs_animationOptions.defaultCompletinoBlock?(finished)
                    self._cls?(finished)
                }
            }
        }
        
        init(_ closure: ((Bool) -> Void)?) {
            self._cls = closure
        }
    }

}


internal extension UIView {
    
    
    var bs_duration : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.duration) as? NSTimeInterval ?? bs_animationOptions.defaultDuration
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.duration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_timingCurve : UIViewAnimationOptions {
        get{
            return UIViewAnimationOptions(rawValue:
                objc_getAssociatedObject(self, &AssociatedKey.timingCurve) as? UInt ?? bs_animationOptions.defaultTimingCuve.rawValue)
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.timingCurve, newValue.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_delay : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.delay) as? NSTimeInterval ?? bs_animationOptions.defaultDelay
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.delay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_completion : ((Bool) -> Void)? {
        get{
            if let wrapper = objc_getAssociatedObject(self, &AssociatedKey.completion) as? ClosureWrapper{
                return wrapper.closure
            }
            return bs_animationOptions.defaultCompletinoBlock
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.completion, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    
    var bs_barrier : Bool {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.barrier) as? Bool ?? false
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.barrier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_lastDelay : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.lastDelay) as? NSTimeInterval ?? 0
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.lastDelay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var bs_uncompletedTime : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.uncompletedTime) as? NSTimeInterval ?? 0
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.uncompletedTime, newValue.nonNegtive, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func bs_animationComplete() {
        bs_duration = bs_animationOptions.defaultDuration
        bs_lastDelay = bs_delay
        bs_delay = bs_animationOptions.defaultDelay
        bs_timingCurve = bs_animationOptions.defaultTimingCuve
        bs_completion = bs_animationOptions.defaultCompletinoBlock
    }
    
    func bs_commitAnimate(duration:NSTimeInterval, animations: () -> Void){
        if !bs_barrier {
            
            let options = self.bs_timingCurve
            let completion = self.bs_completion
            let time = max(bs_uncompletedTime, bs_delay + duration) - bs_uncompletedTime
            bs_uncompletedTime += time

            UIView.animateWithDuration(duration,
                delay: bs_delay, options: options,
                animations: animations,
                completion: { (finished) -> Void in
                    completion?(finished)
                    self.bs_uncompletedTime -= time
            })
            bs_animationComplete()

        }
    }
}
