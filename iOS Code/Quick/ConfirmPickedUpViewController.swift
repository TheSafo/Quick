//
//  ConfirmPickedUpViewController.swift
//  Quick
//
//  Created by Jake Saferstein on 2/5/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit

class ConfirmPickedUpViewController: UIViewController {

    //their name/number

    var order: OrderData
    
    let blurbLbl = UILabel()
    let detailsLbl = UITextView()
    
    let priceLbl = UILabel()
    
    let directionsLinkLbl = UILabel()
    
    let confirmBtn = UIButton(type: .system)
    
    let pickupBtn = UIButton(type: .system)
    let dropoffBtn = UIButton(type: .system)
    
    let ordererNumberLbl = UITextView()
    let ordererNameLbl = UILabel()
    
    init(order: OrderData) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem?.tintColor = .raceRed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.tintColor = .raceRed()

        self.title = "Claimed Order Details"
        
        view.backgroundColor = .raceRed()
        
        blurbLbl.text = order.description
        priceLbl.text = String(format: "$%.02f", order.price)
        detailsLbl.text = order.orderDetails
        ordererNameLbl.text = order.pickUpName
        ordererNumberLbl.text = order.pickUpNumber
        
//        detailsLbl.numberOfLines = 0
        
        blurbLbl.textAlignment = .center
        priceLbl.textAlignment = .center
//        detailsLbl.textAlignment = .center
        ordererNameLbl.textAlignment = .center
        ordererNumberLbl.textAlignment = .center
        
        
        detailsLbl.textAlignment = .left
        detailsLbl.isScrollEnabled = true
        detailsLbl.isEditable = false
        
        
        ordererNumberLbl.isEditable = false
//        ordererNumberLbl.isSelectable = true
//        ordererNumberLbl.isSelectable = false
        ordererNumberLbl.dataDetectorTypes = .phoneNumber
        
        ordererNameLbl.text = order.pickUpName
        ordererNumberLbl.text = order.pickUpNumber
        
        confirmBtn.setTitle("Complete This Delivery", for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnPressed), for: .touchUpInside)
        
        pickupBtn.setTitle("🚚 To Pickup", for: .normal)
        pickupBtn.setTitleColor(.black, for: .normal)
        pickupBtn.addTarget(self, action: #selector(pickupBtnPressed), for: .touchUpInside)
        
        dropoffBtn.setTitle("📍Pickup to Destination", for: .normal)
        dropoffBtn.setTitleColor(.black, for: .normal)
        dropoffBtn.addTarget(self, action: #selector(dropoffBtnPressed), for: .touchUpInside)
        
        
        view.addSubview(blurbLbl)
        view.addSubview(detailsLbl)
        view.addSubview(priceLbl)
        view.addSubview(directionsLinkLbl)
        view.addSubview(confirmBtn)
        view.addSubview(pickupBtn)
        view.addSubview(dropoffBtn)
        view.addSubview(ordererNameLbl)
        view.addSubview(ordererNumberLbl)
        
        blurbLbl.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(30)
        }
        priceLbl.snp.makeConstraints { (make) in
            make.top.equalTo(blurbLbl.snp.bottom).offset(20)
            make.centerX.equalTo(blurbLbl)
            make.width.equalTo(65)
            make.height.equalTo(30)
        }

        detailsLbl.snp.makeConstraints { (make) in
            make.top.equalTo(priceLbl.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbLbl)
            make.height.equalTo(150)
        }
        pickupBtn.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLbl.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbLbl)
            make.height.equalTo(30)
        }
        dropoffBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pickupBtn.snp.bottom).offset(20)
            make.centerX.width.equalTo(pickupBtn)
            make.height.equalTo(30)
        }
        ordererNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(dropoffBtn.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbLbl)
            make.height.equalTo(30)
        }
        ordererNumberLbl.snp.makeConstraints { (make) in
            make.top.equalTo(ordererNameLbl.snp.bottom).offset(20)
            make.centerX.width.equalTo(ordererNameLbl)
            make.height.equalTo(30)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(ordererNumberLbl.snp.bottom).offset(20)
            make.centerX.equalTo(detailsLbl)
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(60)
        }
        
        for vw in view.subviews {
            
            vw.clipsToBounds = true
            
            if vw == confirmBtn || vw == pickupBtn || vw == dropoffBtn {
                vw.backgroundColor = .raceSilver()
                vw.layer.borderColor = UIColor.lightGray.cgColor
                vw.layer.borderWidth = 5
                vw.layer.cornerRadius = 8
                
                if vw != confirmBtn {
                    vw.backgroundColor = .white
                }
                
                continue
            }
            
            vw.backgroundColor = .white
            vw.layer.borderColor = UIColor.lightGray.cgColor
            vw.layer.borderWidth = 5
            vw.layer.cornerRadius = 8
            
            let bgView = UIView()
            bgView.backgroundColor = .raceSilver()
            
            bgView.layer.cornerRadius = 8
            view.insertSubview(bgView, at: 0)
            bgView.snp.makeConstraints({ (make) in
                make.top.left.equalTo(vw).offset(-3)
                make.bottom.right.equalTo(vw).offset(3)
            })
        }
    }
    
    func confirmBtnPressed() {
        print("User completed order!")
        OrderManagement.sharedInstance.completedDelivery(completedOrder: self.order)

        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func pickupBtnPressed() {
        // Open and show coordinate
        let lat = order.pickUpLocation.coordinate.latitude
        let long = order.pickUpLocation.coordinate.longitude
        
        let url = "http://maps.apple.com/maps?daddr=\(lat),\(long)&q=Pickup+Location"
        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
    }
    
    func dropoffBtnPressed() {
        
        let lat = order.pickUpLocation.coordinate.latitude
        let long = order.pickUpLocation.coordinate.longitude
        
        let lat2 = order.dropOffLocation.coordinate.latitude
        let long2 = order.dropOffLocation.coordinate.longitude
        
        // Navigate from one coordinate to another
        let url = "http://maps.apple.com/maps?saddr=\(lat),\(long)&q=Pickup+Location&daddr=\(lat2),\(long2)&q=Dropoff+Location"
        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
    }
}
