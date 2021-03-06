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

/**A command that picks exactly one of several subcommands. This is ordinarily the top-level command for most programs.
- note: A command called "legal" is automatically added to `MetaCommand`s.  The "legal" command displays `NOTICE` or `LICENSE` files for the bundle or any frameworks for the executable.
- note: A version command is automatically added to `MetaCommand`s.*/
public final class MetaCommand : Command, Parser {
    
    fileprivate let subcommands: [Command]
    public let name: String
    public var parser: Parser {
        get {
            return self
        }
    }
    public init(name: String, version: String, subcommands: [Command]) {
        self.name = name
        self.subcommands = subcommands + [LegalCommand(), VersionCommand(programName: name, versionString: version)]
    }
    
    fileprivate var recentlyParsedCommand : Command! = nil
    
    public func _parse(_ args: [String]) throws -> ParseResult {
        if args.count == 0 { throw ParseError.noParserMatched }
        for command in subcommands {
            if command.parser.handlesArguments(args) {
                recentlyParsedCommand = command
                do {
                    return try command.parser.parse(args)
                }
                catch {
                    throw ParseError.innerParserFailed(error, command.parser)
                }
            }
        }
        throw ParseError.noParserMatched
    }
    
    public func underlyingParser(_ args: [String]) -> Parser {
        for child in subcommands {
            if child.parser.handlesArguments(args) { return child.parser }
        }
        return self
    }
    
    public func command(_ parseResult: ParseResult) {
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
