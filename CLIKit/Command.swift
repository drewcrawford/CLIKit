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

/**The command protocol.
- note: You probably don't want to implement this directly; instead implementing EasyCommand. */
public protocol Command {
    var parser: CLIKit.Parser { get }
    func command(parseResult: ParseResult)
    var name: String { get }
}

public struct LegalParseResult : ParseResult {
    public func setValue(value: Any?, forKey key: String) {
        abort()
    }
    public static func typeForKey(key: String) -> Any.Type {
        abort()
    }
    public init() { }
}

/**A command that outputs legal text. */
public final class LegalCommand : EasyCommand {
    public typealias ParseResultType = LegalParseResult
    public let name = "legal"
    public let options : [Option] = []
    public let shortHelp = "Display legal information"
    private let legalText: String
    public init(legalText: String) {
        self.legalText = legalText
    }
    public func command(parseResult: ParseResult) {
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

/**Implement this to implement a command easily. */
public protocol EasyCommand: CLIKit.Command {
    typealias ParseResultType : ParseResult
    var name: String { get }
    var options: [Option] { get }
    var shortHelp: String { get }
}

extension EasyCommand {
    public var parser: Parser {
        get {
            return CommandParser<ParseResultType>(name: self.name, options: self.options, help: self.shortHelp)
        }
    }
}