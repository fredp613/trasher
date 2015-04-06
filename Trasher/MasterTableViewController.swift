
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


@objc protocol PopulateMasterTableViewDelegate {
    optional func refreshRequestedData(tableData: [Trash], tableDataAssets: [TrashAssets])
    optional func refreshWantedData(tableData: [Trash])
}

class MasterTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate,
CLLocationManagerDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UITabBarDelegate,  PopulateMasterTableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager = CLLocationManager()
    var trashArray = [Trash]()
    var trashAssets = [TrashAssets]()
    var thumbnails = [NSData]()
    var filteredTrash = [Trash]()
    var maskView = UIView()
    var searchState : Bool = false
    var menuButtons = FPGoogleButton()
    var testData = InitializeTestData()
    var requestedTrash = [Trash]()
    var wantedTrash = [Trash]()
    var managedObjectContext = CoreDataStack().managedObjectContext
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        setTrashArrays()
        
        self.navigationController?.navigationBar.topItem?.title = "Trash \(User().distance) km from you"
        
        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        
        refreshControl.backgroundColor = UIColor.lightGrayColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        var searchBarTextField : UITextField = UITextField()
    }
    
    func setTrashArrays(setActivityIndicator: Bool = true) {
        
        var activityIndicator : UIActivityIndicatorView!
        
        if setActivityIndicator {
            activityIndicator = CustomActivityIndicator.activate(self.view)
        }
        
        var trashType : String!
        
        if searchBar.selectedScopeButtonIndex == 0 {
            trashType = "Wanted"
        } else {
            trashType = "rid"
        }
//        println(trashType)
        
            Trash.getTrashFromAPI(self.managedObjectContext!, trashType: trashType, completionHandler: { (data, error) -> Void in
                if (data != nil) {
                        var trashData = data
                        Trash.getTrashImageFromAPI(self.managedObjectContext!, completionHandler: { (data, error) -> Void in
                            if (data != nil) {
                                self.trashArray = trashData
                                self.trashAssets = data
                                self.thumbnails = self.trashAssets.map{$0.trashImage}
                                self.filteredTrash = self.trashArray
//                                if self.searchBar.selectedScopeButtonIndex == 0 {
//                                    self.filteredTrash = Trash.filterRequestedTrash(self.trashArray)
//                                } else {
//                                    self.filteredTrash = Trash.filterWantedTrash(self.trashArray)
//                                }
                            } else {
                                println(error)
                            }
                            self.tableView.reloadData()
                            if setActivityIndicator {
                                CustomActivityIndicator.deactivate(activityIndicator)
                            }

                        })
                    
                } else {
                    println(error)
                }
            })
       
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func refreshTableView() {
        setTrashArrays(setActivityIndicator: false)
        refreshControl.endRefreshing()
    }
    
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text = ""
        self.filteredTrash.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        setTrashArrays()
    }
    

    
    func addTrashButtonTouch(sender: UIButton) {
        if CoreUser.userIsRegistered(managedObjectContext!) {
            if CoreUser.userIsLoggedIn(managedObjectContext!) {
                self.performSegueWithIdentifier("addTrashFromMasterSegue", sender: self)
            } else {
                self.performSegueWithIdentifier("showLoginFromMasterSegue", sender: self)
            }
        } else {
            self.performSegueWithIdentifier("signUpFromMasterSegue", sender: self)
        }

    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        if CoreUser.userIsRegistered(managedObjectContext!) {
            if CoreUser.userIsLoggedIn(managedObjectContext!) {
                self.performSegueWithIdentifier("requestTrashFromMasterSegue", sender: self)
            } else {
                self.performSegueWithIdentifier("showLoginFromMasterSegue", sender: self)
            }
        } else {
            self.performSegueWithIdentifier("signUpFromMasterSegue", sender: self)
        }
    }
    
    func drawRoundButton(btn: UIButton) {
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredTrash.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredTrash = filterTextForSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearSearch()
    }
    
    func clearSearch() {
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
        maskView.removeFromSuperview()
    }
    
    func filterTextForSearch(keyword: String!) -> Array<Trash> {
        searchState = true
        //this needs to be refactored to go to API
        self.filteredTrash = self.filteredTrash.filter({(trash:Trash) -> Bool in
            let descriptionMatch = trash.title.rangeOfString(keyword, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
            return descriptionMatch != nil
        })
        
        if keyword.isEmpty {
            searchState = false
        }
        
        return self.filteredTrash
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var trash : Trash
        trash = self.filteredTrash[indexPath.row]
        
        cell.textLabel?.text = "\(trash.title) - \(trash.trashType) - \(trash.trash_category)"
        cell.detailTextLabel?.text = trash.fullAddress()
        
        var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        
        cell.addSubview(imageView)
        cell.indentationLevel = 70
        if let thumbnail = TrashAssets.getThumbnail(self.trashAssets, trashId: trash.trashId) {
            imageView.image = UIImage(data: thumbnail)
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
        if (segue.identifier == "showDetailsSegue") {
            
            var detailSegue : DetailViewController = segue.destinationViewController as DetailViewController
            var trash : Trash
            let path = self.tableView.indexPathForSelectedRow()
            trash = self.filteredTrash[path!.row] as Trash
            
            var filteredAssets = trashAssets.filter({ m in
                m.trashId == trash.trashId
            })
            
            var trashImages = filteredAssets.map{$0.trashImage!}
            detailSegue.currentTrash = trash
            detailSegue.trashImages = trashImages
            
        }
        
        if segue.identifier == "addTrashFromMasterSegue" {
            var addTrashController = segue.destinationViewController as AddTrashViewController
            addTrashController.trashArray = trashArray
            addTrashController.trashAssetsArray = trashAssets
            addTrashController.delegate = self
            
        }
        
        if segue.identifier == "requestTrashFromMasterSegue" {
            var requestTrashController = segue.destinationViewController as RequestTrashViewController
            requestTrashController.trashArray = trashArray
            requestTrashController.trashAssets = trashAssets
            requestTrashController.delegate = self
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.searchBar.resignFirstResponder()
        maskView.removeFromSuperview()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //add blocking view
        
        maskView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 75, self.tableView.frame.width, self.tableView.frame.height)
        maskView.backgroundColor = UIColor(white: 0.98, alpha: 0.8)
        maskView.bounds = CGRectMake(0, -150, self.tableView.frame.width, (self.view.frame.height -  350))
        self.view.addSubview(maskView)
    }
    
    //MARK: Master table view delegate implementation
    
    func refreshRequestedData(tableData: [Trash], tableDataAssets: [TrashAssets]) {
        setTrashArrays()
    }
    
    func refreshWantedData(tableData: [Trash]) {
        setTrashArrays()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}