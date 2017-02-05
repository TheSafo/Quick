//
//  ConfirmDeliveredViewController.swift
//  Quick
//
//  Created by Jake Saferstein on 2/5/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit

class ConfirmDeliveredViewController: UIViewController {

    var order: OrderData
    
    let blurbLbl = UILabel()
    let detailsLbl = UITextView()
    
    let delivererNumberLbl = UITextView()
    let delivererNameLbl = UILabel()
    
    let priceLbl = UILabel()
    let confirmBtn = UIButton(type: .system)
    
    init(order: OrderData) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order Details"
        
        view.backgroundColor = .raceRed()
        
        blurbLbl.text = order.description
        priceLbl.text = String(format: "$%.02f", order.price)
        detailsLbl.text = order.orderDetails
        delivererNameLbl.text = order.pickUpName
        delivererNumberLbl.text = order.pickUpNumber
        
        blurbLbl.textAlignment = .center
        priceLbl.textAlignment = .center
        delivererNameLbl.textAlignment = .center
        delivererNumberLbl.textAlignment = .center
        
        detailsLbl.textAlignment = .left
        detailsLbl.isScrollEnabled = true
        detailsLbl.isEditable = false
//        detailsLbl.numberOfLines = 0

        
        delivererNumberLbl.isEditable = false
        delivererNumberLbl.isSelectable = true
        delivererNumberLbl.dataDetectorTypes = .phoneNumber
        
        
        delivererNameLbl.text = order.pickUpName
        delivererNumberLbl.text = order.pickUpNumber

        confirmBtn.setTitle("I Received This Delivery", for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnPressed), for: .touchUpInside)
        
        
        view.addSubview(blurbLbl)
        view.addSubview(detailsLbl)
        view.addSubview(priceLbl)
        view.addSubview(delivererNameLbl)
        view.addSubview(delivererNumberLbl)
        view.addSubview(confirmBtn)

        
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
        delivererNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLbl.snp.bottom).offset(20)
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
            
            vw.clipsToBounds = true
            
            if vw == confirmBtn {
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
        print("ORDER DEALT WITH")
        OrderManagement.sharedInstance.receivedDelivery(receivedOrder: self.order)
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
