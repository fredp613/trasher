//
//  textViewHelper.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-16.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

extension UITextView: UITextViewDelegate  {
    

    func initWithPlaceholer(placeHolderText: String) -> UITextView {
        
        self.delegate = self
        var pText = placeHolderText
        if placeHolderText.isEmpty {
            pText = "Enter text"
        }
        
        self.textColor = UIColor.lightGrayColor()
        self.text = pText
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.selectedRange = NSMakeRange(0, 0)
        
        textViewDidChange(self, placeHolder: pText)
        textViewDidBeginEditing(self)
        
        return self
    }
    
    
    func textViewDidChange(textView: UITextView, placeHolder:String!) {
        println("hey you")
//        println("test \(placeHolder)")
        if (self.text.rangeOfString(placeHolder, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil) {
            self.text = self.text.stringByReplacingOccurrencesOfString(placeHolder, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        if self.text.isEmpty {
            self.text = placeHolder
            self.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    
    
    public func textViewDidBeginEditing(textView: UITextView) {
        self.selectedRange = NSMakeRange(0, 0)
    }
}
