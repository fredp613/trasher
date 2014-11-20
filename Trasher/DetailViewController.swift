
//
//  DetailViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailImageButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var currentTrash = Trash()
    
    @IBAction func viewAddditionalDetailsButton(sender: AnyObject) {
        
        var alert = UIAlertView()
        alert.message = "hi how you"
        alert.show()
    }
    
//    struct CLLocationCoordinate2D { var latitude: CLLocationDegrees var longitude: CLLocationDegrees }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        self.detailAddress.text = currentTrash.fullAddress()
        self.detailTitle.text = currentTrash.title
//
        if UIImage(data: currentTrash.image) == nil {
            self.detailImageButton.setTitle("No Image Provided", forState: nil)
            self.detailImageButton.enabled = false

        } else {
            self.detailImageButton.setImage(UIImage(data: currentTrash.image), forState: nil)
            self.detailImageButton.enabled = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let poiCoordinates = CLLocationCoordinate2D(latitude: Double(currentTrash.latitude), longitude: Double(currentTrash.longitude)) as CLLocationCoordinate2D;
        
        var viewRegion = MKCoordinateRegionMakeWithDistance(poiCoordinates, 750, 750)
        self.mapView.setRegion(viewRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(poiCoordinates)
        annotation.title = currentTrash.postalCode
        annotation.subtitle = currentTrash.title
        self.mapView.addAnnotation(annotation)
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
