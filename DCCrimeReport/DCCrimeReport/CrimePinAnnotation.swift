//
//  CrimePinAnnotation.swift
//  DCCrimeReport
//
//  Created by Kieran Raftery on 4/12/15.
//  Copyright (c) 2015 Kieran Raftery. All rights reserved.
//

import Foundation
import MapKit

class CrimePinAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var crime: Crime!
    var title: String!
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}