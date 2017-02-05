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
    var orderDetails: String
    var requesterID: String
    var price: Double
    var pickUpLocation: CLLocation
    var dropOffLocation: CLLocation
    
    var orderID: Int?
    
    var claimed: Bool
    var acceptorID: String?
    
    var pickUpNumber: String?
    var pickUpName: String?
    
    init(description: String, orderDetails: String, requestID: String, price: Double, pickUpLocation: CLLocation, dropOffLocation: CLLocation) {
        self.description = description
        self.orderDetails = orderDetails
        self.requesterID = requestID
        self.price  = price
        self.pickUpLocation = pickUpLocation
        self.dropOffLocation = dropOffLocation
        self.claimed = false
    }
    
    func getDistanceToPickUp()->CLLocationDistance {
        return pickUpLocation.distance(from: CurrentLocation.sharedInstance.currentLocation ?? CLLocation(latitude: 100.001, longitude: 100.001))
    }
    
    func claimOrder()->Bool {
        if self.claimed == false {
            self.claimed = true
            
            self.acceptorID = ServerAPI.sharedInstance.deviceID
            //INSERT SERVER STUFF
            return true
        }
        return false
    }
}
