//
//  MetaCommand.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
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
/**A command that picks exactly one of several subcommands. This is ordinarily the top-level command for most programs.
- note: A command called "legal" is automatically added to MetaCommands.  The "legal" command displays NOTICE or LICENSE files for the bundle or any frameworks for the executable. */
public final class MetaCommand : CLIKit.Command, CLIKit.Parser {
    
    private let subcommands: [Command]
    public let name: String
    public var parser: CLIKit.Parser {
        get {
            return self
        }
    }
    public init(name: String, subcommands: [Command]) {
        self.name = name
        self.subcommands = subcommands + [LegalCommand(), VersionCommand()]
    }
    
    private var recentlyParsedCommand : Command! = nil
    
    public func _parse(args: [String]) throws -> ParseResult {
        if args.count == 0 { throw ParseError.NoParserMatched }
        for command in subcommands {
            if command.parser.handlesArguments(args) {
                recentlyParsedCommand = command
                do {
                    return try command.parser.parse(args)
                }
                catch {
                    throw ParseError.InnerParserFailed(error, command.parser)
                }
            }
        }
        throw ParseError.NoParserMatched
    }
    
    public func underlyingParser(args: [String]) -> Parser {
        for child in subcommands {
            if child.parser.handlesArguments(args) { return child.parser }
        }
        return self
    }
    
    public func command(parseResult: ParseResult) {
        recentlyParsedCommand.command(parseResult)
    }
    
    public var shortHelp : String { get { return self.name } }
    public var longHelp : String { get {
        var usageStr = "\(self.name) [command]\n\nValid commands:\n"
        
        for command in subcommands {
            usageStr += "\(command.name): \(command.parser.shortHelp)\n"
        }
        usageStr += "\nFor more information, try \(self.name) [command] --help"
        return usageStr
        } }
}
