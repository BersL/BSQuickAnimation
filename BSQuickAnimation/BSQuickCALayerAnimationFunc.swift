//
//  BSQuickCALayerAnimationFunc.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/10/2.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

public extension CALayer {
    
    public func commitAnimation(forKey key:String) -> CALayer {
        return self
    }
    
    public var removeOnCompletion : CALayer {
        get{
            bs_removeOnCompletion = true
            return self
        }
    }
    
    public var then : CALayer {
        get {
            bs_delay = bs_uncompletedTime

            return self
        }
    }
    
    public var barrier : CALayer {
        get{
            bs_barrier = bs_uncompletedTime > 0
            return self
        }
    }
    
    public var and : CALayer {
        get{
            bs_delay = bs_lastDelay

            return self
        }
    }
    
    public func bs_remoevAnim(atIndex:Int) -> CALayer {
        let key = "bs_Animation:\(atIndex)"
        self.removeAnimationForKey(key)
        return self
    }
    
    public func bs_removeAll() -> CALayer {
        self.removeAllAnimations()
        self.bs_animCount = 0
        return self
    }
    
    public func after(period:NSTimeInterval) -> CALayer {
        bs_delay += period
        
        return self
    }

    
    public func delay(period:NSTimeInterval) -> CALayer {
        return after(period)
    }
    
    public func completion(clourse: (Bool) -> Void) -> CALayer {
        self.bs_completion = clourse
        return self
    }
    
    public var linear : CALayer {
        get{
            bs_timingCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            return self
        }
    }
    
    public var easeIn : CALayer {
        get{
            bs_timingCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            return self
        }
    }
    
    public var easeOut : CALayer {
        get{
            bs_timingCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            return self
        }
    }
    
    public var easeInOut : CALayer {
        get{
            bs_timingCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            return self
        }
    }

}