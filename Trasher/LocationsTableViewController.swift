//
//  LocationsTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2015-01-01.
//  Copyright (c) 2015 Frederick Pearson. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import CoreLocation
import SystemConfiguration

class LocationsTableViewController: UITableViewController,CLLocationManagerDelegate, UINavigationControllerDelegate, ProfileDelegate {

    var moc : NSManagedObjectContext!
    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var modalContainer = UIView()
    var delegate:ProfileDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = CoreDataStack().managedObjectContext!
//        delegate = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementaContion.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let cls = CoreLocation.getAllUserLocations(moc)
        return cls!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var cls : [CoreLocation]? = CoreLocation.getAllUserLocations(moc!) as [CoreLocation]?
        let cl = cls?[indexPath.row]
        
        cell.textLabel?.text = cl!.addressline1 + " " + cl!.city
        
        if cl?.default_location == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let cls = CoreLocation.getAllUserLocations(moc!)
        let cl = cls?[indexPath.row] as CoreLocation!
        
        if cl.default_location == false {
            CoreLocation.removeCurrentDefault(moc)
            tableView.reloadData()
            cl.default_location = true
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark

        } else {
            if cl.default_location != true {
                cl.default_location = false
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        moc!.save(nil)
        updateDefaultLocationDelegate(moc)

    }
    
    func updateDefaultLocationDelegate(moc: NSManagedObjectContext) {
        delegate?.updateDefaultLocationDelegate(moc)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    @IBAction func closeWasPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

        
    @IBAction func addLocationWasPressed(sender: AnyObject) {
        

        modalContainer.backgroundColor = UIColor.whiteColor()
        modalContainer.frame = CGRectMake(self.tableView.layer.position.x / 4, self.tableView.layer.position.y / 2, self.tableView.frame.width - 100, self.tableView.frame.height / 4)
        
        modalContainer.layer.borderWidth = 1.0
        modalContainer.layer.cornerRadius = 12
        modalContainer.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
        var currentLocationBtn = UIButton()
        currentLocationBtn.setTitle("use current location", forState: UIControlState.Normal)
        currentLocationBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        currentLocationBtn.frame = CGRectMake(modalContainer.layer.position.x / 4, modalContainer.layer.position.y - 220, 200, 50)
        currentLocationBtn.backgroundColor = UIColor.blueColor()
        currentLocationBtn.addTarget(self, action: "getCurrentLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        
        modalContainer.addSubview(currentLocationBtn)
        
        var manualLocationBtn = UIButton()
        manualLocationBtn.setTitle("add manually", forState: UIControlState.Normal)
        manualLocationBtn.frame = CGRectMake(modalContainer.layer.position.x / 4, modalContainer.layer.position.y - 150, 200, 50)
        manualLocationBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        manualLocationBtn.backgroundColor = UIColor.blueColor()
        manualLocationBtn.addTarget(self, action: "addManualLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        modalContainer.addSubview(manualLocationBtn)
        
        self.tableView.addSubview(modalContainer)
    }
    
    func getCurrentLocation(sender: UIButton?) {
        getCurrentLocation()
        modalContainer.removeFromSuperview()
    }
    
    func addManualLocation(sender: UIButton?) {
        performSegueWithIdentifier("addLocationSegue", sender: sender)
    }
    
    
    // MARK: CLLocation
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var alertView = UIAlertView(title: "Location already exists", message: "This location is already in your list of locations. To choose your current location as a default location simply touch your current location on the list", delegate: self, cancelButtonTitle: "OK")
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
                    let loc : CLLocation = pm.location
                    let coord : CLLocationCoordinate2D = loc.coordinate
                //update current default location to non default
                    
                    CoreLocation.removeCurrentDefault(self.moc)
                    
                    
                    
                    
                    if let cl = CoreLocation.locationExists(self.moc, latitude: coord.latitude, longitude: coord.longitude) {
                        println("location exists")
                        cl.default_location = true
                        self.moc.save(nil)
                        self.tableView.reloadData()
                    } else {
                        let coreLocation : CoreLocation = NSEntityDescription.insertNewObjectForEntityForName("CoreLocation", inManagedObjectContext: self.moc) as CoreLocation
                        coreLocation.latitude = coord.latitude
                        coreLocation.longitude = coord.longitude
                        coreLocation.addressline1 = pm.name
                        coreLocation.city = pm.locality
                        coreLocation.zip = pm.postalCode
                        coreLocation.country = pm.country
                        coreLocation.default_location = true
                        coreLocation.user = coreUser
                        
                        var error : NSError? = nil
                        if self.moc.save(&error) {
                            self.tableView.reloadData()
                        } else {
                            println(error?.userInfo)
                        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
