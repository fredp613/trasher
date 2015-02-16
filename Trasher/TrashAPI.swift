//
//  Api.swift
//  Trasher
//
//  Created by Fred Pearson on 2015-02-12.
//  Copyright (c) 2015 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData


class TrasherAPI : NSObject, UIAlertViewDelegate {

    class func APIUserRegistrationRequest(moc: NSManagedObjectContext, email: String, password: String, completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        
        let params = [
            "user": ["email" : email,
                "password" : password,
                "password_confirmation" : password]
        ]
        
        request(Method.POST, "https://trasher.herokuapp.com/users", parameters: params, encoding: ParameterEncoding.URL).responseJSON {
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
    
//    class func APIPostRequest(url: String, params: [String:AnyObject], completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
//
//
//        request(Method.POST, url, parameters: params, encoding: ParameterEncoding.URL).responseJSON {
//            (request, response, jsonFromNetworking, error) in
//            
//            if response?.statusCode == 200 {
//                let json = JSON(jsonFromNetworking!)
//                if (error != nil) {
//                    return completionHandler(responseObject: json, error: nil)
//                } else {
//                    return completionHandler(responseObject: nil, error: error)
//                }
//            }
//        }
//    }
//
//
//    class func APIGetRequest(url: String, params: [String:AnyObject], completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
//        
//        request(Method.GET, url, parameters: params, encoding: ParameterEncoding.URL).responseJSON {
//            (request, response, jsonFromNetworking, error) in
//        
//            if response?.statusCode == 200 {
//                let json = JSON(jsonFromNetworking!)
//                if (error != nil) {
//                    return completionHandler(responseObject: json, error: nil)
//                } else {
//                    return completionHandler(responseObject: nil, error: error)
//                }
//            }
//        }
//    }
//    
//    class func APIPostRequestWithAuth(url: String, params: [String:AnyObject], completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
//        let aManager = Manager.sharedInstance
//        aManager.session.configuration.HTTPAdditionalHeaders = [
//            "X-API-TOKEN": "teasdfasfsdfds", "X-API-EMAIL": "coreuser.email"]
//        
//        request(Method.POST, url, parameters: params, encoding: ParameterEncoding.URL).responseJSON {
//            (request, response, jsonFromNetworking, error) in
//            
//
//            if response?.statusCode == 200 {
//                let json = JSON(jsonFromNetworking!)
//                if (error != nil) {
//                    return completionHandler(responseObject: json, error: nil)
//                } else {
//                    return completionHandler(responseObject: nil, error: error)
//                }
//            }
//        }
//    }
//    
//    class func APIGetRequestWithAuth(url: String, params: [String:AnyObject], completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
//        let aManager = Manager.sharedInstance
//        aManager.session.configuration.HTTPAdditionalHeaders = [
//            "X-API-TOKEN": "teasdfasfsdfds", "X-API-EMAIL": "coreuser.email"]
//        
//        request(Method.GET, url, parameters: params, encoding: ParameterEncoding.URL).responseJSON {
//            (request, response, jsonFromNetworking, error) in
//            
//            if response?.statusCode == 200 {
//                let json = JSON(jsonFromNetworking!)
//                if (error != nil) {
//                    return completionHandler(responseObject: json, error: nil)
//                } else {
//                    return completionHandler(responseObject: nil, error: error)
//                }
//            }
//
//        }
//    }
    
    class func loginUserInAPI(user: CoreUser) -> Bool {
        return false
    }
    
    class func logoutUserInAPI(user: CoreUser) -> Bool {
        return false
    }
    
    class func destroyUserInAPI(user: CoreUser) -> Bool {
        return false
    }
    
    //CRUD Trash
    
    class func createTrashInAPI() -> Bool {
        return false
    }
    
    class func updateTrashInAPI() -> Bool {
        return false
    }
    
    class func getTrashFromAPI() -> Bool {
        return false
    }
    
    class func destroyTrashInAPI() -> Bool {
        return false
    }
    
    
    
    
    
    
    
    
}