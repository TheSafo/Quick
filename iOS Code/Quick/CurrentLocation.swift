//
//  CurrentLocation.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = CurrentLocation()
    override fileprivate init() {}
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var lastTime = 0

    func startLocationManager() {
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if abs(lastTime - Timestamp()) > 4 {
            HomeViewController.sharedInstance.refreshTable()
        }
        
        if abs(lastTime - Timestamp()) < 10 {
            return
        }
        
        lastTime = Timestamp()
        
        print("Got location update! \(locations[0])")
        currentLocation = locations[0]
        HomeViewController.sharedInstance.refreshTable()
        
        //SERVER STUFF
        if (ServerAPI.sharedInstance.userRegistered) {
            ServerAPI.sharedInstance.sendLatestLocation()
        }
    }
    

}


func Timestamp() -> Int {
    return Int(round(NSDate().timeIntervalSince1970))
}
