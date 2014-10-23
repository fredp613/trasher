//
//  MasterTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import QuartzCore

class MasterTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var textSearch: UISearchBar!
    
    var locationManager = CLLocationManager()


    var trashArray = NSMutableArray()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        

        var trash = Trash()
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Used TV"
        trash.addressLine1 = "1408 Baintree place"
        trash.city = "Ottawa"
        trash.postalCode = "K1B5H5"
        trash.latitude = 45.434363
        trash.longitude = -75.560305
        trash.image = UIImage(named: "used-car")
        trashArray.addObject(trash)
        
        trash = Trash()
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "old car still good"
        trash.addressLine1 = "934 torovin private1"
        trash.city = "Ottawa1"
        trash.postalCode = "K1B0A5"
        trash.image = UIImage(named: "used-tv")
        trash.latitude = 45.438186
        trash.longitude = -75.595628
        
        trashArray.addObject(trash)
        
        trash = Trash()
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Old crib needs to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A4"
        trash.latitude = 45.415416
        trash.image = UIImage(named: "used-bbq")
        trash.longitude = -75.606957
        
        trashArray.addObject(trash)
        
        trash = Trash()
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "TV has to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A6"
        trash.image = UIImage(named: "used-crib")
        trash.latitude = 45.430959
        trash.longitude = -75.557347
        trashArray.addObject(trash)
        
        
        self.tableView.reloadData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.trashArray.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        var trashItem  = trashArray.objectAtIndex(indexPath.row)
        var trashItem: Trash = self.trashArray.objectAtIndex(indexPath.row) as Trash
        cell.textLabel?.text = trashItem.title
        cell.detailTextLabel?.text = trashItem.fullAddress()
        
        if (trashItem.image != nil) {
            var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
            imageView.layer.cornerRadius = 32.5
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            cell.indentationLevel = 75
            //set image
            imageView.image = trashItem.image as UIImage

        } else {
            
            var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
            imageView.layer.cornerRadius = 32.5
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            cell.indentationLevel = 75
            //set image
            imageView.image = UIImage(named: "trash-can-icon")

        }
        
    

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier == "showDetailSegue") {
            var detailSegue : DetailViewController = segue.destinationViewController as DetailViewController
            var path : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var trash = trashArray[path.row] as Trash
            detailSegue.currentTrash = trash
        }
        
        if (segue.identifier == "addTrashSegue") {
            
            var addTrashSegue : AddTrashViewController = segue.destinationViewController as AddTrashViewController
            addTrashSegue.trashArray = trashArray
//            self.getCurrentLocation()
            
            
        }
    
    }
    
    //MARK: - CLLocationManagerDelegate
    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        var alertView = UIAlertView()
//        alertView.message = "there was an error in finding your location - check your settings"
//        alertView.title = "man this is a title"
//        alertView.show()
//    }
//    
//    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
//        var currentLocation = newLocation as CLLocation!
//        
//        if (currentLocation != nil) {
//            println("nigga you live here: \(currentLocation)")
//            
//            var geoCoder = CLGeocoder()
//            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
//                let pm: AnyObject = placemarks.last!
//                println(pm.locality)
//                var currentAddress = pm.locality + " " + pm.postalCode
//
//            })
//            manager.stopUpdatingLocation()
//            
//        } else {
//            println("nigga we didnt made it")
//        }
//        
//    }
//
//    
//    func getCurrentLocation() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }

    

}
