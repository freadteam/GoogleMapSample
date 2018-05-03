//
//  Marker.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/03.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import GoogleMaps

class Marker: NSObject {
    var objectId: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var title: String
    var text: String?
    
    init(objectId: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        self.objectId = objectId
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
    }
    
}
