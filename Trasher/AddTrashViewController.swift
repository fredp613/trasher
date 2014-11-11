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
    func trashTableViewDelegate(tableData: NSMutableArray)
}

class AddTrashViewController: UIViewController, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, TrashTableViewProtocol {

    
    @IBOutlet weak var actvityIndicatorView: UIActivityIndicatorView!
    var pickedImage = UIImage()
    var trashArray : NSMutableArray!
    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var currentLoc = CLLocation()
    var trash = Trash()
    var delegate: TrashTableViewProtocol?
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    

    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func changeLocationButton(sender: AnyObject) {


    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         self.actvityIndicatorView.startAnimating()
         self.getCurrentLocation()
         self.actvityIndicatorView.stopAnimating()


        
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
                
        self.trash.image = self.imageButton.imageView?.image
        trashArray.addObject(self.trash)
        MainTabBarViewController().trashArray = trashArray
//        trashTableViewDelegate(trashArray)
        self.navigationController?.popViewControllerAnimated(true)

    }

    //MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alertView = UIAlertView(title: "Location error", message: "You are not connected to either wifi or your mobile network", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var currentLocation = newLocation as CLLocation!
        
        if (currentLocation != nil) {

            println("nigga you live here: \(currentLocation)")
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
               
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
                    self.actvityIndicatorView.stopAnimating()
                } else {
                    
                    
                    self.currentLocationLabel.text = "Cannot get your current location, please click on add location to find an address for pickup"
                    self.actvityIndicatorView.stopAnimating()
                }
            })
            
         
            manager.stopUpdatingLocation()
           
            
            
        } else {
            println("nigga we didnt made it")
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
    
    func trashTableViewDelegate(tableData: NSMutableArray) {
        delegate?.trashTableViewDelegate(trashArray)
    }
   
    
   
}
















