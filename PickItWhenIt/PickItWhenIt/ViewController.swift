//
//  ViewController.swift
//  PickItWhenIt
//
//  Created by Chakkra CHAK on 09/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import UIKit
import NavitiaAccess

class StopPointViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func updateWith(label:String) {
        self.label.text = label
    }
}

extension ViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let token:String = "9e304161-bb97-4210-b13d-c71eaf58961c"
    let coverage:String = "fr-idf"
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "StopPointCellIdentifier"
    let searchController = UISearchController(searchResultsController: nil)
    
    var stopSchedules:[String] = ["TATA", "TOTO", "TUTU"]
    var autocompleteResults:[String] = ["BLA", "BLA"]

    func loadDataInTable() {
        StopSchedulesBuilder(token: self.token, coverage: self.coverage)
            .withDistance(1000)
            .withCount(30)
            .build(callback: {
                (stopSchedules:[String]) -> Void in
                self.stopSchedules = stopSchedules
                
                self.tableView.reloadData()
            })
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.autocompleteResults = ["HOP", "LA"]
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loadDataInTable()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != "") {
            return autocompleteResults.count
        }
        
        return stopSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StopPointViewCell

        if (searchController.isActive && searchController.searchBar.text != "") {
            cell.updateWith(label:autocompleteResults[indexPath.row])
        } else {
            cell.updateWith(label:stopSchedules[indexPath.row])
        }
        
        return cell
    }
}

