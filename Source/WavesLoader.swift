//
//  WavesLoader.swift
//  PQFFillableLoaders
//
//  Created by Pol Quintana on 2/8/15.
//  Copyright (c) 2015 Pol Quintana. All rights reserved.
//

import Foundation
import UIKit

class WavesLoader: FillableLoader {
    
    internal override func generateLoader() {
        layoutPath()
    }
    
    internal override func layoutPath() {
        super.layoutPath()
        shapeLayer.path = shapePathAtIndex(0, count: 7)
    }
    
    
    // MARK: Animate
    
    internal override func startAnimating() {
        if !animate { return }
        if swing { startswinging() }
        startWaving()
        startMoving(true)
    }
    
    internal func startWaving() {
        let animation2: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        animation2.values = shapesArray(7)
        animation2.duration = 2.0
        animation2.removedOnCompletion = false
        animation2.fillMode = kCAFillModeForwards
        animation2.delegate = self
        animation2.setValue("shape", forKey: "animation")
        shapeLayer.addAnimation(animation2, forKey: "shape")
    }
    
    
    //MARK: Waves
    
    internal func shapesArray(count: Int) -> [AnyObject] {
        let shapesArray: NSMutableArray = []
        for i in 0..<count*2 {
            shapesArray.addObject(shapePathAtIndex(i, count: count*2))
        }
        return shapesArray as [AnyObject]
    }
    
    internal func shapePathAtIndex(index: Int, count: Int) -> CGMutablePath {
        let width = loaderView.frame.width
        let height = loaderView.frame.height
        let xMovement: CGFloat = (width/CGFloat(count))*CGFloat(index)
        let initialOrLast: Bool = index == 1 || index == count
        let divisions: CGFloat = 8
        var variation: CGFloat = 10
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, -width, height/2)
        
        // First wave
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions + xMovement, height/2 + variation, -width + width/4 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*3 + xMovement, height/2 - variation, -width + width/2 + xMovement, height/2)
        
        // Second wave
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*5 + xMovement, height/2 + variation, -width + width/4*3 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*7 + xMovement, height/2 - variation, -width + width + xMovement, height/2)
        
        // Third wave
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, width/divisions + xMovement, height/2 + variation, width/4 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, width/divisions*3 + xMovement, height/2 - variation, width/2 + xMovement, height/2)
        
        // Forth wave
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, width/divisions*5 + xMovement, height/2 + variation, width/4*3 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        CGPathAddQuadCurveToPoint(path, nil, width/divisions*7 + xMovement, height/2 - variation, width + xMovement, height/2)
        
        // Closing path
        CGPathAddLineToPoint(path, nil, width + 100, height/2)
        CGPathAddLineToPoint(path, nil, width + 100, height*2)
        CGPathAddLineToPoint(path, nil, -width, height*2)
        CGPathCloseSubpath(path)
        return path
    }
    
    
    //MARK: Animations Delegate
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if !animate { return }
        let key = anim.valueForKey("animation") as! String
        if key == "up" {
            startMoving(false)
        }
        if key == "down" {
            startMoving(true)
        }
        if key == "shape" {
            startWaving()
        }
        if key == "rotation" {
            startswinging()
        }
    }
    
    
    //MARK: Helpers
    
    internal func randomFloat() -> CGFloat {
        return CGFloat(arc4random_uniform(10) + 5)
    }
}