//
//  BSQuickCALayerAnimationCommon.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/10/2.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit


internal extension CALayer {
    
    struct AssociatedKey {
        static var duration = "duration"
        static var timingCurve = "timingCurve"
        static var delay = "delay"
        static var completion = "completion"
        static var removeOnCompletion = "removeOnCompletion"
        static var animationDelegate = "animationDelegate"
        static var uncompletedTime = "uncompletedTime"
        static var lastDelay = "lastDelay"
        static var barrier = "barrier"
        static var animCount = "animCount"
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
    
    class AnimationDelegate : NSObject{
        
        var startBlock : (() -> Void)?
        var stopBlock : ((Bool) -> Void)?
        
        override func animationDidStart(anim: CAAnimation) {
            startBlock?()
        }
        
        override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
            stopBlock?(flag)
        }
    }
    
    var bs_animationDelegate : AnimationDelegate {
        get{
            var delegate = objc_getAssociatedObject(self, &AssociatedKey.animationDelegate) as? AnimationDelegate
            if delegate == nil {
                delegate = AnimationDelegate()
                objc_setAssociatedObject(self, &AssociatedKey.animationDelegate, delegate!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return delegate!
        }
    }
    

    func bs_animationComplete() {
        bs_duration = bs_animationOptions.defaultDuration
        bs_lastDelay = bs_delay
        bs_delay = bs_animationOptions.defaultDelay
        bs_timingCurve = bs_animationOptions.defaultTimingCurve
        bs_completion = bs_animationOptions.defaultCompletinoBlock
        bs_removeOnCompletion = false
    }

    
    var bs_duration : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.duration) as? NSTimeInterval ?? bs_animationOptions.defaultDuration
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.duration, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_timingCurve : CAMediaTimingFunction {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.timingCurve) as? CAMediaTimingFunction ?? bs_animationOptions.defaultTimingCurve
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.timingCurve, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_delay : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.delay) as? NSTimeInterval ?? bs_animationOptions.defaultDelay
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.delay, newValue.nonNegtive, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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

    
    var bs_removeOnCompletion : Bool {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.removeOnCompletion) as? Bool ?? false
        }
        
        set{
            objc_setAssociatedObject(self, &AssociatedKey.removeOnCompletion, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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

    var bs_lastDelay : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.lastDelay) as? NSTimeInterval ?? 0.0
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.lastDelay, newValue.nonNegtive, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_uncompletedTime : NSTimeInterval {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.uncompletedTime) as? NSTimeInterval ?? 0.0
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.uncompletedTime, newValue.nonNegtive, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bs_animCount : Int {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.animCount) as? Int ?? 0
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKey.animCount, newValue.nonNegtive, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    func bs_addAnimation(keyPath:String, toValue:AnyObject, duration:NSTimeInterval, fromValue:AnyObject? = nil) {
        let anim = CABasicAnimation(keyPath: keyPath)
        if let val = fromValue {
            anim.fromValue = val
        }
        anim.toValue = toValue
        anim.duration = bs_duration
        anim.timingFunction = bs_timingCurve
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = bs_removeOnCompletion
        bs_addAnimation(anim, forKey: "bs_Animation:\(bs_animCount)")
    }
    
    func bs_addAnimation(keyPath:String, byValue:AnyObject, duration:NSTimeInterval, fromValue:AnyObject? = nil) {
        let anim = CABasicAnimation(keyPath: keyPath)
        if let val = fromValue {
            anim.fromValue = val
        }
        anim.byValue = byValue
        anim.delegate = bs_animationDelegate
        anim.duration = bs_duration
        anim.timingFunction = bs_timingCurve
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = bs_removeOnCompletion
        bs_addAnimation(anim, forKey: "bs_Animation:\(bs_animCount)")
    }

    
    func bs_addAnimation(anim:CAAnimation, forKey key:String){
        if !bs_barrier {
            ++bs_animCount
            let completion = self.bs_completion
            
            let time = max(bs_uncompletedTime, bs_delay + anim.duration) - bs_uncompletedTime
            bs_uncompletedTime += time
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(bs_delay * Double(NSEC_PER_SEC))),
                bs_mainQueue, { () -> Void in
                    self.bs_animationDelegate.stopBlock = {
                        (finished) -> Void in
                        completion?(finished)
                        self.bs_uncompletedTime -= time
                    }
                    self.addAnimation(anim, forKey: key)
            })
            bs_animationComplete()
            
        }

    }
    
}