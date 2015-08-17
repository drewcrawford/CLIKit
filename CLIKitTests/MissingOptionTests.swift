//
//  MissingOptionTests.swift
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
import XCTest
@testable import CLIKit

private final class MissingOptionCmd : CLIKit.EasyCommand {
    
    private struct MyParseResult : CLIKit.ParseResult {
        var whatever: String! = nil
        private mutating func setValue(value: Any?, forKey key: String) {
            switch(key) {
            case "whatever":
                whatever = value as! String
            default:
                preconditionFailure("Unknown key \(key)")
            }
        }
        private static func typeForKey(key: String) -> Any.Type {
            switch(key) {
            case "whatever":
                return String.self
            default:
                preconditionFailure("Unknown key \(key)")
            }
        }
    }
    typealias ParseResultType = MyParseResult
    private func command(parseResult: ParseResult) {
        abort()
    }
    let name = "createIdentity"
    let options : [Option] = [DefaultOption(longName: "whatever", help: "whatever"),DefaultOption(longName: "whatever2", help: "whatever2")]
    let shortHelp = "DontCare"
}

class MissingOptionTests : XCTestCase {
    func testMissingOption() {
        let metacommand = MetaCommand(name: "whatever", subcommands: [MissingOptionCmd()])
        do {
            try metacommand.parse(["createIdentity","--whatever","something"])
        }
        catch { print("\(error)") }

    }
}