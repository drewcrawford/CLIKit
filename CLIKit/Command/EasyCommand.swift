//
//  EasyCommand.swift
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

/**Implement this to create a command easily. */
public protocol EasyCommand: CLIKit.Command {
    /**The name of your command */
    var name: String { get }
    /**The options your command supports */
    var options: [Option] { get }
    /**A short, one-line help string that describes what your command does.*/
    var shortHelp: String { get }
    /**Setting this to false indicates the command string is not required to be present.  This may be useful if the EasyCommand is at the top of the parse hierarchy. */
    var requiresCommandString: Bool { get }
}

extension EasyCommand {
    public var requiresCommandString: Bool { return true }
}

extension EasyCommand {
    public var parser: Parser {
        get {
            return CommandParser(name: self.name, options: self.options, help: self.shortHelp, aliases: self.aliases, requiresCommandString: requiresCommandString)
        }
    }
}

/**A parser that tries to match against a particular command string.
- note: You probably want to use EasyCommand instead of working with this class directly. */
internal final class CommandParser: Parser {
    var options: [Option]
    var name: String
    var aliases: [String]
    var shortHelp: String
    var requiresCommandString: Bool //setting this to false means we handle the arguments regardless
    
    private let innerParser: DefaultParser
    init(name: String, options: [Option], help: String, aliases: [String] = [], requiresCommandString: Bool = true) {
        self.name = name
        self.options = options
        self.innerParser = DefaultParser(name: name, options: options)
        self.shortHelp = help
        self.aliases = aliases
        self.requiresCommandString = requiresCommandString
    }
    
    func handlesArguments(args: [String]) -> Bool {
        if requiresCommandString {
            var allAliases = aliases
            allAliases.append(name)
            if args.count == 0 { return false }
            for alias in allAliases {
                if alias == args[0] { return true}
            }
            return false
        }
        else { return true }
    }
    
    func _parse(args: [String]) throws -> ParseResult {
        if !handlesArguments(args) {
            throw ParseError.NotThisCommand
        }
        let newArgs: [String]
        if requiresCommandString {
            newArgs = [String](args[1..<args.count]) //lop off the command name
        }
        else { newArgs = args }
        return try self.innerParser.parse(newArgs)
    }
    var longHelp : String { get {
        var usageStr = "\(self.name)"
        for option in self.options {
            usageStr += " \(option.usageHelp)"
        }
        usageStr += "\n\n"
        for option in self.options {
            usageStr += "\(option.longHelp)\n\n"
        }
        return usageStr
        } }
}
