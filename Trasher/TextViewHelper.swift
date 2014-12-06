//
//  textViewHelper.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-16.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    var dataParam:String {
        get { return self.dataParam }
        set (dataParam) { self.dataParam = dataParam }
    }
}

extension UITextView: UITextViewDelegate, UIGestureRecognizerDelegate  {
    
//    var placeholder:String {return String()}
  
    func initWithPlaceholer(placeHolderText: String) -> UITextView {
        
        
        
        self.delegate = self
        var placeholder = placeHolderText
        if placeHolderText.isEmpty {
            placeholder = "Enter text"
        }
        
        self.textColor = UIColor.lightGrayColor()
        self.text = placeholder
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.selectedRange = NSMakeRange(0, 0)
        
        
        
        setup(placeholder)
              
        return self
    }
    
    func setup(placeholder: String) {
        let recognizer = UITapGestureRecognizer(target: self, action:"textViewTapped:")
        recognizer.delegate = self
        recognizer.dataParam = "test"
        self.addGestureRecognizer(recognizer)
    }
    
    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("test")
        if self.isFirstResponder() {
            if self.text.rangeOfString("Enter text", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil {
                self.text = ""

            }

        } else {
            if self.text == "" {
                self.text = "Enter text"
            }
        }
    }

    
    
    
    func textViewTapped(placeholder : String) {
        if self.text.rangeOfString(placeholder, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil {
            self.text = ""

        }
        
        self.text = ""
        
        self.becomeFirstResponder()

    }
    
    
    
}
