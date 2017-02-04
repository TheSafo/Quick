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
    let descriptionLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Configure Views
        distanceLbl.textAlignment = .right
        
        //Add Subviews
        contentView.addSubview(distanceLbl)
        contentView.addSubview(descriptionLbl)
        
        //Constraints
        distanceLbl.snp.makeConstraints { (make) in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
            make.right.bottom.equalTo(contentView).offset(-2.5)
            make.height.equalTo(30)
        }
        
        
        descriptionLbl.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView)
            make.right.equalTo(distanceLbl.snp.left)
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
        
        let str = String(format: "%.0f m", data.getDistanceToPickUp())
        distanceLbl.text = str
        
        descriptionLbl.text = data.description
        //        placeLbl.text = data.destName
    }

}
