//
//  Api.swift
//  Trasher
//
//  Created by Fred Pearson on 2015-02-12.
//  Copyright (c) 2015 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

enum httpMethodEnum : String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case UPDATE = "UPDATE"
}

class TrasherAPI : NSObject, UIAlertViewDelegate {
    
    class func APIPublicRequest(moc: NSManagedObjectContext, httpMethod: httpMethodEnum, params: [String:AnyObject]?, url: String, completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        
        let urlSession = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = httpMethod.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var err: NSError?
        //params are only for http post requests. For get Requests make sure not to populate the httpBody otherwise you get error
        if httpMethod.rawValue == "POST" {
            if let params = params {
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            }
        }
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let err = error {
                
                let alert = UIAlertView(title: "Something went wrong please try again", message: "Server error", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                return
            }
            if error == nil {
                if let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                    let parsedData = JSON(json!)
                    return completionHandler(responseObject: parsedData, error: nil)
                } else {
                    return completionHandler(responseObject: nil, error: error)
                }
            }
        }
    }


    class func APIAuthenticatedRequest(moc: NSManagedObjectContext, httpMethod: httpMethodEnum, url: String, params: [String:AnyObject]?, completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        
        let urlSession = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = httpMethod.rawValue

            if let currentUser = CoreUser.currentUser(moc) {
                request.setValue("fredp@gmail.com", forHTTPHeaderField: "X-API-EMAIL")
                request.setValue(CoreUser.getUserToken(currentUser)!, forHTTPHeaderField: "X-API-TOKEN")
            }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                
        var err: NSError?
        if httpMethod.rawValue != "GET"  {
            if let params = params {
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            }
        }
        

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let err = error {
                
                let alert = UIAlertView(title: "Something went wrong please try again", message: "Connection error", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                return
            }
            
            if error == nil {

                if let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                    let parsedData = JSON(json!)
                    return completionHandler(responseObject: parsedData, error: nil)
                } else {
                    return completionHandler(responseObject: nil, error: error)
                }
            }
            
        }
    }
    
  
    
}