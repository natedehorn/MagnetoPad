//
//  ViewController.swift
//  MagnetoPad
//
//  Created by Nathan DeHorn on 4/12/16.
//  Copyright © 2016 Nathan DeHorn. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var lastPoint:CGPoint!
    var currentPoint:CGPoint!
    var drawing = false
    var red:CGFloat! = 0.0
    var green:CGFloat! = 0.0
    var blue:CGFloat! = 0.0
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func undoDrawing(sender: AnyObject) {
        self.imageView.image = nil
    }
    
    @IBAction func saveImage(sender: AnyObject) {
    }
    
    @IBAction func startDrawing(sender: AnyObject) {
        drawing = true
        startTimer()
    }
    
    @IBAction func stopDrawing(sender: AnyObject) {
        drawing = false
    }
    
    func startTimer() {
       // var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("drawBetweenPoints(lastPoint, endPoint: currentPoint)"), userInfo: nil, repeats: true)
        drawing = true
    }
    
    func drawBetweenPoints(startPoint:CGPoint, endPoint:CGPoint) {
        print("function called.")
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.imageView.image?.drawInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))
        CGContextMoveToPoint(context, startPoint.x, startPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, 1.0)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextStrokePath(context)
        CGContextDrawPath(context, .FillStroke)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.imageView.image = img
    }
    
    func gatherMagnetometerValues() {
        let motionKit = MotionKit()
        motionKit.getMagnetometerValues(0.01){
            (x, y, z) in
            if self.lastPoint == nil || self.lastPoint.x == 0.0 || self.lastPoint.y == 0.0 {
                print("lastPoint is nil")
                self.lastPoint = CGPoint(x: x, y: y)
            }
            self.currentPoint = CGPoint(x: x, y: y)
            print("Last:",self.lastPoint)
            print("Current:",self.currentPoint)
            print(self.drawing)
        
            //Warn user that magnet is too close!
            if y < 0 {
                let alertController = UIAlertController(title: "MagnetoPad", message:"Magnet is too close to device!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            }
            if self.drawing {
                self.drawBetweenPoints(self.lastPoint, endPoint: self.currentPoint)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherMagnetometerValues()
    }
}