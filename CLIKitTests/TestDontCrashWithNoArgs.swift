//
//  TestDontCrashWithNoArgs.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
// in the LICENSE file.

import Foundation
@testable import CLIKit
import XCTest


private final class DontCrashWithNoArgs : CLIKit.EasyCommand {
    private func command(parseResult: ParseResult) {
        abort()
    }
    let name = "createIdentity"
    let options : [Option] = []
    let shortHelp = "DontCare"
}


class DontCrashWithNoArgsTests : XCTestCase {
    func testDontCrashWithNoArgs(){
        let metacommand = MetaCommand(name: "whatever", subcommands: [DontCrashWithNoArgs()])
        do {
            try metacommand.parse([])
        }
        catch { /* */ }
    }
    
    func testUsage() {
        let metacommand = MetaCommand(name: "whatever", subcommands: [DontCrashWithNoArgs()])
        let str = try metacommand.longHelp
    }
}
