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
    
    var isSwiping:Bool!
    var drawing = false
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!

    var xmag:Double!
    var ymag:Double!
    var xstart:Double!
    var ystart:Double!
    var xnext:Int!
    var ynext:Int!
    
    let manager = CMMotionManager()
    
    @IBOutlet weak var xval: UITextField!
    @IBOutlet weak var yval: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func undoDrawing(sender: AnyObject) {
        self.imageView.image = nil
    }
    
    @IBAction func saveImage(sender: AnyObject) {
    }
    
    @IBAction func draw(sender: AnyObject) {
        let xxx = Int(self.xval.text!)!
        let yyy = Int(self.yval.text!)!
        currentPoint = CGPoint(x: xxx, y: yyy)
        drawBetweenPoints(lastPoint, end:currentPoint)
        print(currentPoint)
    
        lastPoint = currentPoint
        xval.endEditing(true)
        yval.endEditing(true)
    }

    @IBAction func savePoint(sender: AnyObject) {
        let x = Int(self.xval.text!)!
        let y = Int(self.yval.text!)!
        lastPoint = CGPoint(x: x, y: y)
    }
    
    @IBAction func startDrawing(sender: AnyObject) {
        drawing = true
    }
    
    @IBAction func stopDrawing(sender: AnyObject) {
        drawing = false
    }
    
    func drawBetweenPoints(start:CGPoint, end:CGPoint){
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.drawInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start.x, start.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end.x, end.y)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let motionKit = MotionKit()
        
        red = 0.0
        blue = 0.0
        green = 0.0
        
        xval.keyboardType = UIKeyboardType.NumberPad
        yval.keyboardType = UIKeyboardType.NumberPad
        
        motionKit.getMagnetometerValues(){
            (x, y, z) in
            self.xmag = x
            self.ymag = y
            print(self.xmag,",", self.ymag)
            print(self.drawing)
            
            //Warn user that magnet is too close!
            if self.ymag < 0 {
                let alertController = UIAlertController(title: "MagnetoPad", message:"Magnet is too close to device!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            }
            
            //Initialize the start point
            if self.lastPoint == nil {
                let xtemp = self.xmag
                let ytemp = self.ymag
                self.lastPoint = CGPoint(x: xtemp, y: ytemp)
            }
            
            let point1 = CGPoint(x: self.xmag, y: self.ymag)
            self.drawBetweenPoints(self.lastPoint, end: point1)
            self.lastPoint = point1
            
        }
    }
}