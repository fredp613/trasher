//
//  ProfileViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-27.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, tableViewProtocol  {
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var changeDefaultAddress: UIButton!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var kmText: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    
    var addCatsController: AddCategoriesTableViewController?
    var tableData: [Int:String]! = [Int:String]()
    var menuButtons = FPGoogleButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kmText.delegate = self

        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        self.kmText.text = "\(User().distance)"
        if self.tableData.isEmpty {
            tableData = InitializeTestData().initialCategories
//            Category().currentCategories = Category().initialCategories

        } else {

        }
                
         let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        
        
    }
    
    func addTrashButtonTouch(sender: UIButton) {
        
        self.performSegueWithIdentifier("addTrashFromProfileSegue", sender: self)
//        menuButtons.toggleMenuButtons()
    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        println("event fired")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.categoriesTableView.reloadData()
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)



    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kmTextChanged(sender: AnyObject) {
        if (self.kmText.text.toInt() > 500) {
            var alertView = UIAlertView(title: "Range to far", message: "The maximum distance is 500KM", delegate: self, cancelButtonTitle: "OK")
            alertView.show()

            self.distanceSlider.value = 500.00
            
        } else {
            self.distanceSlider.value = (self.kmText.text as NSString).floatValue

        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            self.kmText.text = "500"
    }
    
    //MARK: ACTIONS
    
    @IBAction func changeDistance(sender: AnyObject) {
//        self.kmLabel.text = NSString(format: "%.2f" , self.distanceSlider.value)
        self.kmText.text = "\(NSInteger(self.distanceSlider.value))"
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
    
    func tableViewDelegate(tableData: [Int : String]) {
        self.tableData = tableData
        self.categoriesTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var categoryItem = String()

           var indexedCategories = Array<String>()
            for (key, value) in self.tableData {
                indexedCategories.append(value)
            }
           categoryItem = indexedCategories[indexPath.row]
        
        cell.textLabel.text = categoryItem
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
       
        
        addCatsController = segue.destinationViewController as? AddCategoriesTableViewController
        addCatsController?.delegate = self
        addCatsController?.currentData = tableData
        
    }
    

    
        

      
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


