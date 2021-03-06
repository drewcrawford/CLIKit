//
//  OptionalArguments.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/28/15.
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

class OptionalArgumentsTests {
    
    class Optional: CarolineTest {
        func test() throws {
            let o = DefaultOption(longName: "myname", help: "myhelp", required: false)
            let parser = DefaultParser(name: "myparser", options: [o])
            let _ = try parser.parse([])
        }
    }
    
    class OptionalHelp: CarolineTest {
        func test() throws {
            let o = DefaultOption(longName: "myname", help: "myhelp", required: false)
            let help = o.longHelp
            self.assert(help, equals: "myname (optional): myhelp")
        }
    }
}
