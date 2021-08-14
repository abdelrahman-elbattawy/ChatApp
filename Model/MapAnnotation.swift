//
//  MapAnnotation.swift
//  ChatApp
//
//  Created by Aboody on 11/08/2021.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.coordinate = coordinate
    }
}
