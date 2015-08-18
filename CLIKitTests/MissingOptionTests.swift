//
//  MissingOptionTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/17/15.
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

private final class MissingOptionCmd : CLIKit.EasyCommand {    
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