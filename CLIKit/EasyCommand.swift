//
//  EasyCommand.swift
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

/**Implement this to create a command easily. */
public protocol EasyCommand: CLIKit.Command {
    /**The name of your command */
    var name: String { get }
    /**The options your command supports */
    var options: [Option] { get }
    /**A short, one-line help string that describes what your command does.*/
    var shortHelp: String { get }
}

extension EasyCommand {
    public var parser: Parser {
        get {
            return CommandParser(name: self.name, options: self.options, help: self.shortHelp)
        }
    }
}

/**A parser that tries to match against a particular command string.
- note: You probably want to use EasyCommand instead of working with this class directly. */
public final class CommandParser: Parser {
    public var options: [Option]
    public var name: String
    public var shortHelp: String
    
    private let innerParser: DefaultParser
    public init(name: String, options: [Option], help: String) {
        self.name = name
        self.options = options
        self.innerParser = DefaultParser(name: name, options: options)
        self.shortHelp = help
    }
    
    public func parse(args: [String]) throws -> ParseResult {
        if args[0] != name {
            throw ParseError.NotThisCommand
        }
        let newArgs = [String](args[1..<args.count]) //lop off the command name
        return try self.innerParser.parse(newArgs)
    }
    public var longHelp : String { get {
        var usageStr = "\(self.name)"
        for option in self.options {
            usageStr += " --\(option.longName) [\(option.longName)]"
        }
        usageStr += "\n\n"
        for option in self.options {
            usageStr += "\(option.longName): \(option.shortHelp)\n"
        }
        return usageStr
        } }
}
