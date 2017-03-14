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

    func updateWith(autocompleteResult:AutoCompleteResponse.Places) {
        self.label.text = autocompleteResult.name
    }

    func updateWith(stopSchedule:StopSchedulesResponse.StopSchedules) {
        self.label.text = stopSchedule.stopPoint.label
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

    var stopSchedules:[StopSchedulesResponse.StopSchedules] = []
    var autocompleteResults:[AutoCompleteResponse.Places] = []
    
    func loadDataInTable(lon:String, lat:String) {
        StopSchedulesBuilder(token: self.token, coverage: self.coverage)
            .withDistance(1000)
            .withCount(30)
            .build(lon: lon, lat: lat, callback: {
                (stopSchedules:[StopSchedulesResponse.StopSchedules]) -> Void in
                self.stopSchedules = stopSchedules
                self.tableView.reloadData()
                self.searchController.isActive = false
            })
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if (searchText != "") {
            AutocompleteBuilder(token: self.token, coverage: self.coverage)
                    .withDistance(300)
                    .withCount(30)
                    .build(query: searchText, callback: {
                        (autocompleteResults: [AutoCompleteResponse.Places]) -> Void in
                        self.autocompleteResults = autocompleteResults
                        self.tableView.reloadData()
                    })
        } else {
            self.autocompleteResults = []
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func isInAutocompletion() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInAutocompletion() {
            return autocompleteResults.count
        }

        return stopSchedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StopPointViewCell

        if isInAutocompletion() {
            cell.updateWith(autocompleteResult: autocompleteResults[indexPath.row])
        } else {
            cell.updateWith(stopSchedule: stopSchedules[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInAutocompletion() {
            let currentAutocompleteResult = autocompleteResults[indexPath.row]
            print(currentAutocompleteResult.name)
            loadDataInTable(lon: currentAutocompleteResult.stopArea.coord.lon, lat:currentAutocompleteResult.stopArea.coord.lat)
        }
    }
}

