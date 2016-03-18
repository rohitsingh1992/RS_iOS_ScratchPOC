//
//  ScratchView.swift
//  ScratchSwift
//
//  Created by Rohit Singh on 04/04/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class ScratchView: UIView {
    
    
    var location : CGPoint!
    var previousLocation : CGPoint!
    
    var width : CGFloat!
    var height : CGFloat!
    var scratchedImage: CGImageRef!
    var scratchableImage : CGImageRef!
    
    var firstTime : Bool!
    
    var alphaPixels : CGContextRef!
    var dataProvider : CGDataProviderRef!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.scratchableImage = UIImage(named: "scratchable.jpg")?.CGImage
        
        
        let pixelsWide = CGImageGetWidth(self.scratchableImage)
        
        let pixelsHigh = CGImageGetHeight(self.scratchableImage)
        
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        
      //  self.width = frame.width
       // self.height = frame.height
        
        
        
        var colorSpaceRef = CGColorSpaceCreateDeviceGray()
        
        
        
        var pixels : CFMutableData = CFDataCreateMutable(nil, Int(pixelsWide * pixelsHigh))
        
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)

        
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        let bitmapData = malloc(CUnsignedLong(bitmapByteCount))
        
        self.alphaPixels = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, CUnsignedLong(8), CUnsignedLong(bitmapBytesPerRow), colorSpaceRef, bitmapInfo);
        
        let bitmapDataa = malloc(CUnsignedLong(bitmapByteCount))
        
        self.dataProvider = CGDataProviderCreateWithCFData(pixels)

        CGContextSetFillColorWithColor(self.alphaPixels, UIColor.blackColor().CGColor)
        CGContextFillRect(self.alphaPixels, frame)
        
        CGContextSetStrokeColorWithColor(self.alphaPixels, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(self.alphaPixels, 20)
        CGContextSetLineCap(self.alphaPixels, kCGLineCapRound)

        
        var mask : CGImageRef = CGImageMaskCreate(pixelsWide, pixelsHigh, 8, 8, CUnsignedLong(bitmapBytesPerRow), self.dataProvider, nil, false)
        
        self.scratchedImage = CGImageCreateWithMask(self.scratchableImage, mask)

    }
    
     override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        var touch: AnyObject? = event.touchesForView(self)?.anyObject()
        self.location = touch?.locationInView(self)
        self.firstTime = true
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var touch: AnyObject? = event.touchesForView(self)?.anyObject()
        if self.firstTime == true {
        
            self.firstTime = false
            self.previousLocation = touch?.previousLocationInView(self)
        }
        else {
            self.location = touch?.locationInView(self)
            self.previousLocation = touch?.previousLocationInView(self)
        }
        
        self.renderLineFromPoint(self.location, toPoint: self.previousLocation)
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        var touch: AnyObject? = event.touchesForView(self)?.anyObject()
        if self.firstTime == true {
            
            self.firstTime = false
            self.previousLocation = touch?.previousLocationInView(self)
        }
        
        self.renderLineFromPoint(self.location, toPoint: self.previousLocation)

    }
    
    
    func renderLineFromPoint(point:CGPoint, toPoint:CGPoint) {
        CGContextMoveToPoint(self.alphaPixels, point.x, point.y)
        CGContextAddLineToPoint(self.alphaPixels, toPoint.x, toPoint.y)
        CGContextStrokePath(self.alphaPixels)
        self.setNeedsDisplay()
    
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


/*


- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {

CGContextMoveToPoint(alphaPixels, start.x, start.y);
CGContextAddLineToPoint(alphaPixels, end.x, end.y);
CGContextStrokePath(alphaPixels);
[self setNeedsDisplay];
}

*/
