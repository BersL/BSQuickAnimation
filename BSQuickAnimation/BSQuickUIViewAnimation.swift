//
//  BSQuickUIViewAnimation.swift
//  BSQuickAnimation
//
//  Created by Bers on 15/9/26.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func moveX(offset:CGFloat, duration:NSTimeInterval) -> UIView {
        bs_commitAnimate (duration){ () -> Void in
            var center = self.center
            center.x += offset
            self.center = center
        }
        return self
    }
    
    public func moveX(offset:CGFloat) -> UIView {
        return moveX(offset, duration: bs_duration)
    }
    
    public func moveY(offset:CGFloat, duration:NSTimeInterval) -> UIView {
        bs_commitAnimate(duration) { () -> Void in
            var center = self.center
            center.y += offset
            self.center = center
        }
        return self
    }
    
    public func moveY(offset:CGFloat) -> UIView{
        return moveY(offset, duration: bs_duration)
    }
    
    public func scale(factor:CGFloat, duration:NSTimeInterval) -> UIView {
        bs_commitAnimate(duration) { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, factor, factor)
        }
        return self
    }
    
    public func scale(factor:CGFloat) -> UIView {
        return scale(factor, duration: bs_duration);
    }
    
    public func rotate(degree:CGFloat, duration:NSTimeInterval) -> UIView {
        bs_commitAnimate(duration) { () -> Void in
            self.transform = CGAffineTransformRotate(self.transform, degree / 180 * CGFloat(M_PI))
        }
        return self
    }
    
    public func rotate(degree:CGFloat) -> UIView{
        return rotate(degree, duration: bs_duration)
    }
    
    public func resetTransfrom(duration duration:NSTimeInterval) -> UIView {
        bs_commitAnimate(duration) { () -> Void in
            self.transform = CGAffineTransformIdentity
        }
        return self;
    }
    
    public func resetTranform() -> UIView {
        return resetTransfrom(duration: bs_duration)
    }
    
    public func changeAlpha(factor:CGFloat, duration:NSTimeInterval) -> UIView {
        bs_commitAnimate(duration) { () -> Void in
            self.alpha = factor
        }
        return self
    }
    
    public func changeAlpha(factor:CGFloat) -> UIView{
        return self.changeAlpha(factor, duration: bs_duration)
    }
}

