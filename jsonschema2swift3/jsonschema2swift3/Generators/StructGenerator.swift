//
// Created by Chakkra CHAK on 10/03/2017.
// Copyright (c) 2017 Kisio Digital. All rights reserved.
//

import Foundation

class StructGenerator {
    func generateCodeFrom(_ structDescriptor:StructDescriptor) -> String {
        var codeLines:[String] = []
        let importGenerator:ImportGenerator = ImportGenerator()

        codeLines.append(importGenerator.generateCode())
        codeLines.append("struct \(structDescriptor.name) {")
        codeLines.append("}")

        return codeLines.joined(separator: "\n")
    }
}