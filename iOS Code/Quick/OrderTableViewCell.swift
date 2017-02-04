//
//  OrderTableViewCell.swift
//  Quick
//
//  Created by Jake Saferstein on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit
import SnapKit


class OrderTableViewCell: UITableViewCell {
    
    let distanceLbl = UILabel()
    let senderLbl = UILabel()
    let placeLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Configure Views
        
        //Add Subviews
        contentView.addSubview(distanceLbl)
        contentView.addSubview(senderLbl)
        contentView.addSubview(placeLbl)
        
        //Constraints
        distanceLbl.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.right.bottom.equalTo(contentView)
        }
        
        senderLbl.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(contentView)
            make.right.equalTo(distanceLbl.snp.left)
            make.top.equalTo(distanceLbl)
        }
        
        placeLbl.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.bottom.equalTo(distanceLbl.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrderData(_ data: OrderData) {
        
//        distanceLbl.text = "\(data.getDistance())"
//        senderLbl.text = data.person
//        placeLbl.text = data.destName
    }

}
