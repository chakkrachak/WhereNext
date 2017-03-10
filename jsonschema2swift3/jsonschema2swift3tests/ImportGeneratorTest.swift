//
//  ImportGeneratorTest.swift
//  jsonschema2swift3
//
//  Created by Chakkra CHAK on 10/03/2017.
//  Copyright © 2017 Kisio Digital. All rights reserved.
//

import XCTest

class ImportGeneratorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let importGenerator:ImportGenerator = ImportGenerator()
        
        XCTAssertTrue(importGenerator.generateCode() == "import Foundation\n")
    }
}
