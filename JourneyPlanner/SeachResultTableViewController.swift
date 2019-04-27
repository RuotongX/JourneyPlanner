//
//  SeachResultTableViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class SeachResultTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func ReturnButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
