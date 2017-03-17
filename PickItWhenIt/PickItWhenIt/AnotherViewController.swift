//
//  SearchSchedulesViewController.swift
//  PickItWhenIt
//
//  Created by Chakkra CHAK on 17/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import UIKit
import NavitiaAccess

class AnotherViewController: UIViewController {
    let searchSchedulesViewController = SearchSchedulesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchSchedulesViewController.launchView(into: self)
    }
}
