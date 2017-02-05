//
//  ServerAPI.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class ServerAPI: NSObject {
    static let sharedInstance = ServerAPI()
    
    var deviceID: String {
        get {
            return UIDevice.current.identifierForVendor!.uuidString
        }
    }
    
    private override init() {
        super.init()
    }

    var name: String?
    var notificationToken: String?
    
    func notificationTokenReceived(token: String) {
        self.notificationToken = token
    }
    
    func registerUser(name: String) {
        while (notificationToken == nil) {
            print("waiting...lets hope this escapes the loop eventually")
        }
        self.name = name
        
        let params = ["name":name,
                     "id":deviceID, "token": notificationToken!]
        
        Alamofire.request("http://10.38.44.7:42069/profiles", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }
    
    func sendLatestLocation() {
        let currentLocation = CurrentLocation.sharedInstance.currentLocation?.coordinate ?? CLLocationCoordinate2DMake(100, 100)
        
        let params = ["id": deviceID,
                      "lat":currentLocation.latitude,
                      "long":currentLocation.longitude] as [String : Any]
        
        Alamofire.request("http://10.38.44.7:42069/locations", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print("REQ: \(response.request as Any)")  // original URL request
                print("Resp: \(response.response as Any)")// URL response
                print("Resp value: \(response.result.value as Any)")   // result of response serialization
        }
    }
    
    func uploadOrder(order: OrderData) {
        let params = ["requester":deviceID,
                      "description":order.description,
                      "fromlat":order.pickUpLocation.coordinate.latitude,
                      "fromlong":order.pickUpLocation.coordinate.longitude,
                      "tolat":order.dropOffLocation.coordinate.latitude,
                      "tolong":order.dropOffLocation.coordinate.longitude,
                      "details":order.orderDetails] as [String : Any]
        
        Alamofire.request("http://10.38.44.7:42069/requests", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print("REQ: \(response.request as Any)")  // original URL request
                print("Resp: \(response.response as Any)")// URL response
                print("Resp value: \(response.result.value as Any)")   // result of response serialization
        }
    }
}
