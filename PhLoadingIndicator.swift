//
//  PhLoadingIndicator.swift
//  PhLoadingIndicator
//
//  Created by Филипп Белов on 3/23/16.
//  Copyright © 2016 Philip Belov. All rights reserved.
//

import UIKit

class PhLoadingIndicator: UIView {
    
    let π = CGFloat(M_PI)
    let indicatorColor = UIColor(red: 218/255, green: 73/255, blue: 80/255, alpha: 1.0)
    let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    var duration : Double = 3.0
    var isAnimating : Bool = false
    
    struct animations {
        static let rotation = "indicatorrotation"
        static let stroke = "indicatorstroke"
        static let scale = "indicatorscale"
    }
    
    
    lazy var progressLayer : CAShapeLayer = {
        var temporaryPL = CAShapeLayer()
        temporaryPL.strokeStart = -0.25
        temporaryPL.strokeEnd = 0.75
        temporaryPL.strokeColor = self.indicatorColor.CGColor
        temporaryPL.fillColor = nil
        temporaryPL.lineWidth = 1.5
        return temporaryPL
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    func didLoad() {
        self.hidden = true
        //self.startAnimating()
        self.layer.addSublayer(progressLayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetAnimation), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        self.updatePath()
    }
    
    func updatePath() {
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let radius = min(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2
        let startAngle = CGFloat(0.0)
        let endAngle = 2*π
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.progressLayer.path = path.CGPath
    }
    
    func startAnimating() {
        if self.isAnimating {
            return
        }
        
        self.hidden = false
        
        let animationScale = CABasicAnimation()
        animationScale.keyPath = "transform.scale"
        animationScale.duration = duration / 5
        animationScale.fromValue = 0.0
        animationScale.toValue = 1.0
        animationScale.repeatCount = 1
        animationScale.timingFunction = self.timingFunction
        animationScale.removedOnCompletion = true
        progressLayer.addAnimation(animationScale, forKey: animations.scale)
        
        let animationRotation = CABasicAnimation()
        animationRotation.keyPath = "transform.rotation"
        animationRotation.duration = self.duration
        animationRotation.fromValue = 0.0
        animationRotation.toValue = 2 * π
        animationRotation.repeatCount = Float.infinity
        animationRotation.timingFunction = self.timingFunction
        progressLayer.addAnimation(animationRotation, forKey: animations.rotation)
        
        let animationStrokeStartBegin = CABasicAnimation()
        animationStrokeStartBegin.keyPath = "strokeStart"
        animationStrokeStartBegin.duration = self.duration / 2
        animationStrokeStartBegin.fromValue = 0.0
        animationStrokeStartBegin.toValue = 0.25
        animationStrokeStartBegin.timingFunction = self.timingFunction
        
        let animationStrokeEndBegin = CABasicAnimation()
        animationStrokeEndBegin.keyPath = "strokeEnd"
        animationStrokeEndBegin.duration = self.duration / 2
        animationStrokeEndBegin.fromValue = 0.0
        animationStrokeEndBegin.toValue = 1.0
        animationStrokeEndBegin.timingFunction = self.timingFunction
        
        let animationStrokeStartEnd = CABasicAnimation()
        animationStrokeStartEnd.keyPath = "strokeStart"
        animationStrokeStartEnd.duration = self.duration / 4
        animationStrokeStartEnd.fromValue = 0.25
        animationStrokeStartEnd.toValue = 1.0
        animationStrokeStartEnd.timingFunction = self.timingFunction
        animationStrokeStartEnd.beginTime = self.duration / 2
        
        let animationStrokeEndEnd = CABasicAnimation()
        animationStrokeEndEnd.keyPath = "strokeEnd"
        animationStrokeEndEnd.duration = self.duration / 4
        animationStrokeEndEnd.fromValue = 1.0
        animationStrokeEndEnd.toValue = 1.0
        animationStrokeEndEnd.timingFunction = self.timingFunction
        animationStrokeEndEnd.beginTime = self.duration / 2
        
        let strokeAnimations = CAAnimationGroup()
        strokeAnimations.duration = self.duration * 0.75
        strokeAnimations.animations = [animationStrokeStartBegin, animationStrokeStartEnd, animationStrokeEndBegin, animationStrokeEndEnd]
        strokeAnimations.repeatCount = Float.infinity
        progressLayer.addAnimation(strokeAnimations, forKey: animations.stroke)
        
        self.isAnimating = true
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.hidden = true
        progressLayer.removeAllAnimations()
        self.isAnimating = false
    }
    
    func resetAnimation() {
        if self.isAnimating {
            self.stopAnimating()
            self.startAnimating()
        }
    }
}
