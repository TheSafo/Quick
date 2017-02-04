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
    var requesterID: Int
    var price: Double
    var pickUpLocation: CLLocation
    var dropOffLocation: CLLocation
    
    var claimed: Bool
    var acceptorID: Int?
    
    
    init(description: String, requestID: Int, price: Double, pickUpLocation: CLLocation, dropOffLocation: CLLocation) {
        self.description = description
        self.requestID = requestID
        self.price  = price
        self.pickUpLocation = pickUpLocation
        self.dropOffLocation = dropOffLocation
        self.claimed = false
    }
    
    func getDistanceToPickUp()->CLLocationDistance {
        return pickUpLocation.distance(from: CurrentLocation.sharedInstance.currentLocation);
    }
    
    func claimOrder()->Bool {
        if self.claimed == false {
            self.claimed = true;
            
            self.acceptorID = UUID().uuidString;
            //INSERT SERVER STUFF
            return true;
        }
        return false;
    }
}