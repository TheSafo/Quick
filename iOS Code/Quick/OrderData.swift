//
//  OrderData.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class OrderData {
    var description: String
    var requestID: Int
    var price: Double
    var pickUpLocation: CLLocation
    var dropOffLocation: CLLocation
    
    
    init(description: String, requestID: Int, price: Double, pickUpLocation: CLLocation, dropOffLocation: CLLocation) {
        self.description = description
        self.requestID = requestID
        self.price  = price
        self.pickUpLocation = pickUpLocation
        self.dropOffLocation = dropOffLocation
    }
    
    func getDistanceToPickUp()->CLLocationDistance {
        return pickUpLocation.distance(from: CurrentLocation.sharedInstance.currentLocation);
    }
}
