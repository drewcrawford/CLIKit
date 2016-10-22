//
//  MetaCommandTests.swift
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

import Foundation
@testable import CLIKit


private final class MyGreatCommand : CLIKit.EasyCommand {
    fileprivate let options : [Option] = [DefaultOption(longName: "myOption", help: "Help for this option")]
    fileprivate let shortHelp = "Help for this command"
    let name = "myGreatCommand"
    fileprivate func command(_ parseResult: ParseResult) {
        //todo command logic here
    }
}

private final class MyGreatCommand2 : CLIKit.EasyCommand {
    fileprivate let options : [Option] = []
    fileprivate let shortHelp = "Help for this command"
    let name = "myGreatCommand2"
    fileprivate func command(_ parseResult: ParseResult) {
        //todo command logic here
    }
}

import CarolineCore

class MetaCommandOrder : CarolineTest {
    func test() throws {
        //we try to parse the underlying command
        //that appears second in the creation order
        //this exhibits a bug in 1.3 related to requiresCommandString.
        let meta = MetaCommand(name: "myMeta", subcommands: [MyGreatCommand(),MyGreatCommand2()])
        let _ = try meta.parse(["myGreatCommand2"])
    }
}



