//
//  ViewController.swift
//  Quick
//
//  Created by Jake Saferstein on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = HomeViewController()
    
    
    
    let tableView = UITableView()
    var claimedOrders: [OrderData] {
        get {
            return OrderManagement.sharedInstance.claimedOrders
        }
        set {
             OrderManagement.sharedInstance.claimedOrders = newValue
        }
    }
    var activeOrders: [OrderData] {
        get {
            return OrderManagement.sharedInstance.placedOrders
        }
        set {
            OrderManagement.sharedInstance.placedOrders = newValue
        }
    }
    var availableOrders: [OrderData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Orders"
        
        //View Config
        view.backgroundColor = .red
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "ordercell")
        
        //Add Subviews
        view.addSubview(tableView)
        
        //Constraints
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

    }
    
    func refreshTable() {
        ServerAPI.sharedInstance.getClosestOrders()
//        if let availableOrders = ServerAPI.sharedInstance.getClosestOrders() {
//            self.availableOrders = availableOrders
//        }
        tableView.reloadData()
    }


    //MARK: - Table View Stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Claimed"
        case 1:
            return "Active"
        case 2:
            return "Available"
        default:
            return "le monke"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return claimedOrders.count
        case 1:
            return activeOrders.count
        case 2:
            return availableOrders.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
            
            cell.setOrderData(claimedOrders[indexPath.row])
            
//            if claimedOrders[indexPath.row].claimed {
                cell.backgroundColor = .cyan
//            }
//            else {
//                cell.backgroundColor = .raceOrange()
//            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
            
            cell.setOrderData(activeOrders[indexPath.row])
            
            if activeOrders[indexPath.row].claimed {
                cell.backgroundColor = .green
            }
            else {
                cell.backgroundColor = .raceOrange()
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
            
            cell.setOrderData(availableOrders[indexPath.row])
            
            cell.backgroundColor = .white
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var nextVC = UIViewController()

        switch indexPath.section {
        case 0:
            nextVC = ConfirmPickedUpViewController(order: self.claimedOrders[indexPath.row])
        case 1:
            nextVC = ConfirmDeliveredViewController(order: self.activeOrders[indexPath.row])
        case 2:
            nextVC = OrderDetailsViewController(order: self.availableOrders[indexPath.row])
        default:
            break
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - Buttons
    
    func profButtonPressed() {
        print("Prof button pressed")
    }
    
    func orderButtonPressed() {
        print("Order button pressed")
        
        let nextVC = NewOrderViewController()
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension String {
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
