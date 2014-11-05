//
//  ProfileViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-27.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIAlertViewDelegate {
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var removeCategory: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var changeDefaultAddress: UIButton!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var kmText: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kmText.text = "\(User().distance)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
  
    @IBAction func textChanged(sender: AnyObject) {
        var textDistance : NSString = self.kmText.text as NSString
        
        if (textDistance.intValue > 500) {
            var alertView = UIAlertView(title: "Range to far", message: "The maximum distance is 500KM", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            
        } else {
            self.distanceSlider.value = (textDistance).floatValue
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            self.kmText.text = "500"
    }

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: ACTIONS
    
    @IBAction func switchNotifications(sender: AnyObject) {
        
    }
    
    @IBAction func changeDistance(sender: AnyObject) {
//        self.kmLabel.text = NSString(format: "%.2f" , self.distanceSlider.value)
        self.kmText.text = "\(NSInteger(self.distanceSlider.value))"
    }
    
    @IBAction func addCategory(sender: AnyObject) {
    }

    @IBAction func removeCategory(sender: AnyObject) {
    }
    
    @IBAction func changeAddress(sender: AnyObject) {
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
        return Category().initials1.count
    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.00
//    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var categoryItem = Category().initials1[indexPath.row + 1]
        cell.textLabel.text = categoryItem
        return cell
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
