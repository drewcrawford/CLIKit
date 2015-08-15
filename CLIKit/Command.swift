//
//  Command.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/10/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

public protocol Command {
    var parser: CLIKit.Parser { get }
    func command<T: ParseResult>(parseResult: T)
    var name: String { get }
}

private struct LegalParseResult : ParseResult {
    private func setValue(value: Any?, forKey key: String) {
        abort()
    }
    private static func typeForKey(key: String) -> Any.Type {
        abort()
    }
}

/**A command that outputs legal text. */
public final class LegalCommand : Command {
    public let name = "legal"
    public let parser : Parser = CLIKit.CommandParser<LegalParseResult>(name: "legal", options: [])
    private let legalText: String
    public init(legalText: String) {
        self.legalText = legalText
    }
    public func command<T: ParseResult>(parseResult: T) {
        print(self.legalText)
    }
}

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
        self.subcommands = subcommands
    }
    
    private var recentlyParsedCommand : Command! = nil
    
    public func parse(args: [String]) throws -> ParseResult {
        for command in subcommands {
            if args[0] == command.name {
                recentlyParsedCommand = command
                return try command.parser.parse(args)
            }
        }
        throw ParseError.NoParserMatched
    }
    
    public func command<T : ParseResult>(parseResult: T) {
        recentlyParsedCommand.command(parseResult)
    }
    
    public func usage() {
        print("Usage: ", appendNewline: false)
        for command in subcommands {
            print("\(command.name) ", appendNewLine: false)
        }
        print("")
    }
}