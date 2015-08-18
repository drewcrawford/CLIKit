//
//  CJDerivedTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/14/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
import XCTest
@testable import CLIKit

final class GitLabSetToken: Command {
    var name : String { get { return "gitLabSetToken" } }
    var parser : CLIKit.Parser {
        get {
            let option = CLIKit.SecureOption(longName: "token", help:"no",value_for_unit_testing: "mytoken")
            return CLIKit.CommandParser(name: "GitLabSetToken", options:[option], help: "whatever")
        }
    }
    func command(parseResult: ParseResult) {
    }
}


class CJDerivedTests: XCTestCase {
    func testGitLabParse() {
        let gitLabToken = SecureOption(longName: "token", help:"no",defaultValue: nil, required: true, value_for_unit_testing: "MyToken")
        let storeTokenParser = CLIKit.CommandParser(name: "storeGitLabToken", options: [gitLabToken], help: "whatever")
        let _p = try! storeTokenParser.parse(["storeGitLabToken","--token","mytoken"])
        XCTAssert(_p["token"]! == "MyToken")
    }
    
    func testGitLabCommand() {
        let storeTokenParser = GitLabSetToken().parser
        let _p = try! storeTokenParser.parse(["GitLabSetToken","--token","mytoken"])
        XCTAssert(_p["token"]! == "mytoken")
    }
    
    func testLegalAndPriority() {
        let legalCommand = LegalCommand()
        let gitLabCommand = GitLabSetToken()
        let metacommand = MetaCommand(name: "CaveJohnson", subcommands: [legalCommand, gitLabCommand] )
        let _ = try! metacommand.parse(["legal"])
        //let priorityParser = CLIKit.PriorityParser(name: "cavejohnson", subparsers: [GitLabSetToken().parser, LegalCommand(legalText: "My legal text")])
        //let result = priorityParser
    }
}