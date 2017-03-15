//
//  ViewController.swift
//  PickItWhenIt
//
//  Created by Chakkra CHAK on 09/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import UIKit
import NavitiaAccess

extension ViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        self.searchBarWithAutocomplete!.retrieveAutocompletionResults(searchText: searchController.searchBar.text!)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let token:String = "9e304161-bb97-4210-b13d-c71eaf58961c"
    let coverage:String = "fr-idf"

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "StopPointCellIdentifier"
    var searchBarWithAutocomplete:SearchBarWithAutocomplete? = nil

    var stopSchedules:[StopSchedulesResponse.StopSchedules] = []

    func loadDataInTable(lon:String, lat:String) {
        StopSchedulesBuilder(token: self.token, coverage: self.coverage)
            .withDistance(300)
            .withCount(30)
            .build(lon: lon, lat: lat, callback: {
                (stopSchedules:[StopSchedulesResponse.StopSchedules]) -> Void in
                self.stopSchedules = stopSchedules
                self.tableView.reloadData()
                self.searchBarWithAutocomplete!.searchController.isActive = false
            })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarWithAutocomplete = SearchBarWithAutocomplete(token: self.token, coverage: self.coverage, searchResultsUpdater: self, tableView: self.tableView)

        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchBarWithAutocomplete!.searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            return self.searchBarWithAutocomplete!.autocompleteResults.count
        }

        return stopSchedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StopPointViewCell

        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            cell.updateWith(autocompleteResult: self.searchBarWithAutocomplete!.autocompleteResults[indexPath.row])
        } else {
            cell.updateWith(stopSchedule: stopSchedules[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            let currentAutocompleteResult = self.searchBarWithAutocomplete!.autocompleteResults[indexPath.row]
            print(currentAutocompleteResult.name)
            loadDataInTable(lon: currentAutocompleteResult.stopArea.coord.lon, lat:currentAutocompleteResult.stopArea.coord.lat)
        }
    }
}

