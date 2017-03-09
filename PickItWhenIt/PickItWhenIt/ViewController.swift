//
//  ViewController.swift
//  PickItWhenIt
//
//  Created by Chakkra CHAK on 09/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import UIKit

class StopPointViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func updateWith(label:String) {
        self.label.text = label
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let token:String = "9e304161-bb97-4210-b13d-c71eaf58961c"
    let coverage:String = "fr-idf"
    
    let cellIdentifier = "StopPointCellIdentifier"
    
    var stopSchedules:[String] = ["TATA", "TOTO", "TUTU"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StopPointViewCell
        
        cell.updateWith(label:stopSchedules[indexPath.row])
        
        return cell
    }
}

