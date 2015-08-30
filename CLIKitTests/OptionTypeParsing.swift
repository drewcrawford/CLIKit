//
//  OptionTypeParsing.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/30/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import CLIKit

class OptionTypeParsingTests : XCTestCase {
    func testIntParse() {
        let option = DefaultOption(longName: "int", help: "Some int", type: OptionType.IntOption(0))
        var parseResult = ParseResult()
        var args = ["--int","2"]
        try! option.parse(&args, accumulateResult: &parseResult)
        XCTAssert(parseResult["int"].intValue == 2)
    }
}