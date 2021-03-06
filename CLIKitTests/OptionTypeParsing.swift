//
//  OptionTypeParsing.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/30/15.
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

class OptionTypeParsingTests {
    class IntParse: CarolineTest {
        func test() throws {
            let option = DefaultOption(longName: "int", help: "Some int", type: OptionType.intOption(0))
            var parseResult = ParseResult()
            var args = ["--int","2"]
            try option.parse(&args, accumulateResult: &parseResult)
            self.assert(parseResult["int"].intValue, equals: 2)
        }
    }
    
    class IntParseDefault: CarolineTest {
        func test() throws {
            let option = DefaultOption(longName: "int", help: "Some int", defaultValue: OptionType.intOption(2), type: OptionType.intOption(0))
            var parseResult = ParseResult()
            var args: [String] = []
            try option.parse(&args, accumulateResult: &parseResult)
            self.assert(parseResult["int"].intValue, equals: 2)
        }
    }
}
