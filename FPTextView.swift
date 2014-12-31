//
//  FPTextView.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-15.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class FPTextView : NSObject, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var placeHolder = String()
    var border: Bool = true
    var tap = UIGestureRecognizer()
//    var textView = UITextView()

    override init() {
        
    }
    
    
    init(textView: UITextView, placeholder: String) {
        super.init()
        tap.delegate = self
        textView.delegate = self
        
        if placeholder.isEmpty {
            placeHolder = "Enter text"
        } else {
            placeHolder = placeholder
        }
        
        if textView.text.isEmpty {
            textView.text = placeHolder
        }
        
        
        self.tap.delegate = self
        textView.textColor = UIColor.lightGrayColor()
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        customTextView(textView)

    }



    
    func customTextView(textview: UITextView) -> UITextView {
        return textview
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if  textView.text.rangeOfString(placeHolder, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil {
                    textView.text = ""

        }

    }
    
    
    func textViewDidChange(textView: UITextView) {

        if (        textView.text.rangeOfString(placeHolder, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil) {
                    textView.text =         textView.text.stringByReplacingOccurrencesOfString(placeHolder, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        if         textView.text.isEmpty {
                    textView.text = placeHolder
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    
   
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\n" {
          println("hi")
          textView.resignFirstResponder()
            return false
        }
        return true
    }
    



    

    
  
    
    
    
    
    
}