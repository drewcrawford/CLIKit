//
//  VersionCommandTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/20/15.
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

import CarolineCore
@testable import CLIKit

class VersionTests  {
    class Alias: CarolineTest {
        func test() throws {
            let version = VersionCommand(programName: "Foo", versionString: "1.0")
            let _ = try version.parser.parse(["--version"])
        }
    }
    
    class Version: CarolineTest {
        func test() throws {
            let version = VersionCommand(programName: "Foo", versionString: "1.0")
            let parseResult = try version.parser.parse(["--version"])
            version.command(parseResult)
        }
    }
    class VersionDefaults: CarolineTest {
        func test() throws {
            let version = MetaCommand(name: "mymeta", version: "0.0", subcommands: [])
            let parseResult = try version.parser.parse(["--version"])
            version.command(parseResult)
        }
    }
}
