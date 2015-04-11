//
//  ProfileViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-27.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//




import UIKit
import CoreData
import MobileCoreServices
import CoreLocation
import SystemConfiguration


@objc protocol ProfileDelegate {
    optional func updateDefaultLocationDelegate(moc: NSManagedObjectContext)
    optional func updateCategories(moc: NSManagedObjectContext)
}

class ProfileViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, ProfileDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var changeDefaultAddress: UIButton!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var kmText: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var kmMiButton: UIButton!

    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var currentLoc = CLLocation()
    
//    var addCatsController: AddCategoriesTableViewController?
    var tableData: [CoreUserCategories] = [CoreUserCategories]()
    var menuButtons = FPGoogleButton()
    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.kmText.delegate = self
        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        //setup
        var currentUser = CoreUser.currentUser(moc)!
        self.kmText.text = "\(currentUser.preferred_distance)"
        self.distanceSlider.value = currentUser.preferred_distance.floatValue
        self.tableData = CoreUserCategories.retrieveUserCategories(moc)

        toggleNotificationState()
        
        
        
        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
            
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
       
        if let cl : CoreLocation = CoreLocation.getDefaultLocationByUser(moc) {
            defaultAddressLabel.text = cl.addressline1 + " " +  cl.city
            if cl.country == "United States" {
                kmMiButton.setTitle("mi", forState: UIControlState.Normal)
            } else {
                kmMiButton.setTitle("km", forState: UIControlState.Normal)
            }
        } else {
            getCurrentLocation()
        }
        
    }
    
    func updateDefaultLocationDelegate(moc: NSManagedObjectContext) {
        let cl = CoreLocation.getDefaultLocationByUser(moc)
        defaultAddressLabel.text = cl!.addressline1 + " " + cl!.city
        
        if cl!.country == "United States" {
            kmMiButton.setTitle("mi", forState: UIControlState.Normal)
        } else {
            kmMiButton.setTitle("km", forState: UIControlState.Normal)
        }
    }
    
    func updateCategories(moc: NSManagedObjectContext) {
        tableData = CoreUserCategories.retrieveUserCategories(moc)
        categoriesTableView.reloadData()
    }


    
    func addTrashButtonTouch(sender: UIButton) {
        self.performSegueWithIdentifier("addTrashFromProfileSegue", sender: self)
    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        self.performSegueWithIdentifier("requestTrashFromProfileSegue", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kmTextChanged(sender: AnyObject) {
        var currentUser = CoreUser.currentUser(moc)!
        if (self.kmText.text.toInt() > 500) {
            var alertView = UIAlertView(title: "Range to far", message: "The maximum distance is 500KM", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            self.distanceSlider.value = 500.00
            
        } else {
            self.distanceSlider.value = (self.kmText.text as NSString).floatValue
            if !self.kmText.text.isEmpty {
                currentUser.preferred_distance = self.kmText.text.toInt()!
            }
            CoreUser.updateUser(moc, coreUser: currentUser)

        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            self.kmText.text = "500"
    }
    
    //MARK: ACTIONS
    
    @IBAction func changeDistance(sender: AnyObject) {
//        self.kmLabel.text = NSString(format: "%.2f" , self.distanceSlider.value)
        var currentUser = CoreUser.currentUser(moc)!
        var sliderValue = self.distanceSlider.value
        currentUser.preferred_distance = sliderValue
        self.kmText.text = "\(Int(sliderValue))"
        CoreUser.updateUser(moc, coreUser: currentUser)
    }
    
    
    //MARK: tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return self.tableData.count
    }
//
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.00
//    }
    
    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
//        var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
        var catId = self.tableData[indexPath.row].category_id
        var categoryName = CoreCategories.findCategoryById(moc, id: catId).category_name
        cell.textLabel?.text = "\(catId) - \(categoryName)"
        return cell
    }
   
    // MARK: - Navigation
    
//    func tableViewDelegate([Int:String]) {
//      
//      self.categoriesTableView.reloadData()
//
//        
//    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        
        if segue.identifier == "manageCategoriesSegue" {
            var addCatsController = segue.destinationViewController as! AddCategoriesTableViewController
            addCatsController.delegate = self
            addCatsController.currentData = tableData
        }
        
        if segue.identifier == "showLocationsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            var locationsController = navigationController.topViewController as! LocationsTableViewController
            locationsController.delegate = self
        }        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.kmText.resignFirstResponder()
    }
    
    
    //MARK: Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func myTrashWasPressed(sender: AnyObject)
    {
//        self.performSegueWithIdentifier("showMyTrashSegue", sender: self)
        
    }
    
    @IBAction func kmMiWasPressed(sender: AnyObject) {
        if kmMiButton.titleLabel?.text == "km" {
        kmMiButton.setTitle("mi", forState: UIControlState.Normal)
        } else {
            kmMiButton.setTitle("km", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func notificationSwitched(sender: AnyObject) {
        var currentUser = CoreUser.currentUser(moc)!
        if self.notificationsSwitch.on {
            currentUser.notifications_on = true
            CoreUser.updateUser(moc, coreUser: currentUser)
        } else {
            currentUser.notifications_on = false
            CoreUser.updateUser(moc, coreUser: currentUser)
        }
    }
    
    func toggleNotificationState() -> Bool {
        var currentUser = CoreUser.currentUser(moc)!
        if currentUser.notifications_on.boolValue {
            self.notificationsSwitch.setOn(true, animated: true)
            return true
        } else {
            self.notificationsSwitch.setOn(false, animated: true)
            return false
        }
    }
    
    // MARK: CLLocation
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alertView = UIAlertView(title: "Location error", message: "You are not connected to either wifi or your mobile network", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var currentLocation = newLocation as CLLocation!
        
        if (currentLocation != nil) {
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                
                if (error == nil) {
                    let pm: AnyObject = placemarks.last!
                    let coreUser = CoreUser.currentUser(self.moc)
                    let coreLocation : CoreLocation = NSEntityDescription.insertNewObjectForEntityForName("CoreLocation", inManagedObjectContext: self.moc) as! CoreLocation
                    let loc : CLLocation = pm.location
                    let coord : CLLocationCoordinate2D = loc.coordinate
                    
                    coreLocation.latitude = coord.latitude
                    coreLocation.longitude = coord.longitude
                    coreLocation.addressline1 = pm.name
                    coreLocation.city = pm.locality
                    coreLocation.zip = pm.postalCode
                    coreLocation.country = pm.country
                    println(pm.countryCode)
//                    coreLocation.country_code = pm.countryCode
                    coreLocation.default_location = true
                    coreLocation.user = coreUser!
                    
                    var error : NSError? = nil
                    if self.moc.save(&error) {
                        self.defaultAddressLabel.text = pm.name + " " + pm.locality
                        if pm.country == "United States" {
                            self.kmMiButton.setTitle("mi", forState: UIControlState.Normal)
                        }
                    } else {
                        println(error?.userInfo)
                    }
                    
                    
                } else {
                    
                    
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


