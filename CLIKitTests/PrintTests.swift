//
//  PrintTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/30/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import CLIKit

class PrintTests : XCTestCase {
    func testPrintStdError() {
        printErr("Do you get this print?")
    }
}