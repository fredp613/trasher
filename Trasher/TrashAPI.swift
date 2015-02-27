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

    class func APIGetRequest(url: String, params: [String:AnyObject], completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        request(Method.GET, url, parameters: params, encoding: ParameterEncoding.URL).responseJSON {
            (request, response, jsonFromNetworking, error) in
        
            if response?.statusCode == 200 {
                let json = JSON(jsonFromNetworking!)
                if (error == nil) {
                    return completionHandler(responseObject: json, error: nil)
                } else {
                    return completionHandler(responseObject: nil, error: error)
                }
            }
        }
    }

    class func APIUserAuth(moc: NSManagedObjectContext, httpMethod: httpMethodEnum, url: String, params: [String:AnyObject]?, completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        
        let urlSession = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = httpMethod.rawValue
        
        
        if let currentUser = CoreUser.currentUser(moc) {
            request.setValue("fredp613@gmail.com", forHTTPHeaderField: "X-API-EMAIL")
            request.setValue(CoreUser.getUserToken(currentUser)!, forHTTPHeaderField: "X-API-TOKEN")
            println("\(CoreUser.getUserToken(currentUser)) This is the current user's token")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                
        var err: NSError?
        if let params = params {
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        }

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let err = error {
                println(err)
            }
            
            if let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                let parsedData = JSON(json!)
//                println(JSON(json!))
                return completionHandler(responseObject: parsedData, error: nil)
            } else {
                return completionHandler(responseObject: nil, error: error)
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
}