//
//  Util.swift
//  Tripper
//
//  Created by Pinghsien Lin on 12/2/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import Foundation
import SwiftyJSON

func  getJson(_ fileName: String) -> JSON? {
    guard let path =  Bundle.main.path(forResource: fileName, ofType: "json") else {
        return nil
    }
    
    if let jsonData = try? NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe) {
        return JSON(data:jsonData as Data)
    } else {
        return nil
    }
}
