//
//  CustomActivityIndicator.swift
//  Trasher
//
//  Created by Fred Pearson on 2015-04-04.
//  Copyright (c) 2015 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class CustomActivityIndicator : NSObject {
    

    class func activate(parentView: UIView) -> UIActivityIndicatorView {
        var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = CGPointMake(parentView.frame.size.width / 2, parentView.frame.size.height / 2)
        parentView.addSubview(activityIndicator)
        parentView.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    class func deactivate(activityView: UIActivityIndicatorView) {
        activityView.stopAnimating()
//        activityView.removeFromSuperview()
    }
    
}