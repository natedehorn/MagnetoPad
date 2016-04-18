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
    var drawing:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!

    var xmag:Double!
    var ymag:Double!
    
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
        print(currentPoint)
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.drawInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
        xval.endEditing(true)
        yval.endEditing(true)
    }

    @IBAction func savePoint(sender: AnyObject) {
        let x = Int(self.xval.text!)!
        let y = Int(self.yval.text!)!
        lastPoint = CGPoint(x: x, y: y)
        print(lastPoint)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let motionKit = MotionKit()
        
        red = 0.0
        blue = 0.0
        green = 0.0
        
        xval.keyboardType = UIKeyboardType.NumberPad
        yval.keyboardType = UIKeyboardType.NumberPad
        
        motionKit.getMagnetometerValues(0.5){
            (x, y, z) in
            self.xmag = x
            self.ymag = y
            print(self.xmag)
            print(self.ymag)
            
            //Warn user that magnet is too close!
            if y < 0 {
                let alertController = UIAlertController(title: "MagnetoPad", message:"Magnet is too close to device!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            }
        }
    }
}