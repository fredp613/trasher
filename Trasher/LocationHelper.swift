//
//  LocationHelper.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-30.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreLocation
import SystemConfiguration
import CoreData

class LocationHelper : NSObject, CLLocationManagerDelegate, UINavigationControllerDelegate {
    
    var currentLocation = NSString()
    var locationManager = CLLocationManager()
    var currentLoc = CLLocation()
    var moc : NSManagedObjectContext!
//    override init() {
//        super.init()
////        getCurrentLocation()
//    }
    
    init(managedObjectCtx: NSManagedObjectContext!) {
      super.init()
      moc = managedObjectCtx
      self.getCurrentLocation()
    }
    
  
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
                    let coreUser = CoreUser.currentUser(self.moc!)
                    let coreLocation : CoreLocation = NSEntityDescription.insertNewObjectForEntityForName("CoreLocation", inManagedObjectContext: self.moc!) as CoreLocation
                    let loc : CLLocation = pm.location
                    let coord : CLLocationCoordinate2D = loc.coordinate
                    
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
                        println("saved")
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
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}