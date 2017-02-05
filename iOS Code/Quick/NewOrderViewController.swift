//
//  NewOrderViewController.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit
import CoreLocation
import LocationPicker

class NewOrderViewController: UIViewController {
    
    let blurbInput = UITextField()
    let priceInput = UITextField()
    let descInput = UITextView()
    let submitBtn = UIButton()
    let pickupLocBtn = UIButton()
    
    let locPicker = LocationPickerViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Touch stuff
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        
        //Config
        view.backgroundColor = .white
        
        descInput.isEditable = true
        descInput.delegate = self
        
        blurbInput.borderStyle = .roundedRect
        blurbInput.placeholder = "Blurb"
        blurbInput.returnKeyType = .done
        blurbInput.delegate = self
        
        priceInput.borderStyle = .roundedRect
        priceInput.placeholder = "Delivery Charge"
        priceInput.keyboardType = .numbersAndPunctuation
        priceInput.returnKeyType = .done
        priceInput.delegate = self
        
        pickupLocBtn.backgroundColor = .orange
        pickupLocBtn.setTitle("📍Pickup location", for: .normal)
        pickupLocBtn.addTarget(self, action: #selector(pickupLocBtnPressed), for: .touchUpInside)
        
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
        view.addSubview(pickupLocBtn)
        
        //Constrain
        blurbInput.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(64)//nav bar height
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
            make.height.equalTo(150)
        }
        pickupLocBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descInput.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(50)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pickupLocBtn.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(50)
        }

        
        setUpPicker()

    }
    
    func setUpPicker() {
//        if let curLoc = CurrentLocation.sharedInstance.currentLocation {
//            locPicker.location = Location(name: "Current Location", location: <#T##CLLocation?#>, placemark: <#T##CLPlacemark#>)
//        }
        locPicker.completion = { location in
            print("LOCATION: \(location?.name)")
        }
        
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

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.resignFirstResponder()
    }
    
    func pickupLocBtnPressed() {
        self.navigationController?.pushViewController(locPicker, animated: true)
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
        return false
    }
}
