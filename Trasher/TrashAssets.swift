//
//  TrashAssets.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-24.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class TrashAssets {
    var trashImage : NSData!
    var trashId : String!
    var defaultImage : Bool!
    
    init() {
        
    }
    
    init(img: NSData, trashId: String, defaultImg: Bool ) {
        self.trashImage = img
        self.trashId = trashId
        self.defaultImage = defaultImg
    }
    
    class func getMainTrashImage(trashAssetArray: [TrashAssets] ,trashId: String) -> NSData {
        
        var trashAssets = trashAssetArray
        var trashArray = InitializeTestData().trashArray
        

        
        for ta in trashAssets {
            if trashId == ta.trashId {

                if ta.defaultImage.boolValue == true {

                    return ta.trashImage
                }
            }

        }
        return UIImageJPEGRepresentation(UIImage(named: "trash-can-icon"), 0.75)
    }
    
    class func getTrashImagesByTrashId(trashAssetArray: [TrashAssets], trashId: String!) -> [NSData] {
        
        var trashAssets = trashAssetArray
        var results : [NSData] = [NSData]()
        
        
        for ta in trashAssets {
           let tId = ta.trashId
            
            if trashId == tId {
                results.append(ta.trashImage)
            }
        }

        return results
    }
    
}
