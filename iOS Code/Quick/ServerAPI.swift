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
    override fileprivate init() {}
    
    var deviceID: String {
        get {
            return UIDevice.current.identifierForVendor!.uuidString
        }
    }

    var name: String?
    var number: String?
    var notificationToken: String?
    
    var userRegistered = false
    
    func notificationTokenReceived(token: String) {
        self.notificationToken = token
        
        userRegistered = true
        if let name = self.name {
            self.registerUser(name: name, number: number)
        }
    }
    
    func registerUser(name: String, number: String?) {
        
        self.name = name
        self.number = number

        guard userRegistered else {
            print("User not registered try again later!")
            return
        }
        
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
        guard let currentLocation = CurrentLocation.sharedInstance.currentLocation?.coordinate else {
            return;
        }
        
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
                      "price":order.price,
                      "fromlat":order.pickUpLocation.coordinate.latitude,
                      "fromlon":order.pickUpLocation.coordinate.longitude,
                      "tolat":order.dropOffLocation.coordinate.latitude,
                      "tolon":order.dropOffLocation.coordinate.longitude,
                      "details":order.orderDetails] as [String : Any]
        
        Alamofire.request("http://10.38.44.7:42069/requests", method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseString { response in
                print("REQ: \(response.request as Any)")  // original URL request
                print("Resp: \(response.response as Any)")// URL response
                print("Resp value: \(response.result.value as Any)")   // result of response serialization
                //Update the order's orderID, then
                if let orderID = response.result.value {
                    order.orderID = orderID
                    OrderManagement.sharedInstance.placedNewOrder(newOrder: order)
                }
        }
    }
}
