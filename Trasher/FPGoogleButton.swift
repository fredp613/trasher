//
//  CustomBtns.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-30.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

protocol FPGoogleButtonDelegate {
    func activateMenuButtons(sender: UIButton)
}

class FPGoogleButton : NSObject, UIGestureRecognizerDelegate {

    var delegate : FPGoogleButtonDelegate?
    
    var btnAttributes = [(UIColor, String, String?, UIImage?)]()
    var parentView = UIView()
    var parentController = UIViewController()
    var buttonArray = [UIButton]()
    var hiddenState = true
    var maskView = UIView()
    var menuButton = UIButton()
    
    override init() {
     super.init()
    }
    
    
    init(controller: UIViewController, buttonAttributes: [(UIColor, String, String?, UIImage?)], parentView: UIView) {
        super.init()
        self.parentController = controller
        self.btnAttributes = buttonAttributes
        self.parentView = parentView
        setup()
    }


    
    func toggleMenuButtons() {
        
        if hiddenState {

            UIView.animateWithDuration(0.2,
                animations: {
                    self.parentView.addSubview(self.maskView)
                    self.menuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    self.menuButton.setImage(UIImage(named: "menu-button-activated"), forState: UIControlState.Normal)
                },
                completion: nil)
            
            for (i, button) in enumerate(buttonArray) {
               
                var delayString : NSString = "0.\(i)6"
                var progressiveDelay = delayString.doubleValue
                
                UIView.animateWithDuration(NSTimeInterval(progressiveDelay), delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    button.alpha = 1
                    }, completion: nil)
                
            }

            bringButtonsToFront()
        } else {

            for (i, button) in enumerate(reverse(buttonArray)) {
                var delayString : NSString = "0.\(i)6"
                var progressiveDelay = delayString.doubleValue
                
                UIView.animateWithDuration(NSTimeInterval(progressiveDelay), delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    button.alpha = 0
                    }, completion: nil)
                
            }
            UIView.animateWithDuration(0.2,
                animations: {
                    self.maskView.removeFromSuperview()
                    self.menuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                    self.menuButton.setImage(UIImage(named: "menu-button-activate"), forState: UIControlState.Normal)

                },
                completion: nil)
        }
        
        if hiddenState {
            hiddenState = false
        } else {
            hiddenState = true
        }
    }
    
    func setup() {
        
//        var shaddowEffect = UIView()
//        shaddowEffect.frame = CGRectMake(303, 545, 60, 60)
//        shaddowEffect.backgroundColor = UIColor.blackColor()
//        shaddowEffect.layer.opacity = 0.6
//        drawRoundView(shaddowEffect)
//        parentView.addSubview(shaddowEffect)
        menuButton.frame = CGRectMake(300, 540, 60.0, 60.0)
//        menuButton.backgroundColor = UIColor.redColor()


//        menuButton.setTitle("+", forState: UIControlState.Normal)
//        menuButton.titleLabel?.font = UIFont.systemFontOfSize(30.0)
        menuButton.setImage(UIImage(named: "menu-button-activate"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "toggleMenuButtons", forControlEvents: UIControlEvents.TouchUpInside)
        drawRoundButton(menuButton)
        parentView.addSubview(menuButton)


        //maskView
        maskView.frame = parentView.frame
        maskView.backgroundColor = UIColor(white: 0.98, alpha: 0.8)
        let recognizer = UITapGestureRecognizer(target: self, action:"toggleMenuButtons")
        recognizer.delegate = self
        //////////
        
        maskView.addGestureRecognizer(recognizer)
        
        for (i, btn) in enumerate(btnAttributes) {
            let button = UIButton()
            
            let attributes:(UIColor, String, String?, UIImage?) = btn as (UIColor, String, String?, UIImage?)
            
            let action : String = attributes.1
            let title : String? = attributes.2
            let color : UIColor = attributes.0
            let image : UIImage? = attributes.3
            
            let actionSelector = action + ":"
            button.backgroundColor = color
            button.alpha = 1
            button.setTitle(title!, forState: UIControlState.Normal)

            button.addTarget(parentController, action: Selector(actionSelector), forControlEvents: UIControlEvents.TouchUpInside)
            button.addTarget(self, action: "toggleMenuButtons", forControlEvents: UIControlEvents.TouchUpInside)
            
            buttonArray.append(button)
        }
        

        for (i, button) in enumerate(buttonArray) {
            button.alpha = 0
            if i == 0 {
                button.frame = CGRectMake(menuButton.frame.origin.x + 4.5, menuButton.frame.origin.y - 60, 50.0, 50.0)
            } else {
                let previousButton : UIButton = buttonArray[i-1] as UIButton
                button.frame = CGRectMake(menuButton.frame.origin.x + 4.5, previousButton.frame.origin.y - 60, 50.0, 50.0)
            }
            drawRoundButton(button)
            parentView.addSubview(button)
        }
        
        
    }
    
    
    
    func handleSingleTap() {
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.maskView.removeFromSuperview()
        }, completion: nil)
    }
    
    func bringButtonsToFront() {
        parentView.bringSubviewToFront(menuButton)
        
        for button in buttonArray {
            parentView.bringSubviewToFront(button)
        }
        
    }
    
    func drawRoundButton(btn: UIButton) {
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.clipsToBounds = true
    }
    
    func drawRoundView(view: UIView) {
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
    }
    
   
    
    
  
    
   
    
}
