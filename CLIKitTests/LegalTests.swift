//
//  LegalTests.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
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

class LegalTests  {
    /*verify that the legal cmd is installed by default */
    class Meta : CarolineTest {
        func test() throws {
            let meta = MetaCommand(name: "LegalTests", subcommands: [])
            let _ = try! meta.parse(["legal"])
        }
    }
    
    class Legal: CarolineTest {
        func test() {
            let legal = LegalCommand()
            let result = legal.getNoticeText()
            self.assert(result.characters.count > 5)
            print("Legal texts were",result)
        }
    }
}
