//
//  BSQuickCALayerAnimation.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/10/2.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

//Basic
public extension CALayer {
    
    public struct bs_animationOptions {
        static var defaultDuration : NSTimeInterval = 0.8
        static var defaultTimingCurve : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        static var defaultDelay : NSTimeInterval = 0.0
        static var defaultCompletinoBlock : ((Bool) -> Void)? = nil
    }
    
    public func moveX(offset:CGFloat, duration:NSTimeInterval) -> CALayer{
        bs_addAnimation("position.x", byValue: offset, duration: duration)
        return self
    }
    
    public func moveX(offset:CGFloat) -> CALayer{
        return moveX(offset, duration: bs_duration)
    }
    
    public func moveY(offset:CGFloat, duration:NSTimeInterval) -> CALayer{
        bs_addAnimation("position.y", byValue: offset, duration: duration)
        return self
    }
    
    public func moveY(offset:CGFloat) -> CALayer{
        return moveY(offset, duration: bs_duration)
    }
    
    public func changeOpacity(toVal:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("opacity", toValue: toVal, duration: duration)
        return self
    }
    
    public func changeOpacity(toVal:CGFloat) -> CALayer{
        return changeOpacity(toVal, duration: bs_duration)
    }
    
    public func strokeEndfrom(fromVal:CGFloat, to toVal:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("strokeEnd", toValue: toVal, duration: duration, fromValue: fromVal)
        return self
    }
    
    public func strokeEndfrom(fromVal:CGFloat, to toVal:CGFloat) -> CALayer {
        return strokeEndfrom(fromVal, to: toVal, duration: bs_duration)
    }
    
    public func scale(factor:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("transform.scale", toValue: factor, duration: duration)
        return self
    }
    
    public func scale(factor:CGFloat) -> CALayer {
        return scale(factor, duration: bs_duration)
    }
    
    public func rotateZ(degree:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("transform.rotate.z", toValue: degree / 180 * CGFloat(M_PI), duration: duration)
        return self
    }
    
    public func rotateZ(degree:CGFloat) -> CALayer{
        return rotateZ(degree, duration: bs_duration)
    }
    
    public func rotateY(degree:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("transform.rotate.y", toValue: degree / 180 * CGFloat(M_PI), duration: duration)
        return self
    }
    
    public func rotateY(degree:CGFloat) -> CALayer{
        return rotateZ(degree, duration: bs_duration)
    }
    
    public func rotateX(degree:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("transform.rotate.x", toValue: degree / 180 * CGFloat(M_PI), duration: duration)
        return self
    }
    
    public func rotateX(degree:CGFloat) -> CALayer{
        return rotateZ(degree, duration: bs_duration)
    }
    
    public func resettransform(duration duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("transform", toValue: NSValue(CATransform3D: CATransform3DIdentity), duration: duration)
        return self;
    }
    
    public func resetTranform() -> CALayer {
        return resettransform(duration: bs_duration)
    }

    public func changeLineWidthTo(toVal:CGFloat, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("lineWidth", toValue: toVal, duration: duration)
        return self
    }
    
    public func changeLineWidthTo(toVal:CGFloat) -> CALayer {
        return changeLineWidthTo(toVal, duration: bs_duration)
    }
    
    public func changeStrokeColorTo(color:UIColor, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("strokeColor", toValue: color.CGColor, duration: duration)
        return self
    }
    
    public func changeStrokeColorTo(color:UIColor) -> CALayer {
        return changeStrokeColorTo(color, duration: bs_duration)
    }
    
    public func changeFillColorTo(color:UIColor, duration:NSTimeInterval) -> CALayer {
        bs_addAnimation("fillColor", toValue: color.CGColor, duration: duration)
        return self
    }
    
    public func changeFillColorTo(color:UIColor) -> CALayer {
        return changeFillColorTo(color, duration: bs_duration)
    }
    
}

//Complex

public extension CALayer {
    
    /** frequency = 0 for repeating forever */
    public func flicker(frequency:Int, period:NSTimeInterval) -> CALayer {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 0.0
        anim.autoreverses = true
        anim.repeatCount = frequency>0 ? Float(frequency) : FLT_MAX
        anim.duration = period
        anim.removedOnCompletion = false
        anim.fillMode=kCAFillModeForwards
        if self.animationForKey("bs_flickerAnim") == nil {
            bs_addAnimation(anim, forKey:"bs_flickerAnim")
        }
        return self
    }
    
    public func stopFlicker() -> CALayer {
        self.removeAnimationForKey("bs_flickerAnim")
        return self
    }
    
    /** frequency = 0 for repeating forever */
    public func shake(frequency:Int, period:NSTimeInterval, amplitude:Double, transverse:Bool) -> CALayer {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.duration = period
        anim.repeatCount = frequency>0 ? Float(frequency) : FLT_MAX
        
        anim.calculationMode = kCAAnimationPaced
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, CGRectGetMidX(frame), CGRectGetMidY(frame))
        if transverse{
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame) + CGFloat(amplitude) * frame.size.width, CGRectGetMidY(frame))
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame) - CGFloat(amplitude) * frame.size.width, CGRectGetMidY(frame))
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame), CGRectGetMidY(frame))
        }else{
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame), CGRectGetMidY(frame) - CGFloat(amplitude) * frame.size.height)
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame), CGRectGetMidY(frame) + CGFloat(amplitude) * frame.size.height)
            CGPathAddLineToPoint(path, nil, CGRectGetMidX(frame), CGRectGetMidY(frame))
        }
        CGPathCloseSubpath(path)
        anim.path = path
        if self.animationForKey("bs_shakeAnim") == nil {
            bs_addAnimation(anim, forKey:"bs_shakeAnim")
        }
        return self
    }
    
    public func stopShake() -> CALayer {
        self.removeAnimationForKey("bs_shakeAnim")
        return self
    }
    
    
    
}