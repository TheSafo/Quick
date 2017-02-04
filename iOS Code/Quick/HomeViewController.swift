//
//  ViewController.swift
//  Quick
//
//  Created by Jake Saferstein on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View Config
        view.backgroundColor = .red
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Add Subviews
        
        //Constraints
    }


    //MARK: - Table View Stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}

