//
//  MapViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-25.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var currentTrash = Trash()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let poiCoordinates = CLLocationCoordinate2D(latitude: Double(currentTrash.latitude), longitude: Double(currentTrash.longitude)) as CLLocationCoordinate2D;

        var viewRegion = MKCoordinateRegionMakeWithDistance(poiCoordinates, 750, 750)
        self.mapView.setRegion(viewRegion, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = poiCoordinates
        annotation.title = currentTrash.postalCode
        annotation.subtitle = currentTrash.title
        self.mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
