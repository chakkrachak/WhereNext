//
//  ImportGenerator.swift
//  jsonschema2swift3
//
//  Created by Chakkra CHAK on 10/03/2017.
//  Copyright © 2017 Kisio Digital. All rights reserved.
//

import Foundation

class ImportGenerator {
    var imports:[String] = []

    init() {
        imports.append("Foundation")
        imports.append("Marshal")
    }

    func generateCode() -> String {
        return imports.map({"import \($0)\n"}).reduce("", +)
    }
}
