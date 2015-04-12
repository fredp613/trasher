//
//  UrlAPI.swift
//  Trasher
//
//  Created by Fred Pearson on 2015-04-12.
//  Copyright (c) 2015 Frederick Pearson. All rights reserved.
//

import Foundation


class APIUrls {
    static let publicUrl : String = "http://trasher.herokuapp.com"
    static let secureUrl : String = "https://trasher.herokuapp.com"
    
    static let get_trashes_public = APIUrls.publicUrl + "/trashes/index_api"
    static let get_user_trashes = APIUrls.secureUrl + "/trashes/user_index"
    static let create_trash = APIUrls.secureUrl + "/trashes"
    static let update_trash = APIUrls.secureUrl + "/trashes/"
    static let delete_trash = APIUrls.secureUrl + "/trashes/"
    static let get_trash_images = APIUrls.secureUrl + "/trash_images"
    static let create_trash_image = APIUrls.secureUrl + "/trash_images"
    static let update_trash_image = APIUrls.secureUrl + "/trash_images/update"
    static let destroy_trash_image = APIUrls.secureUrl + "/trash_images/destroy"
    static let login = APIUrls.secureUrl + "/users/sign_in"
    static let register = APIUrls.secureUrl + "/users/signup"
    static let logout = APIUrls.secureUrl + "/users/logout"
    
    init() {
        
    }
    
    class func get_trash_images_with_param(params: [String : String]) -> String {
        var url = APIUrls.get_trash_images + "?"
        let lastElementIndex = params.count - 1
        for (i,p) in enumerate(params) {
            if params.count == 1 {
                url += p.0 + "=" + p.1
            } else {
                if i == lastElementIndex {
                    url += p.0 + "=" + p.1
                } else {
                    url += p.0 + "=" + p.1 + "?"
                }
                
            }
            
        }
        return url
    }
}