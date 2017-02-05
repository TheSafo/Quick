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
    let detailsLbl = UILabel()
    
    let priceLbl = UILabel()
    
    let directionsLinkLbl = UILabel()
    
    let confirmBtn = UIButton()
    
    let pickupBtn = UIButton()
    let dropoffBtn = UIButton()
    
    let delivererNumberLbl = UITextView()
    let delivererNameLbl = UILabel()
    
    init(order: OrderData) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .raceRed()
        
        blurbLbl.text = order.description
        priceLbl.text = String(format: "$%.02f", order.price)
        detailsLbl.text = order.orderDetails
        delivererNameLbl.text = order.pickUpName
        delivererNumberLbl.text = order.pickUpNumber
        
        blurbLbl.textAlignment = .center
        priceLbl.textAlignment = .center
        detailsLbl.textAlignment = .center
        delivererNameLbl.textAlignment = .center
        delivererNumberLbl.textAlignment = .center
        
        delivererNumberLbl.isEditable = false
        delivererNumberLbl.dataDetectorTypes = .all
        
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
        view.addSubview(delivererNameLbl)
        view.addSubview(delivererNumberLbl)
        
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
        delivererNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(dropoffBtn.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbLbl)
            make.height.equalTo(30)
        }
        delivererNumberLbl.snp.makeConstraints { (make) in
            make.top.equalTo(delivererNameLbl.snp.bottom).offset(20)
            make.centerX.width.equalTo(delivererNameLbl)
            make.height.equalTo(30)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(delivererNumberLbl.snp.bottom).offset(20)
            make.centerX.equalTo(detailsLbl)
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(60)
        }
        
        for vw in view.subviews {
            
            if vw == confirmBtn || vw == pickupBtn || vw == dropoffBtn {
                vw.backgroundColor = .raceSilver()
                vw.layer.borderColor = UIColor.yellow.cgColor
                vw.layer.borderWidth = 4
                vw.layer.cornerRadius = 8
                
                continue
            }
            
            vw.backgroundColor = .white
            vw.layer.borderColor = UIColor.yellow.cgColor
            vw.layer.borderWidth = 4
            vw.layer.cornerRadius = 8
            
            let bgView = UIView()
            bgView.backgroundColor = .raceSilver()
            
            bgView.layer.cornerRadius = 8
            view.insertSubview(bgView, at: 0)
            bgView.snp.makeConstraints({ (make) in
                make.top.left.equalTo(vw).offset(-6)
                make.bottom.right.equalTo(vw).offset(6)
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
