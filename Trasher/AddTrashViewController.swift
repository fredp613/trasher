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
import AssetsLibrary


protocol TrashTableViewProtocol {
    func trashTableViewDelegate(tableData: Array<Trash>, trashAssetData: Array<TrashAssets>)
}

class AddTrashViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, TrashTableViewProtocol,
UIPopoverControllerDelegate, CTAssetsPickerControllerDelegate, UIScrollViewDelegate {

   
   
    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!

  
   
    @IBOutlet weak var changeLocationButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var actvityIndicatorView: UIActivityIndicatorView!
    

    var pickedImage = UIImage()
    var trashArray  = [Trash]()
    var trashAssetsArray = [TrashAssets]()
    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var currentLoc = CLLocation()
    var trash = Trash()
    
    
    //picker
    var ctPicker = CTAssetsPickerController()
    var assets = []
    var pickedAssets = [UIImage]()
    var containerView : UIView!
    var pageViews: [UIImageView?] = []
    
    var delegate:TrashTableViewProtocol? = nil
    
    @IBOutlet weak var currentLocationLabel: UILabel!

    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func changeLocationButton(sender: AnyObject) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textTitle.delegate = self
        //dont forget to remove the sleep

        
        self.navigationItem.hidesBackButton = true

       
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.Plain, target: self, action: "customBtnAction:")
        

//        self.textTitle.becomeFirstResponder()
        self.actvityIndicatorView.startAnimating()
        self.getCurrentLocation()
        
    }
    
    @IBAction func closeWasPressed(sender: AnyObject) {
        
     self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    func customBtnAction(sender: UIBarButtonItem) {
//        self.navigationController?.popToViewController(MasterTableViewController(), animated: true)
        self.performSegueWithIdentifier("showMasterFromAddTrash", sender: self)
//        self.dismissViewControllerAnimated(true, completion: nil)
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

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imageButtonWasPressed(sender: AnyObject) {
        

        self.assets = NSMutableArray()
        self.ctPicker.assetsFilter = ALAssetsFilter.allAssets()
        self.ctPicker.showsCancelButton = true
        self.ctPicker.delegate = self
        self.ctPicker.selectedAssets = self.assets as NSMutableArray

        self.presentViewController(ctPicker, animated: true, completion: nil)

        
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

            
            var img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera;
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    // MARK: CTPickerControllerDelegate

    
    
    
    func assetsPickerController(picker: CTAssetsPickerController!, isDefaultAssetsGroup group: ALAssetsGroup!) -> Bool {
//        return [group.valueForProperty(ALAssetsGroupPropertyType).integerValue == ALAssetsGroupSavedPhotos
        return true
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
//        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)

        
        //TODO - update scroll view with new images and save to core data
        
        for selectedImg in assets {
//                cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
            let pickedAsset : ALAsset = selectedImg as ALAsset
            var img = UIImage(CGImage: pickedAsset.thumbnail().takeUnretainedValue())
            self.pickedAssets.append(img!)
            
            
        }
      
        let pageCount = pickedAssets.count
        
        // Set up the page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // Set up the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set up the content size of the scroll view
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pickedAssets.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()
        

       
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pickedAssets.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Load an individual page, first checking if you've already loaded it
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = CGRectInset(frame, 10.0, 0.0)
            
            let newPageView = UIImageView(image: pickedAssets[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        
        if page < 0 || page >= pickedAssets.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < self.pickedAssets.count; ++index {
            purgePage(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
   
    
  
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldEnableAsset asset: ALAsset!) -> Bool {
        if asset.valueForProperty(ALAssetPropertyType).isEqual(ALAssetTypeVideo) {
            var duration : NSTimeInterval = asset.valueForProperty(ALAssetPropertyDuration).doubleValue
            return lround(duration) >= 5
        } else {
            return true
        }
    }

    func assetsPickerController(picker: CTAssetsPickerController!, shouldSelectAsset asset: ALAsset!) -> Bool {
        if ctPicker.selectedAssets.count >= 10 {
          var alertView = UIAlertView(title: "Attention", message: "Please select no more than 10", delegate: nil, cancelButtonTitle: "OK")
          alertView.show()
        }
        
        if !(asset.defaultRepresentation() != nil) {
            var alertView = UIAlertView(title: "Attention", message: "Please select no more than 10", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
        }
        
        return ctPicker.selectedAssets.count < 10 && asset.defaultRepresentation() != nil
    }
    

    // MARK: - Navigation


    @IBAction func saveTrash(sender: AnyObject) {
        
        if !self.textTitle.text.isEmpty {
            self.trash.title = self.textTitle.text
        }
        self.trash.trashId = NSUUID().UUIDString

        trashArray.append(self.trash)

        
        
        var trashAsset = TrashAssets()
        
        for pa in pickedAssets {
            if pa == pickedAssets[0] {
              trashAsset = TrashAssets(img: UIImageJPEGRepresentation(pa, 0.75), trashId: self.trash.trashId, defaultImg: true)
              trashAssetsArray.append(trashAsset)

            } else {
              trashAsset = TrashAssets(img: UIImageJPEGRepresentation(pa, 0.75), trashId: self.trash.trashId, defaultImg: false)
              trashAssetsArray.append(trashAsset)
            }
        }
        if (delegate != nil) {
            trashTableViewDelegate(trashArray, trashAssetData: trashAssetsArray)
        }

//        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("showMasterFromAddTrash", sender: self)
        



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
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
               sleep(1)
                if (error == nil) {
                    let pm: AnyObject = placemarks.last!
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
    
    func trashTableViewDelegate(tableData: Array<Trash>, trashAssetData: Array<TrashAssets>) {
        delegate?.trashTableViewDelegate(trashArray, trashAssetData: trashAssetsArray)
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
    

    
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant -= keyboardFrame.size.height + 105
        })

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMasterFromAddTrash" {
            var mainTabBarVC = segue.destinationViewController as? MainTabBarViewController
            mainTabBarVC?.trashAssets = trashAssetsArray
            mainTabBarVC?.trashArray = trashArray

        }
    }
    


   
    
   
}
















