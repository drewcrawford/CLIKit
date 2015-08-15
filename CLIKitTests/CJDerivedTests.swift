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

struct GitLabTokenResult : CLIKit.ParseResult {
    var token: String! = nil
    mutating func setValue(value: Any?, forKey key: String) {
        switch(key) {
        case "token":
            self.token = value as! String?
        default:
            preconditionFailure("Can't set value for key \(key)")
        }
    }
    static func typeForKey(key: String) -> Any.Type {
        switch(key) {
        case "token":
            return String.self
        default:
            preconditionFailure("Can't set value for key \(key)")
        }
    }
}

final class GitLabSetToken: Command {
    var name : String { get { return "gitLabSetToken" } }
    var parser : CLIKit.Parser {
        get {
            let option = CLIKit.SecureOption(longName: "token", value_for_unit_testing: "mytoken")
            return CLIKit.CommandParser<GitLabTokenResult>(name: "GitLabSetToken", options:[option])
        }
    }
    func command<T : ParseResult>(parseResult: T) {
        let result = parseResult as! GitLabTokenResult
    }
}


class CJDerivedTests: XCTestCase {
    func testGitLabParse() {
        let gitLabToken = SecureOption(longName: "token", defaultValue: nil, required: true, value_for_unit_testing: "MyToken")
        let storeTokenParser = CLIKit.CommandParser<GitLabTokenResult>(name: "storeGitLabToken", options: [gitLabToken])
        let _p : GitLabTokenResult = try! storeTokenParser.parse(["storeGitLabToken","--token","mytoken"]) as! GitLabTokenResult
        XCTAssert(_p.token == "MyToken")
    }
    
    func testGitLabCommand() {
        let storeTokenParser = GitLabSetToken().parser
        let _p : GitLabTokenResult = try! storeTokenParser.parse(["GitLabSetToken","--token","mytoken"]) as! GitLabTokenResult
        XCTAssert(_p.token == "mytoken", "\(_p.token)")
    }
    
    func testLegalAndPriority() {
        let legalCommand = LegalCommand(legalText: "My legal text")
        let gitLabCommand = GitLabSetToken()
        let metacommand = MetaCommand(name: "CaveJohnson", subcommands: [legalCommand, gitLabCommand] as! [Command])
        let _ = try! metacommand.parse(["legal"])
        //let priorityParser = CLIKit.PriorityParser(name: "cavejohnson", subparsers: [GitLabSetToken().parser, LegalCommand(legalText: "My legal text")])
        //let result = priorityParser
    }
}