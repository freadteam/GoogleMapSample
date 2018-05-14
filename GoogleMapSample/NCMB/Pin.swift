//
//  Pin.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/05.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import GoogleMaps

class Pin: NSObject {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var title: String
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
    }
    
}
