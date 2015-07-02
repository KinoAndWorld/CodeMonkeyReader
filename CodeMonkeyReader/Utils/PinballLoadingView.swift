//
//  PinballLoadingView.swift
//
//  Created by kino on 14/11/27.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

//protocol PinballLoadingViewDelegate : class{
//    func pinballLoadingView(pinballView:PinballLoadingView, customBackView:UIView, inRect:CGRect);
//}

@objc class PinballLoadingView: UIView {
    
    typealias CustomBackViewInRect = (CGRect)->UIView
    typealias BallSizeAndColorByIndex = (Int)->(CGSize, UIColor)
    
    ///const
    private let kRoundBallNumber:Int = 5
    
    
    ///variable
    private var roundBalls:[CALayer] = []
    
    private var roundBallSize:CGFloat = 20.0
    
    internal var backgroundView:UIView?
    internal var backColor:UIColor?
    
    var configureBackView:CustomBackViewInRect?
    var configureBallInfo:BallSizeAndColorByIndex?
    
    
    private func commonInitialze(){
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView!.backgroundColor = UIColor.clearColor()
        
        if (configureBackView != nil) {
            let subView = configureBackView!(backgroundView!.bounds)
            backgroundView?.addSubview(subView)
        }
        
        if let bColor = backColor{
            backgroundView!.backgroundColor = backColor
        }
        
        let animateContentLayer = CALayer()
        animateContentLayer.frame = CGRect(x: 0, y: self.center.y - 50, width: self.bounds.width, height: 100)
        
        for(var i = 0 ; i < kRoundBallNumber ; i++){
            //create round ball
            var ballSize:CGSize = CGSizeZero
            var ballColor:UIColor = UIColor.clearColor()
            if(configureBallInfo != nil){
                (ballSize, ballColor) = self.configureBallInfo!(i)
                roundBallSize = ballSize.width
            }else{
                ballSize = CGSizeMake(roundBallSize, roundBallSize)
                let blueValue = (CGFloat(i) * 0.1) + 0.2
                ballColor = UIColor(red: 0.9, green: 0.2, blue: blueValue, alpha: 0.8)
            }
            let roundLayer = self.roundLayerWithSize(ballSize ,color: ballColor)
            
            roundLayer.position.x = animateContentLayer.bounds.width/2 -
                ((floor(CGFloat(kRoundBallNumber)/2.0) - CGFloat(i)) * roundBallSize)
            roundLayer.position.y = animateContentLayer.bounds.height/2 - 15
            
            animateContentLayer.addSublayer(roundLayer)
            roundBalls.append(roundLayer)
        }
        
        ///add elements to view
        self.addSubview(backgroundView!)
        
        self.layer.addSublayer(animateContentLayer)
        
        animateLastRoundBall(roundBalls.last!)
    }
    
    func roundLayerWithSize(size:CGSize, color:UIColor) -> CALayer{
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.cornerRadius = size.width / 2.0
        layer.backgroundColor = color.CGColor
        return layer
    }
    
    //animate
    func animateFirstRoundBall(ballLayer:CALayer){
        let originPt = ballLayer.position
        
        animateView(ballLayer, fromPoint: originPt,
            toPoint: CGPointMake(originPt.x - 30, originPt.y - 30),
            isFirstElement: true)
    }
    
    func animateLastRoundBall(ballLayer:CALayer){
        let originPt = ballLayer.position
        
        animateView(ballLayer, fromPoint: originPt,
            toPoint: CGPointMake(originPt.x + 30, originPt.y - 30),
            isFirstElement: false)
    }
    
    func stopAllAnimate(){
        self.roundBalls.first!.removeAllAnimations()
        self.roundBalls.last!.removeAllAnimations();
    }
    
    
    func animateView(animateLayer:CALayer, fromPoint start:CGPoint, toPoint end:CGPoint, isFirstElement:Bool){
        let animation = CAKeyframeAnimation(keyPath: "position")
        // Animation's path
        let path = UIBezierPath()
        
        // Move the "cursor" to the start
        path.moveToPoint(start)
        
        // Calculate the control points
        let deltaX:CGFloat = isFirstElement ? -20 : 20;
        let deltaY:CGFloat = isFirstElement ? 20 : 20;
        let c1 = CGPointMake(start.x + deltaX, start.y);
        let c2 = CGPointMake(end.x, end.y + deltaY);
        
        // Draw a curve towards the end, using control points
        path.addCurveToPoint(end, controlPoint1: c1, controlPoint2: c2)
        
        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.CGPath;
        
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards;
        animation.removedOnCompletion   = true
        animation.duration              = 0.3
        animation.timingFunction        = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses          = true
        animation.repeatCount           = 1
        // Apply it
        //        CATransaction.begin()
        animation.delegate = self
        
        if isFirstElement{
            animation.setValue("left" , forKey: "animateDirect")
        }else{
            animation.setValue("right" , forKey: "animateDirect")
        }
        
        animateLayer.removeAllAnimations()
        animateLayer.addAnimation(animation, forKey: "animation.trash")
        //        CATransaction.commit()
        
        // Drawing the path   for debug
        //        let layer = CAShapeLayer()
        //        layer.path          = path.CGPath;
        //        layer.strokeColor   = UIColor.blackColor().CGColor;
        //        layer.lineWidth     = 1.0;
        //        layer.fillColor     = nil;
        //        animateLayer.superlayer.addSublayer(layer)
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if flag{
            if let key = anim.valueForKey("animateDirect") as! String?{
                if (key == "left"){
                    animateLastRoundBall(self.roundBalls.last!)
                }else{
                    animateFirstRoundBall(self.roundBalls.first!)
                }
            }
        }
    }
    
    //show function
    @objc func showInWindow(){
        
        self.frame = UIScreen.mainScreen().bounds
        commonInitialze()
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        self.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 1.0
            }) { (finish) -> Void in
                
        }
    }
    
    func showInView(view:UIView){
        
        self.frame = view.bounds
        commonInitialze()
        
        view.addSubview(self)
        self.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 1.0
            }) { (finish) -> Void in }
    }
    
    func stopAnimateAndDismiss(){
        self.stopAllAnimate()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0.0
            }) { (finish) -> Void in
                self.removeFromSuperview()
        }
    }
    
    ///help function
    //角度转弧度
    func degreesToRadians(x:Double)->Double{
        return (M_PI * x / 180.0)
    }
    
}
