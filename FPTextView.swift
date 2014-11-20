//
//  FPTextView.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-15.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class FPTextView : UITextView, UITextViewDelegate {
    
    var placeHolder:String!
    var border: Bool = true
        
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init()
        self.delegate = self
        self.textColor = UIColor.lightGrayColor()
        self.text = "Enter text"
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.selectedRange = NSMakeRange(0, 0)

        
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.delegate = self
        self.textColor = UIColor.lightGrayColor()
        self.text = "Enter text"
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.selectedRange = NSMakeRange(0, 0)
        
    }
    
    
    func textViewDidChange(textView: UITextView) {
        if (self.text.rangeOfString("Enter text", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) != nil) {
            self.text = self.text.stringByReplacingOccurrencesOfString("Enter text", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        if self.text.isEmpty {
            self.text = "Enter text"
            self.selectedRange = NSMakeRange(0, 0)
        }
    }



    override func textViewDidBeginEditing(textView: UITextView) {
        self.selectedRange = NSMakeRange(0, 0)
    }
    

    
  
    
    
    
    
    
}