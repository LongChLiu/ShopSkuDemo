//
//  ThrowLineTool.swift
//  ShopSkuDemo
//
//  Created by zzzsw on 2016/12/1.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

import UIKit
import QuartzCore


protocol ThrowLineToolDelegate {


    func animationDidFinish(view:UIView)




}



let _throw = ThrowLineTool()
class ThrowLineTool: NSObject,CAAnimationDelegate {


    var delegate : ThrowLineToolDelegate! = nil
    var showingView : UIView! = nil

    class func shareTool()->ThrowLineTool{
        return _throw
    }


    func throwObject(obj:UIView,start:CGPoint,end:CGPoint,height:CGFloat,num:CGFloat,duration:CGFloat){

        self.showingView = obj

        let path = CGMutablePath()
        let cpx = (start.x + end.x)/2
        let cpy = -height
        //

        path.move(to: CGPoint(x: start.x, y: start.y), transform: CGAffineTransform.init())
        path.addQuadCurve(to: CGPoint(x: end.x, y: end.y), control: CGPoint(x: cpx, y: cpy), transform: CGAffineTransform())


        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = path
        //变小
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.autoreverses = true
        scaleAnimation.toValue =  CGFloat(arc4random() % 4 + 4) / num
        //旋转
        let rotateAnimation = CABasicAnimation.init(keyPath: "transform")
        rotateAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1))
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.duration = 0.3



        let groupAnimation = CAAnimationGroup()
        groupAnimation.delegate = self
        groupAnimation.repeatCount = 1
        groupAnimation.duration = CFTimeInterval(duration)
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.animations = [rotateAnimation,scaleAnimation,animation]
        obj.layer.add(groupAnimation, forKey: "position scale")


    }


    func animationDidStop(anim:CAAnimation,flag:Bool){
        if self.delegate != nil {
            self.delegate.animationDidFinish(view: self.showingView)
        }
    }
}
