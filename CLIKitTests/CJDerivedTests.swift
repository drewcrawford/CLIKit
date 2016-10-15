//
//  CJDerivedTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/14/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  CLIKit © 2015 DrewCrawfordApps LLC
//
//  Unless explicitly acquired and licensed from Licensor under another
//  license, the contents of this file are subject to the Reciprocal Public
//  License ("RPL") Version 1.5, or subsequent versions as allowed by the RPL,
//  and You may not copy or use this file in either source code or executable
//  form, except in compliance with the terms and conditions of the RPL.
//  All software distributed under the RPL is provided strictly on an "AS
//  IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND
//  LICENSOR HEREBY DISCLAIMS ALL SUCH WARRANTIES, INCLUDING WITHOUT
//  LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE, QUIET ENJOYMENT, OR NON-INFRINGEMENT. See the RPL for specific
//  language governing rights and limitations under the RPL.

import XCTest
@testable import CLIKit

final class GitLabSetToken: Command {
    var name : String { get { return "gitLabSetToken" } }
    var parser : CLIKit.Parser {
        get {
            let option = CLIKit.SecureOption(longName: "token", help:"no",defaultValue: "mytoken")
            return CLIKit.CommandParser(name: "GitLabSetToken", options:[option], help: "whatever")
        }
    }
    func command(_ parseResult: ParseResult) {
    }
}


class CJDerivedTests: XCTestCase {
    func testGitLabParse() {
        let gitLabToken = SecureOption(longName: "token", help:"no",defaultValue: "MyToken", required: true)
        let storeTokenParser = CLIKit.CommandParser(name: "storeGitLabToken", options: [gitLabToken], help: "whatever")
        let _p = try! storeTokenParser.parse(["storeGitLabToken","--token","mytoken"])
        XCTAssert(_p["token"] == "MyToken")
    }
    
    func testGitLabCommand() {
        let storeTokenParser = GitLabSetToken().parser
        let _p = try! storeTokenParser.parse(["GitLabSetToken","--token","mytoken"])
        XCTAssert(_p["token"] == "mytoken")
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
