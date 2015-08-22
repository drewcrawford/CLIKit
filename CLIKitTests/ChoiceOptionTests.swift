//
//  ChoiceOptionTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/22/15.
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

import Foundation

import XCTest
@testable import CLIKit

class ChoiceOptionTests : XCTestCase {
    func testChoiceOption() {
        let option = ChoiceOption(longName: "mychoice", shortHelp: "pick one", choices: ["a","b","c"])
        var parseResult = ParseResult()
        var args = ["--mychoice","a"]
        try! option.parse(&args, accumulateResult: &parseResult)
        XCTAssert(parseResult["mychoice"]!.stringValue! == "a")
    }
    
    func testChoiceBadOption() {
        let option = ChoiceOption(longName: "mychoice", shortHelp: "pick one", choices: ["a","b","c"])
        var parseResult = ParseResult()
        var args = ["--mychoice","d"]
        do {
            try option.parse(&args, accumulateResult: &parseResult)
            XCTFail("Unexpected success")
        }
        catch ParseError.UnknownChoice { /* */ }
        catch { XCTFail("\(error)") }
    }
    
    func testChoiceNotRequired() {
        let option = ChoiceOption(longName: "mychoice", shortHelp: "pick one", choices: ["a","b","c"], defaultValue: "b")
        var parseResult = ParseResult()
        var args : [String] = []
        try! option.parse(&args, accumulateResult: &parseResult)
    }
    func testChoiceNotRequiredHelp() {
        let option = ChoiceOption(longName: "mychoice", shortHelp: "pick one", choices: ["a","b","c"],defaultValue: "b")
        let expectedLongHelp = "mychoice (optional): pick one\nValid choices are: a, b, c.\nThe default value is b."
        let expectedUsageHelp = "--mychoice [a|b|c]"
        XCTAssert(option.usageHelp == expectedUsageHelp)
        XCTAssert(option.longHelp == expectedLongHelp)
    }
    
    func testChoiceHelp() {
        let option = ChoiceOption(longName: "mychoice", shortHelp: "pick one", choices: ["a","b","c"])
        let expectedLongHelp = "mychoice: pick one\nValid choices are: a, b, c."
        let expectedUsageHelp = "--mychoice [a|b|c]"
        XCTAssert(option.usageHelp == expectedUsageHelp)
        XCTAssert(option.longHelp == expectedLongHelp)
    }
    
    
}
