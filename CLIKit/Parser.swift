//
//  Parser.swift
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

enum ParseError : ErrorType {
    case OptionMissing(Option)
    case NotThisCommand
    case NoParserMatched
}

public protocol KeyValueCodeable {
    mutating func setValue(value: Any?, forKey key: String)
    static func typeForKey(key: String) -> Any.Type
}

public protocol ParseResult : KeyValueCodeable {
    init()
}

public protocol CommandParseResult : ParseResult {
    var commandImplementation: () -> () { get set }
}

public protocol Parser {
    func parse(args: [String]) throws -> ParseResult
    var name: String { get }
    func usage()
}
public extension Parser {
    public func parseArguments() -> ParseResult? {
        do {
            let args = NSProcessInfo.processInfo().arguments
            let choppedArguments = [String](args[1..<args.count])
            let result : ParseResult = try self.parse(choppedArguments)
            return result
        }
        catch ParseError.OptionMissing(let opt){
            print("Missing option --\(opt.longName)")
            self.usage()
            return nil
        }
        catch {
            print("\(error)")
            self.usage()
            return nil
        }
    }
}
public final class DefaultParser<T: ParseResult> {
    public var options : [Option]
    public var name: String
    public var subparsers : [Parser]
    
    public init(name: String,options: [Option], subparsers: [Parser] = []) {
        self.name = name
        self.options = options
        self.subparsers = subparsers
    }
}

extension DefaultParser : Parser {
    public func parse(var args: [String]) throws -> ParseResult {
        var t = T()
        for option in options {
            try option.parse(&args, accumulateResult: &t)
        }
        return t
    }
    public func usage() {
        var usageStr = "Usage: \(name)"
        for option in options {
            usageStr += " --\(option.longName) <\(option.longName)>"
        }
        print(usageStr)
    }
}

/**A parser that tries to match against a particular command. */
public final class CommandParser<T: ParseResult>: Parser {
    public var options: [Option]
    public var name: String
    
    private let innerParser: DefaultParser<T>
    public init(name: String, options: [Option], subparsers: [Parser] = []) {
        self.name = name
        self.options = options
        self.innerParser = DefaultParser(name: name, options: options, subparsers: subparsers)
    }
    
    public func parse(args: [String]) throws -> ParseResult {
        if args[0] != name {
            throw ParseError.NotThisCommand
        }
        let newArgs = [String](args[1..<args.count]) //lop off the command name
        return try self.innerParser.parse(newArgs)
    }
    public func usage() {
        var usageStr = "Usage: \(name)"
        for option in options {
            usageStr += " --\(option.longName) <\(option.longName)>"
        }
        print(usageStr)
    }
}
