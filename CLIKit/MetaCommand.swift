//
//  MetaCommand.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

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
        self.subcommands = subcommands + [LegalCommand()]
    }
    
    private var recentlyParsedCommand : Command! = nil
    
    public func parse(args: [String]) throws -> ParseResult {
        if args.count == 0 { throw ParseError.NoParserMatched }
        for command in subcommands {
            if args[0] == command.name {
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
