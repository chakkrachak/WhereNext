//
// Created by Chakkra CHAK on 10/03/2017.
// Copyright (c) 2017 Kisio Digital. All rights reserved.
//

import Foundation
import XCTest

class Assert {
    class AssertionString {
        let stringToTest:String

        init(_ stringToTest:String) {
            self.stringToTest = stringToTest
        }

        func isEqualTo(_ expectedString:String) {
            XCTAssertTrue(self.stringToTest == expectedString, formatAssertionError(actual: self.stringToTest, expected: expectedString))
        }

        private func formatAssertionError(actual: String, expected: String) -> String {
            var result:[String] = []

            result.append("####### ACTUAL #######")
            result.append(actual)
            result.append("###### EXPECTED ######")
            result.append(expected)
            result.append("######################")

            return result.joined(separator: "\n")
        }
    }

    static func that(_ stringToTest:String) -> AssertionString {
        return AssertionString(stringToTest)
    }
}