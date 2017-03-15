//
// Created by Chakkra CHAK on 14/03/2017.
// Copyright (c) 2017 Chakkra CHAK. All rights reserved.
//

import Foundation

public class BaseAccessComponent {
    public var coverage:String
    public var token:String

    public init(token:String, coverage: String) {
        self.token = token
        self.coverage = coverage
    }
}