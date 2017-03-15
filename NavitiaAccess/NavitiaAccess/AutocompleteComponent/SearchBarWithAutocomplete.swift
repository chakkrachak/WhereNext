//
//  SearchBarWithAutocomplete.swift
//  NavitiaAccess
//
//  Created by Chakkra CHAK on 13/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import Foundation
import UIKit

public class StopPointViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    public func updateWith(label:String) {
        self.label.text = label
    }

    public func updateWith(autocompleteResult:AutoCompleteResponse.Places) {
        self.label.text = autocompleteResult.name
    }

    public func updateWith(stopSchedule:StopSchedulesResponse.StopSchedules) {
        self.label.text = stopSchedule.stopPoint.label
    }
}

public class SearchBarWithAutocomplete : BaseAccessComponent {
    public let searchController = UISearchController(searchResultsController: nil)
    public var autocompleteResults:[AutoCompleteResponse.Places] = []
    var tableView:UITableView? = nil

    override public init(token:String, coverage: String) {
        super.init(token: token, coverage: coverage)
    }

    public init(token:String, coverage: String, searchResultsUpdater:UISearchResultsUpdating, tableView: UITableView) {
        self.searchController.searchResultsUpdater = searchResultsUpdater
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView = tableView

        super.init(token: token, coverage: coverage)
    }

    public func isInAutocompletion() -> Bool {
        return self.searchController.isActive && self.searchController.searchBar.text != ""
    }

    public func retrieveAutocompletionResults(searchText: String) {
        if (searchText != "") {
            AutocompleteBuilder(token: self.token, coverage: self.coverage)
                    .withDistance(300)
                    .withCount(30)
                    .build(query: searchText, callback: {
                        (currentAutocompleteResults: [AutoCompleteResponse.Places]) -> Void in
                        self.autocompleteResults.removeAll()
                        self.autocompleteResults.insert(contentsOf: currentAutocompleteResults, at: 0)
                        if (self.tableView != nil) {
                            self.tableView!.reloadData()
                        }
                    })
        } else {
            self.autocompleteResults.removeAll()
            if (self.tableView != nil) {
                self.tableView!.reloadData()
            }
        }
    }
}
