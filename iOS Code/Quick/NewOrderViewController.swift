//
//  NewOrderViewController.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit


class NewOrderViewController: UIViewController {
    
    let blurbInput = UITextField()
    let priceInput = UITextField()
    let descInput = UITextView()
    let submitBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        //Config
        descInput.isEditable = true
        
//        blurbInput.backgroundColor = .purple
//        priceInput.backgroundColor = .green
        blurbInput.borderStyle = .roundedRect
        blurbInput.placeholder = "Blurb"
        blurbInput.returnKeyType = .done
        
        priceInput.borderStyle = .roundedRect
        priceInput.placeholder = "Delivery Charge"
        priceInput.keyboardType = .numbersAndPunctuation
        priceInput.returnKeyType = .done

        let 💸lbl = UILabel()
        💸lbl.text = "$"
        💸lbl.textColor = .green
        💸lbl.textAlignment = .right
        
        submitBtn.backgroundColor = .purple
        submitBtn.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)

        //Add
        view.addSubview(blurbInput)
        view.addSubview(priceInput)
        view.addSubview(descInput)
        view.addSubview(💸lbl)
        view.addSubview(submitBtn)
        
        //Constrain
        blurbInput.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(64+20)//nav bar height
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(50)
        }
        priceInput.snp.makeConstraints { (make) in
            make.top.equalTo(blurbInput.snp.bottom).offset(20)
            make.centerX.height.equalTo(blurbInput)
            make.width.equalTo(blurbInput)
        }
        💸lbl.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(priceInput)
            make.right.equalTo(priceInput.snp.left)
            make.width.equalTo(20)
        }
        descInput.snp.makeConstraints { (make) in
            make.top.equalTo(priceInput.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbInput)
            make.height.equalTo(300)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descInput.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(50)
        }
        
//        blurbInput.layer.borderWidth = 1; blurbInput.layer.borderColor = UIColor.red.cgColor
//        priceInput.layer.borderWidth = 1; priceInput.layer.borderColor = UIColor.blue.cgColor
        descInput.layer.borderWidth = 1; descInput.layer.borderColor = UIColor.green.cgColor

    }
    
    func submitPressed() {
        print("Submit pressed")
        
        let order = OrderData(description: blurbInput.text!, orderDetails: descInput.text, requestID: UUID().uuidString, price: 8, pickUpLocation: CurrentLocation.sharedInstance.currentLocation!, dropOffLocation: CurrentLocation.sharedInstance.currentLocation!)
        
        ServerAPI.sharedInstance.uploadOrder(order: order)
    }
    
    func checkIfFormIsValid() -> Bool {
        //TODO: implement
        return true
    }

}

extension NewOrderViewController : UITextFieldDelegate, UITextViewDelegate {
    
    //Text View
    func textViewDidEndEditing(_ textView: UITextView) {
        if checkIfFormIsValid() {
            submitBtn.isEnabled = true
        }
    }
    
    //Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if checkIfFormIsValid() {
            submitBtn.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
