//
//  ArgsMatchTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/17/15.
//  CLIKit © 2016 Drew Crawford
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
import Darwin

private let identityOption = CLIKit.DefaultOption(longName: "identityFile", help: "Path to the location file.  For security reasons, it must have permissions 0600 (only user-readable)")
private let fisaFileOption = CLIKit.DefaultOption(longName: "fisaFile", help: "Path to the FISA file to be operated on.")


private final class CreateFISACommand : CLIKit.EasyCommand {
    fileprivate let options : [Option] = [identityOption, fisaFileOption, DefaultOption(longName: "identityDescription", help: "The description to use for your identity in the new FISA file.")]
    fileprivate let shortHelp = "Create a new identity and save it to the specified file."
    let name = "createFISA"
    fileprivate func command(_ parseResult: ParseResult) {
        abort()
    }
}

import CarolineCore
@testable import CLIKit

class ArgsMatchTestsTests : CarolineTest {
    func test() {
        let metaParser = MetaCommand(name: "ArgsMatchTests", subcommands: [CreateFISACommand()])
        let result = try! metaParser.parse(["createFISA","--identityDescription","shadowfax is the best computer ever",
            "--fisaFile", "/tmp/test.fisa",
            "--identityFile","/tmp/identity.fisa"])
        self.assert(result["identityFile"] == "/tmp/identity.fisa")
    }
}
