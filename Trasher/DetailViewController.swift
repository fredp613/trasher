
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

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailTitle: UILabel!




    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    var currentTrash = Trash()
    var trashAssets = [TrashAssets]()
    var assets = []
    var trashImages = [NSData]()
    var containerView : UIView!
    var pageViews: [UIImageView?] = []
    var menuButtons = FPGoogleButton()
    
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

        
        self.trashImages = TrashAssets.getTrashImagesByTrashId(trashAssets, trashId: currentTrash.trashId)
        let pageCount = trashImages.count
        
        // Set up the page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // Set up the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set up the content size of the scroll view
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(trashImages.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()

        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        
    }
    
    func addTrashButtonTouch(sender: UIButton) {
        if User.registeredUser() {
            self.performSegueWithIdentifier("addTrashFromDetailSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("signUpFromDetailSegue", sender: self)
        }
    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        if User.registeredUser() {
            self.performSegueWithIdentifier("requestTrashFromDetailSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("signUpFromDetailSegue", sender: self)
        }
    }

    
    // MARK: scroll view delegates and custom functions
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= trashImages.count {
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
            
            let newPageView = UIImageView(image: UIImage(data: trashImages[page]))
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        
        if page < 0 || page >= trashImages.count {
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
        for var index = lastPage+1; index < self.trashImages.count; ++index {
            purgePage(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        let poiCoordinates = CLLocationCoordinate2D(latitude: Double(currentTrash.latitude), longitude: Double(currentTrash.longitude)) as CLLocationCoordinate2D;
//        
//        var viewRegion = MKCoordinateRegionMakeWithDistance(poiCoordinates, 750, 750)
//        self.mapView.setRegion(viewRegion, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.setCoordinate(poiCoordinates)
//        annotation.title = currentTrash.postalCode
//        annotation.subtitle = currentTrash.title
//        self.mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier == "viewMapSegue") {
            var mapSegue : MapViewController = segue.destinationViewController as MapViewController
            mapSegue.currentTrash = currentTrash

        }
    }

}
