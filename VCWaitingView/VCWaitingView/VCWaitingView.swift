//
//  VCWaitingView.swift
//  VCWaitingView
//
//  Created by qihaijun on 9/9/15.
//  Copyright (c) 2015 VictorChee. All rights reserved.
//

import UIKit

class VCWaitingView: UIView {

    var size = CGSize(width: 100.0, height: 100.0)
    var backgroundInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var transformScale: CGFloat = 0.000001
    private var rotationTransform = CGAffineTransformIdentity
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.purpleColor()
        alpha = 0 // Make it invisible for now
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView.center = center
        activityIndicatorView.color = UIColor.orangeColor()
        activityIndicatorView.hidesWhenStopped = false
        addSubview(activityIndicatorView)
        
        registerNotifications()
    }
    
    deinit {
        unregisterNotifications()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(addToView: UIView) {
        self.init(frame: addToView.bounds)
        addToView.addSubview(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Entirely cover the parent view
        if let parent = superview {
            frame = CGRect(x: backgroundInset.left, y: backgroundInset.top, width: parent.bounds.width - backgroundInset.left - backgroundInset.right, height: parent.bounds.height - backgroundInset.top - backgroundInset.bottom)
        }
        activityIndicatorView.frame = CGRectMake((frame.width - activityIndicatorView.frame.width)/2.0, (frame.height - activityIndicatorView.frame.height)/2.0, activityIndicatorView.frame.width, activityIndicatorView.frame.height)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context)
        
        CGContextSetGrayFillColor(context, 0, 0.8)
        
        // Draw rounded HUD background rect
        let boxRect = CGRect(x: (bounds.width - size.width) / 2.0, y: (bounds.height - size.height) / 2.0, width: size.width, height: size.height)
        let bezierPath = UIBezierPath(roundedRect: boxRect, cornerRadius: 7.0)
        CGContextAddPath(context, bezierPath.CGPath)
        CGContextFillPath(context)
        
        UIGraphicsPopContext()
    }
    
    func show(animated: Bool) {
        transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(transformScale, transformScale))
        if animated {
            [UIView .animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.transform = self.rotationTransform
                self.alpha = 1.0
            }, completion: { (finished) -> Void in
                
            })];
        } else {
            alpha = 1.0
        }
        activityIndicatorView.startAnimating()
    }
    
    func hide(animated: Bool) {
        activityIndicatorView.stopAnimating()
        if animated {
            [UIView .animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.transform = CGAffineTransformConcat(self.rotationTransform, CGAffineTransformMakeScale(self.transformScale, self.transformScale))
                self.alpha = 0.02
            }, completion: { (finished) -> Void in
                self.done()
            })]
        } else {
            alpha = 0
            done()
        }
    }
    
    private func done() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        alpha = 0
    }
    
    // MARK - Notification
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusBarOrientationDidChange:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    func statusBarOrientationDidChange(notification: NSNotification) {
        if let superview = self.superview {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
}
