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
        HomeViewController.sharedInstance.refreshTable()
    }
    
    func claimedNewOrder(newOrder: OrderData) {
        claimedOrders.append(newOrder)
        HomeViewController.sharedInstance.refreshTable()
    }
    
    func placedOrderClaimed(orderID: Int, acceptorID: String, pickUpName: String, pickUpNumber: String) {
        var i = 0
        for (index,order) in placedOrders.enumerated() {
            if order.orderID == orderID {
                i = index
                break;
            }
        }
        placedOrders[i].claimed = true;
        placedOrders[i].acceptorID = acceptorID
        placedOrders[i].pickUpName = pickUpName
        placedOrders[i].pickUpNumber = pickUpNumber
        
        HomeViewController.sharedInstance.refreshTable()
    }
    
    func completedDelivery(completedOrder: OrderData) {
        for (index,order) in claimedOrders.enumerated() {
            if order.orderID == completedOrder.orderID {
                claimedOrders.remove(at: index)
                break;
            }
        }
        HomeViewController.sharedInstance.tableView.reloadData()
    }
    
    func receivedDelivery(receivedOrder: OrderData) {
        for (index,order) in placedOrders.enumerated() {
            if order.orderID == receivedOrder.orderID {
                placedOrders.remove(at: index)
                break;
            }
        }
        HomeViewController.sharedInstance.tableView.reloadData()
    }
}
