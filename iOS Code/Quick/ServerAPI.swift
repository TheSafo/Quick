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
        if let name = self.name, let number = self.number {
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
        
        let params = ["name":name, "phone": number,
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
                    order.orderID = Int(orderID)
                    OrderManagement.sharedInstance.placedNewOrder(newOrder: order)
                }
        }
    }
    
//    func getClosestOrders()->[OrderData]? {
    func getClosestOrders() {
        guard let currentLocation = CurrentLocation.sharedInstance.currentLocation?.coordinate else {
            print("NO LOCATION!!!!!!!")
//            return nil;
            return
        }

        let params = ["id": ServerAPI.sharedInstance.deviceID, "lat":currentLocation.latitude,
                      "lon":currentLocation.longitude] as [String : Any]

        var orders: [OrderData]?
        Alamofire.request("http://10.38.44.7:42069/requests", method: .get, parameters: params, encoding: URLEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if let data = response.result.value as? [String:AnyObject],
                let results = data["results"] as? [[String:AnyObject]] {
                    for result in results {
                        let pickUpLocation = CLLocation.init(latitude: Double(result["fromlat"] as! NSNumber), longitude: Double(result["fromlon"] as! NSNumber))
                        let dropOffLocation = CLLocation.init(latitude: Double(result["tolat"] as! NSNumber), longitude: Double(result["tolon"] as! NSNumber))
                        
                        let order = OrderData(description: result["description"] as! String, orderDetails: result["details"] as! String, requestID: result["requester"] as! String, price: Double(result["price"] as! NSNumber), pickUpLocation: pickUpLocation, dropOffLocation: dropOffLocation)
                        order.orderID = (Int(result["id"] as! NSNumber))
                        
                        if orders == nil {
                            orders = [OrderData]()
                        }
                        orders!.append(order)
                    }
                    if let orders = orders {
                        HomeViewController.sharedInstance.availableOrders = orders
                        HomeViewController.sharedInstance.tableView.reloadData()
//                        HomeViewController.sharedInstance.refreshTable()
                    }
                } else {
                    print("whoops")
                }
            }
//        return orders
    }
    
    func claimOrder(order: OrderData) {
        let params = ["id":order.orderID!,
                      "accepter":ServerAPI.sharedInstance.deviceID]
            as [String : Any]
        
        Alamofire.request("http://10.38.44.7:42069/requests", method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if let data = response.result.value as? [String:AnyObject] {
                    order.claimed = true
                    order.acceptorID = ServerAPI.sharedInstance.deviceID
                    order.pickUpNumber = data["name"] as? String
                    order.pickUpName = data["phone"] as? String
                    OrderManagement.sharedInstance.claimedNewOrder(newOrder: order)
                } else {
                    print("whoops")
                }
            }
    }
}
