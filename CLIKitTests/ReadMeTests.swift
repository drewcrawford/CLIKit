//
//  ReadMeTests.swift
//  CLIKit
//
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


private final class MyGreatCommand : CLIKit.EasyCommand {
    fileprivate let options : [Option] = [DefaultOption(longName: "myOption", help: "Help for this option")]
    fileprivate let shortHelp = "Help for this command"
    let name = "myGreatCommand"
    let requiresCommandString = false
    fileprivate func command(_ parseResult: ParseResult) {
        //todo command logic here
    }
}



import CarolineCore
@testable import CLIKit

class ReadMeTests : CarolineTest {
    func test() throws {
        let command = MyGreatCommand()
        let r  = try command.parser.parse(["--myOption","Excellent option"])
        command.command(r)
    }
}
