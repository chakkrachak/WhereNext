//
//  SearchSchedulesViewController.swift
//  NavitiaAccess
//
//  Created by Chakkra CHAK on 17/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import UIKit

extension SearchSchedulesViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        self.searchBarWithAutocomplete!.retrieveAutocompletionResults(searchText: searchController.searchBar.text!)
    }
}

public class SearchSchedulesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let token:String = "9e304161-bb97-4210-b13d-c71eaf58961c"
    let coverage:String = "fr-idf"
    var stopSchedules:[StopSchedulesResponse.StopSchedules] = []
    var tableView: UITableView!
    var searchBarWithAutocomplete:SearchBarWithAutocomplete? = nil
    let cellIdentifier = "StopPointCellIdentifier"

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func launchView(into targetViewController: UIViewController) {

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.searchBarWithAutocomplete = SearchBarWithAutocomplete(token: self.token, coverage: self.coverage, searchResultsUpdater: self, tableView: self.tableView)

        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchBarWithAutocomplete!.searchController.searchBar

        loadDataInTable(lon: "2.373686", lat: "48.845796")

        targetViewController.view.addSubview(self.tableView)
    }

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

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            let currentAutocompleteResult = self.searchBarWithAutocomplete!.autocompleteResults[indexPath.row]
            print(currentAutocompleteResult.name)
            loadDataInTable(lon: currentAutocompleteResult.stopArea.coord.lon, lat:currentAutocompleteResult.stopArea.coord.lat)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            return self.searchBarWithAutocomplete!.autocompleteResults.count
        }

        return stopSchedules.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)

        if self.searchBarWithAutocomplete!.isInAutocompletion() {
            cell.textLabel!.text = self.searchBarWithAutocomplete!.autocompleteResults[indexPath.row].stopArea.label
        } else {
            cell.textLabel!.text = self.stopSchedules[indexPath.row].stopPoint.label
        }

        return cell
    }

}
