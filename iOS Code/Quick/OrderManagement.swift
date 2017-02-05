//
//  OrderManagement.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import Foundation

class OrderManagement: NSObject {
    static let sharedInstance = OrderManagement()
    override fileprivate init() {}

    var placedOrders = [OrderData]()
    var claimedOrders = [OrderData]()
    
    func placedNewOrder(newOrder: OrderData) {
        placedOrders.append(newOrder)
    }
    
    func claimedNewOrder(newOrder: OrderData) {
        claimedOrders.append(newOrder)
    }
    
}
