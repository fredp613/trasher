//
//  AddTrashViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import SystemConfiguration


protocol TrashTableViewProtocol {
    func trashTableViewDelegate(tableData: Array<Trash>)
}

class AddTrashViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, TrashTableViewProtocol {

    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!

  
   
    @IBOutlet weak var changeLocationButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var actvityIndicatorView: UIActivityIndicatorView!
    var pickedImage = UIImage()
    var trashArray  = [Trash]()
    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var currentLoc = CLLocation()
    var trash = Trash()


    var delegate:TrashTableViewProtocol? = nil
    
    @IBOutlet weak var currentLocationLabel: UILabel!

    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func changeLocationButton(sender: AnyObject) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dont forget to remove the sleep
        
      
        
        
        
        self.textTitle.becomeFirstResponder()
        self.actvityIndicatorView.startAnimating()
        self.getCurrentLocation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        self.registerForKeyboardNotifications()

    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.deregisterForKeyboardNotifications()
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as UIImage?
        if (img != nil) {
//                self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
            
            self.imageButton.setImage(img, forState: UIControlState.Normal)
            self.trash.image = UIImageJPEGRepresentation(img, 0.75)
            

        } else {
            self.imageButton.setTitle("Add Image", forState: UIControlState.Normal)
        }
        
    }


    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imageButtonWasPressed(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            self.promptForSource()
        } else {
            self.promptForPhotoRoll()
        }
        
    }
    
    func promptForSource() {
        var actionSheet = UIActionSheet()
        actionSheet.title = "Image Source"
        actionSheet.delegate = self
        actionSheet.showInView(self.view);
    }
    
    func promptForPhotoRoll() {
        var controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        controller.delegate = self;
        self.presentViewController(controller, animated: true, completion: nil)

    }
    
    func promptForCamera() {
        var controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.Camera;
        controller.delegate = self;
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func capture(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            println("button capture")
            
            var img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera;
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
  
    // MARK: - Navigation


    @IBAction func saveTrash(sender: AnyObject) {
        
        if !self.textTitle.text.isEmpty {
            self.trash.title = self.textTitle.text
        }

        trashArray.append(self.trash)
        println("\(trashArray.count)")
        
        if (delegate != nil) {
            trashTableViewDelegate(trashArray)
        }
        
        self.navigationController?.popViewControllerAnimated(true)

    }

    //MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alertView = UIAlertView(title: "Location error", message: "You are not connected to either wifi or your mobile network", delegate: self, cancelButtonTitle: "OK")
        self.actvityIndicatorView.stopAnimating()
        alertView.show()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var currentLocation = newLocation as CLLocation!
        
        if (currentLocation != nil) {

            println("You live here: \(currentLocation)")
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
               sleep(1)
                if (error == nil) {
                    let pm: AnyObject = placemarks.last!
                    println(pm.locality)
                    var currentAddress =  pm.name + " " + pm.locality + " " + pm.postalCode
                    self.currentLocationLabel.text = currentAddress
                    self.trash.latitude = currentLocation.coordinate.latitude
                    self.trash.longitude = currentLocation.coordinate.longitude
                    self.trash.addressLine1 = pm.name
                    self.trash.city = pm.locality
                    self.trash.postalCode = pm.postalCode
                    
                    if self.changeLocationButton.titleLabel?.text == "Add location" {
                        self.changeLocationButton.setTitle("Change", forState: UIControlState.Normal)
                    }
                    
                    self.actvityIndicatorView.stopAnimating()
                    
                    
                } else {
                    
                    
                    self.currentLocationLabel.text = "Cannot get your current location, please click on add location to find an address for pickup"
                    self.changeLocationButton.setTitle("Add location", forState: UIControlState.Normal)
                    self.actvityIndicatorView.stopAnimating()
                }
            })
            
         
            manager.stopUpdatingLocation()
           
            
            
        } else {
            println("Something went wrong")
        }

    }
    
    
    func getCurrentLocation() {
        var av = UIAlertView(title: "est", message: nil, delegate: self, cancelButtonTitle: "ok")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func trashTableViewDelegate(tableData: Array<Trash>) {
        delegate?.trashTableViewDelegate(trashArray)
    }
    
    //MARK: keyboard
    
    func registerForKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
        
    
    
    func deregisterForKeyboardNotifications() {
       NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()

        let delay:NSTimeInterval = 0.0
        let duration:NSTimeInterval = 1.0
        let keybSize = keyboardFrame.size.height + 25 as CGFloat
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 25
            }, completion: { finished in println("animation done")})
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.textTest.resignFirstResponder()
//        self.view.endEditing(true)
//        return true
//    }
    

    
//    func keyboardWillShow1(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//        var btnOrigin = self.btnSave.frame.origin
//        var btnHeight = self.btnSave.frame.height
//        var visibleRect = self.scrollView.frame
//        
//        visibleRect.size.height -= keyboardFrame.height
//        if (!CGRectContainsPoint(visibleRect, btnOrigin)) {
//            var scrollPoint = CGPointMake(0.0, btnOrigin.y - visibleRect.size.height + btnHeight)
//            self.scrollView.setContentOffset(scrollPoint, animated: true)
//        }
//    }
//    
    
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant -= keyboardFrame.size.height + 105
        })

    }
    


   
    
   
}
















