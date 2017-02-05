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
    var availableOrders: [OrderData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderTableViewCell
        
        cell.setOrderData(availableOrders[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nextVC = OrderDetailsViewController(order: self.availableOrders[indexPath.row])
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
