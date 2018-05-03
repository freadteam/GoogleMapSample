//
//  Pin.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/02.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import GoogleMaps

class Pin: NSObject {

    var objectId: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var title: String?
    var text: String?
    
    init(objectId: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.objectId = objectId
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
