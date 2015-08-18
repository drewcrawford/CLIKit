//
//  LegalTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import CLIKit

class LegalTestsTests : XCTestCase {
    /*verify that the legal cmd is installed by default */
    func testMeta() {
        let meta = MetaCommand(name: "LegalTests", subcommands: [])
        let _ = try! meta.parse(["legal"])
    }
    
    func testLegal() {
        let legal = LegalCommand()
        let result = legal.getNoticeText()
        XCTAssert(result.characters.count > 5)
        
    }
}