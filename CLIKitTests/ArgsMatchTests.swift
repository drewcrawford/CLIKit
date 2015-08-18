//
//  ArgsMatchTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/17/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
// in the LICENSE file.

import Foundation
private let identityOption = CLIKit.DefaultOption(longName: "identityFile", help: "Path to the location file.  For security reasons, it must have permissions 0600 (only user-readable)")
private let fisaFileOption = CLIKit.DefaultOption(longName: "fisaFile", help: "Path to the FISA file to be operated on.")


private final class CreateFISACommand : CLIKit.EasyCommand {
    private let options : [Option] = [identityOption, fisaFileOption, DefaultOption(longName: "identityDescription", help: "The description to use for your identity in the new FISA file.")]
    private let shortHelp = "Create a new identity and save it to the specified file."
    let name = "createFISA"
    private func command(parseResult: ParseResult) {
        abort()
    }
}

import XCTest
@testable import CLIKit

class ArgsMatchTestsTests : XCTestCase {
    func testArgsMatch() {
        let metaParser = MetaCommand(name: "ArgsMatchTests", subcommands: [CreateFISACommand()])
        let result = try! metaParser.parse(["createFISA","--identityDescription","shadowfax is the best computer ever",
            "--fisaFile", "/tmp/test.fisa",
            "--identityFile","/tmp/identity.fisa"])
        XCTAssert(result["identityFile"]! == "/tmp/identity.fisa")
    }
}
