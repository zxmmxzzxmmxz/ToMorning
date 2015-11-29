//
//  AnalogClock.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-06.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//
//  Notice: This file is modified base on the online source code provided by http://sketchytech.blogspot.co.uk/2014/11/swift-how-to-draw-clock-face-using_12.html

import UIKit
import Foundation
@IBDesignable

class AnalogClock: UIView {
    

    // MARK: Calculate coordinates of time
    func  timeCoords(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
        let cx = x // x origin
        let cy = y // y origin
        var r  = radius // radius of circle
        var points = [CGPoint]()
        var angle = degree2radian(6)
        func newPoint (t:Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
        }
        // work out hours first
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(hoursInSeconds*5/3600)
        
        // work out minutes second
        r = radius * 1.25
        let minutesInSeconds = time.m*60 + time.s
        newPoint(minutesInSeconds/60)
        
        // work out seconds last
        r = radius * 1.5
        newPoint(time.s)
        
        return (h:points[0],m:points[1],s:points[2])
    }
    
    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i--;
        }
        return points
    }
    
    
    func ctime ()->(h:Int,m:Int,s:Int) {
        
        var t = time_t()
        time(&t)
        let x = localtime(&t) // returns UnsafeMutablePointer
        
        return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
    }
    
    enum NumberOfNumerals:Int {
        case two = 2, four = 4, twelve = 12
    }
    
    func drawText(#rect:CGRect, #ctx:CGContextRef, #x:CGFloat, #y:CGFloat, #radius:CGFloat, #sides:NumberOfNumerals, #color:UIColor) {
    
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(ctx, 1.0, -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/3.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides.rawValue,x: x,y: y,radius: radius-inset,adjustment:270)
        let path = CGPathCreateMutable()
        // multiplier enables correcting numbering when fewer than 12 numbers are featured, e.g. 4 sides will display 12, 3, 6, 9
        let multiplier = 12/sides.rawValue
    
        for p in enumerate(points) {
            if p.index > 0 {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                let aFont = UIFont(name: "DamascusBold", size: radius/5)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.whiteColor()]
                // create the attributed string
                let str = String(p.index*multiplier)
                let text = CFAttributedStringCreate(nil, str, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
                // set the line width to stroke the text with
                CGContextSetLineWidth(ctx, 1.5)
                // set the drawing mode to stroke
                CGContextSetTextDrawingMode(ctx, kCGTextStroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                CGContextSetTextPosition(ctx, xn, yn)
                // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
                // draw the line of text
                CTLineDraw(line, ctx)
            }
        }
    }
    func secondMarkers(#ctx:CGContextRef, #x:CGFloat, #y:CGFloat, #radius:CGFloat, #sides:Int, #color:UIColor) {
        // retrieve points
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
        // create path
        let path = CGPathCreateMutable()
        // determine length of marker as a fraction of the total radius
        var divider:CGFloat = 1/16
        for p in enumerate(points) {
            if p.index % 5 == 0 {
                divider = 1/8
            }
            else {
                divider = 1/16
            }
    
            let xn = p.element.x + divider*(x-p.element.x)
            let yn = p.element.y + divider*(y-p.element.y)
            // build path
            CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
            CGPathAddLineToPoint(path, nil, xn, yn)
            CGPathCloseSubpath(path)
            // add path to context
            CGContextAddPath(ctx, path)
        }
        // set path color
        let cgcolor = color.CGColor
        CGContextSetStrokeColorWithColor(ctx,cgcolor)
        CGContextSetLineWidth(ctx, 3.0)
        CGContextStrokePath(ctx)
        
    }


    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }

    func rotateLayer(currentLayer:CALayer,dur:CFTimeInterval){
        
        var angle = degree2radian(360)
        
        // rotation http://stackoverflow.com/questions/1414923/how-to-rotate-uiimageview-with-fix-point
        var theAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        theAnimation.duration = dur
        // Make this view controller the delegate so it knows when the animation starts and ends
        theAnimation.delegate = self
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Use fromValue and toValue
        theAnimation.fromValue = 0
        theAnimation.repeatCount = Float.infinity
        theAnimation.toValue = angle
        
        // Add the animation to the layer
        currentLayer.addAnimation(theAnimation, forKey:"rotate")
        
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        // obtain context
        let ctx = UIGraphicsGetCurrentContext()
        // decide on radius
        let rad = CGRectGetWidth(rect)/3.5
        let endAngle = CGFloat(2*M_PI)
        // add the circle to the context
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        // set fill color
        CGContextSetFillColorWithColor(ctx,UIColor.blackColor().CGColor)
        // set stroke color
        CGContextSetStrokeColorWithColor(ctx,UIColor.blackColor().CGColor)
        // set line width
        CGContextSetLineWidth(ctx, 4.0)
        // draw the path
        CGContextDrawPath(ctx, kCGPathFillStroke)
        /////////
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        let hour = formatter.stringFromDate(NSDate()).toInt()!
        //print("hour is \(hour)")
        formatter.dateFormat = "mm"
        let min = formatter.stringFromDate(NSDate()).toInt()!
        //print("min is \(min)")
        formatter.dateFormat = "ss"
        let second = formatter.stringFromDate(NSDate()).toInt()!
        //print("sec is \(second)")
        let realhourarc = (Float(hour) + Float(min)/60 + Float(second)/3600)/12
        //println(realhourarc)
        let hourx = CGRectGetMidX(rect) + 30 * sin(degree2radian(360) * CGFloat(realhourarc))
        let houry = CGRectGetMidY(rect) - 30 * cos(degree2radian(360) * CGFloat(realhourarc))
        let realminarc = (Float(min) + Float(second)/60)/60
        let minx = CGRectGetMidX(rect) + 50 * sin(degree2radian(360) * CGFloat(realminarc))
        let miny = CGRectGetMidY(rect) - 50 * cos(degree2radian(360) * CGFloat(realminarc))
        let realsecondarc = Float(second)/60
        let secondx = CGRectGetMidX(rect) + 70 * sin(degree2radian(360) * CGFloat(realsecondarc))
        let secondy = CGRectGetMidY(rect) - 70 * cos(degree2radian(360) * CGFloat(realsecondarc))
        // create hour layer
        let hourLayer = CAShapeLayer()
        hourLayer.frame = rect
        let hourpath = UIBezierPath()
        hourpath.moveToPoint(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect)))
        hourpath.addLineToPoint(CGPoint(x: hourx, y: houry))
        hourLayer.path = hourpath.CGPath
        hourLayer.lineWidth = 4
        hourLayer.strokeColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(hourLayer)
        rotateLayer(hourLayer, dur: 43200)
        // create minute layer
        let minLayer = CAShapeLayer()
        minLayer.frame = rect
        let minpath = UIBezierPath()
        minpath.moveToPoint(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect)))
        minpath.addLineToPoint(CGPoint(x: minx, y: miny))
        minLayer.path = minpath.CGPath
        minLayer.lineWidth = 2
        minLayer.strokeColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(minLayer)
        rotateLayer(minLayer, dur: 3600)
        // create second layer
        let secondLayer = CAShapeLayer()
        secondLayer.frame = rect
        let secondpath = UIBezierPath()
        secondpath.moveToPoint(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect)))
        secondpath.addLineToPoint(CGPoint(x: secondx, y: secondy))
        secondLayer.path = secondpath.CGPath
        secondLayer.lineWidth = 1
        secondLayer.strokeColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(secondLayer)
        rotateLayer(secondLayer, dur: 60)
        
        let dot=CAShapeLayer()
        dot.frame=rect
        let dotpath=UIBezierPath()
        dotpath.moveToPoint(CGPoint(x:CGRectGetMidX(rect),y:CGRectGetMidY(rect)))
        dotpath.addArcWithCenter(CGPoint(x:CGRectGetMidX(rect),y:CGRectGetMidY(rect)), radius: 2, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        dot.path=dotpath.CGPath
        dot.lineWidth=5
        dot.strokeColor=UIColor.whiteColor().CGColor
        self.layer.addSublayer(dot)
        
        drawText(rect:rect, ctx: ctx, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: .twelve, color: UIColor.whiteColor())
        secondMarkers(ctx: ctx, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 60, color: UIColor.whiteColor())
        
    }
    

}
