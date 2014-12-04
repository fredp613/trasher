//
//  SearchViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MobileCoreServices


class SearchViewController: UIViewController {

    var menuButtons = FPGoogleButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        
        // Do any additional setup after loading the view.
    }
    
    func addTrashButtonTouch(sender: UIButton!) {
        if User.registeredUser() {
            performSegueWithIdentifier("addTrashFromSearch", sender: self)
        } else {
            performSegueWithIdentifier("signUpFromSearchSegue", sender: self)
        }
//        menuButtons.toggleMenuButtons()
    }
    
    func requestTrashButtonTouch(sender: UIButton!) {
        println("event fired")
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
