//
//  CurrentLocation.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation: CLLocationManagerDelegate {
    static let sharedInstance = CurrentLocation()
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation?
    
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
}
