//
//  OptionalArguments.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/28/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import CLIKit

class OptionalArgumentsTests : XCTestCase {
    func testOptional() {
        let o = DefaultOption(longName: "myname", help: "myhelp", required: false)
        let parser = DefaultParser(name: "myparser", options: [o])
        try! parser.parse([])
    }
    
    func testOptionalHelp() {
        let o = DefaultOption(longName: "myname", help: "myhelp", required: false)
        let help = o.longHelp
        XCTAssert(help == "myname (optional): myhelp")
    }
}