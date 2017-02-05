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
    
    func placedOrderClaimed(updatedOrder: OrderData) {
        var i = 0
        for (index,order) in placedOrders.enumerated() {
            if order.orderID == updatedOrder.orderID {
                i = index
                break;
            }
        }
        placedOrders[i].claimed = true;
        placedOrders[i].acceptorID = updatedOrder.acceptorID;
        placedOrders[i].pickUpName = updatedOrder.pickUpName;
        placedOrders[i].pickUpNumber = updatedOrder.pickUpNumber;
    }
}
