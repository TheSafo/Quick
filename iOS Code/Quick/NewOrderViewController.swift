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
    let submitBtn = UIButton(type: .system)
    let pickupLocBtn = UIButton(type: .system)
    let dropoffLocBtn = UIButton(type: .system)

    let locPicker = LocationPickerViewController()
    
    var pickupLoc: CLLocation? = nil
    var dropoffLoc: CLLocation? = nil
    
    var pickingUp = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.tintColor = .raceRed()
        
        self.title = "Order Form"
        
        //Touch stuff
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        
        //Config
        view.backgroundColor = .raceRed()
        
        descInput.isEditable = true
        descInput.delegate = self
        descInput.backgroundColor = .white//UIColor(colorLiteralRed: 255.0/255.0, green: 20.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        descInput.layer.borderColor = UIColor.lightGray.cgColor
        descInput.layer.borderWidth = 5
        descInput.layer.cornerRadius = 8
        
//        blurbInput.borderStyle = .roundedRect
        blurbInput.placeholder = "  Short Description"
        blurbInput.returnKeyType = .done
        blurbInput.delegate = self
        blurbInput.backgroundColor = .white//UIColor(colorLiteralRed: 255.0/255.0, green: 20.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        blurbInput.layer.borderColor = UIColor.lightGray.cgColor
        blurbInput.layer.borderWidth = 5
        blurbInput.layer.cornerRadius = 8

//        priceInput.borderStyle = .roundedRect
        priceInput.placeholder = "  Delivery Charge"
        priceInput.keyboardType = .numbersAndPunctuation
        priceInput.returnKeyType = .done
        priceInput.delegate = self
        priceInput.backgroundColor = .white//UIColor(colorLiteralRed: 255.0/255.0, green: 20.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        priceInput.layer.borderColor = UIColor.lightGray.cgColor
        priceInput.layer.borderWidth = 5
        priceInput.layer.cornerRadius = 8

        pickupLocBtn.backgroundColor = .white
        pickupLocBtn.layer.borderColor = UIColor.lightGray.cgColor
        pickupLocBtn.layer.borderWidth = 5
        pickupLocBtn.layer.cornerRadius = 8
        pickupLocBtn.setTitleColor(.black, for: .normal)
        pickupLocBtn.setTitle("🚚 Pickup location", for: .normal)
        pickupLocBtn.titleLabel?.textAlignment = .center
        pickupLocBtn.addTarget(self, action: #selector(pickupLocBtnPressed), for: .touchUpInside)
        
        
        dropoffLocBtn.backgroundColor = .white
        dropoffLocBtn.layer.borderColor = UIColor.lightGray.cgColor
        dropoffLocBtn.layer.borderWidth = 5
        dropoffLocBtn.layer.cornerRadius = 8
        dropoffLocBtn.setTitleColor(.black, for: .normal)
        dropoffLocBtn.setTitle("📍Dropoff location", for: .normal)
        dropoffLocBtn.titleLabel?.textAlignment = .center
        dropoffLocBtn.addTarget(self, action: #selector(dropoffLocBtnPressed), for: .touchUpInside)
        
        let 💸lbl = UILabel()
        💸lbl.text = "$"
        💸lbl.textColor = .green
        💸lbl.textAlignment = .right
        
//        submitBtn.backgroundColor = .white
        submitBtn.layer.borderColor = UIColor.lightGray.cgColor
        submitBtn.layer.borderWidth = 5
        submitBtn.layer.cornerRadius = 8
        submitBtn.setTitleColor(.black, for: .normal)
        submitBtn.setTitle("Submit Order", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        submitBtn.isEnabled = false
        submitBtn.backgroundColor = .raceSilver()
        
        //Add
        view.addSubview(blurbInput)
        view.addSubview(priceInput)
        view.addSubview(descInput)
//        view.addSubview(💸lbl)
        view.addSubview(submitBtn)
        view.addSubview(pickupLocBtn)
        view.addSubview(dropoffLocBtn)

        
        //Constrain
        blurbInput.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)//nav bar height
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(50)
        }
        priceInput.snp.makeConstraints { (make) in
            make.top.equalTo(blurbInput.snp.bottom).offset(20)
            make.centerX.height.equalTo(blurbInput)
            make.width.equalTo(blurbInput)
        }
//        💸lbl.snp.makeConstraints { (make) in
//            make.height.centerY.equalTo(priceInput)
//            make.right.equalTo(priceInput.snp.left)
//            make.width.equalTo(20)
//        }
        descInput.snp.makeConstraints { (make) in
            make.top.equalTo(priceInput.snp.bottom).offset(20)
            make.centerX.width.equalTo(blurbInput)
            make.height.equalTo(150)
        }
        pickupLocBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descInput.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(35)
        }
        dropoffLocBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pickupLocBtn.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(35)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(dropoffLocBtn.snp.bottom).offset(20)
            make.width.centerX.equalTo(blurbInput)
            make.height.equalTo(50)
        }

        setUpPicker()
        
        for vw in view.subviews {

            if vw == submitBtn || vw == pickupLocBtn || vw == dropoffLocBtn {
                continue
//                bgView.backgroundColor = .white
            }
            
            let bgView = UIView()
            bgView.backgroundColor = .raceSilver()//UIColor(colorLiteralRed: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)//UIColor(colorLiteralRed: 255.0/255.0,  green: 122.0/255.0, blue: 28.0/255.0, alpha: 1.0)

            bgView.layer.cornerRadius = 8
            view.insertSubview(bgView, at: 0)
            bgView.snp.makeConstraints({ (make) in
                make.top.left.equalTo(vw).offset(-3)
                make.bottom.right.equalTo(vw).offset(3)
            })
        }
    }
    
    
    func setUpPicker() {
        locPicker.completion = { location in
            guard let loc = location else {
                return
            }
            
            if self.pickingUp {
                self.pickupLoc = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            }
            else {
                self.dropoffLoc = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            }
            
            if self.checkIfFormIsValid() {
                self.submitBtn.isEnabled = true
            }
            
            self.locPicker.location = nil
        }
        
    }
    
    func submitPressed() {
        print("Submit pressed")
        
        guard self.priceInput.text != nil, let price = Double(self.priceInput.text!.trimmingCharacters(in: .whitespaces)) else {
            print("Fix price input")
            return
        }
        
        let order = OrderData(description: blurbInput.text!, orderDetails: descInput.text, requestID: UUID().uuidString, price: price, pickUpLocation: pickupLoc!, dropOffLocation: dropoffLoc!)
        
        ServerAPI.sharedInstance.uploadOrder(order: order)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfFormIsValid() -> Bool {
        return (blurbInput.text != nil) && (descInput.text != nil) && (priceInput.text != nil) && (pickupLoc != nil) && (dropoffLoc != nil)
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.resignFirstResponder()
    }
    
    func pickupLocBtnPressed() {
        
        pickingUp = true
        
        self.navigationController?.pushViewController(locPicker, animated: true)
    }
    
    func dropoffLocBtnPressed() {
        
        pickingUp = false
        
        self.navigationController?.pushViewController(locPicker, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem?.tintColor = .raceRed()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.text = "  "
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if checkIfFormIsValid() {
            submitBtn.isEnabled = true
        }
        
        if textField.text == "  " || textField.text == " " {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
