//
//  OrderDetailsViewController.swift
//  Quick
//
//  Created by David Branse on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    var order: OrderData
    
//    var description: String
//    var orderDetails: String
//    var requesterID: String
//    var price: Double
//    var pickUpLocation: CLLocation
//    var dropOffLocation: CLLocation
//    
//    var claimed: Bool
//    var orderID: String?
//    var acceptorID: String?
    
    let blurbLbl = UILabel()
    let detailsLbl = UILabel()
    
    let requesterNameLbl = UILabel()
    
    let priceLbl = UILabel()

    let directionsLinkLbl = UILabel()
    
    init(order: OrderData) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.addSubview(blurbLbl)
        view.addSubview(detailsLbl)
        view.addSubview(requesterNameLbl)
        view.addSubview(priceLbl)
        view.addSubview(directionsLinkLbl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
