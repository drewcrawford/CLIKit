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

/**A type that holds the result of the parse.  The result is subscriptable.

- note: It's recommended that you use strongly-typed keys where possible.  Thus you could create

```
enum StronglyTyped: String {
    case MyKey = "MyKey"
    case MyKey2 = "MyKey2"
}
```

and then

```
parseResult[StronglyTyped.MyKey.rawValue]
```

This way you ensure you don't have typos in your parsing logic.
*/
public struct ParseResult {
    private var innerDict : [String: OptionType] = [:]
    public subscript(key: String) -> OptionType? {
        get {
            return innerDict[key]
        }
        set {
            innerDict[key] = newValue
        }
    }
}

/**This is the protocol that all Parsers conform to.  If you actually want an implementation, try `DefaultParser`.
*/
public protocol Parser {
    func parse(args: [String]) throws -> ParseResult
    var name: String { get }
    /**A short description to help the user understand how to use the parser */
    var shortHelp : String { get }
    /** A longer, potentially multi-line description of how to use the parser */
    var longHelp: String { get }
}
public extension Parser {
    /**Parse the arguments from the environment, displaying error and usage information to the user on a parse error.*/
    public func parseArguments() -> ParseResult? {
        do {
            let args = NSProcessInfo.processInfo().arguments
            let choppedArguments = [String](args[1..<args.count])
            let result : ParseResult = try self.parse(choppedArguments)
            return result
        }
        catch ParseError.InnerParserFailed(let innerError, let parser) {
            print("\(innerError.📡22310636Description)")
            print("Usage: \(self.name) \(parser.longHelp)")
        }
        catch {
            print("\(error.📡22310636Description)")
            print("Usage: \(self.longHelp)")
            return nil
        }
        return nil
    }
}

/**The standard parser. */
public final class DefaultParser {
    public var options : [Option]
    public var name: String
    
    /**Creates the standard parser
- parameter name: A name for this parser.  This is used in help.
- parameter options: The options for this parser. */
    public init(name: String,options: [Option]) {
        self.name = name
        self.options = options
    }
}

extension DefaultParser : Parser {
    public func parse(var args: [String]) throws -> ParseResult {
        var t = ParseResult()
        for option in options {
            try option.parse(&args, accumulateResult: &t)
        }
        return t
    }
    public var shortHelp : String { get { return self.name } }
    public var longHelp : String { get { return self.shortHelp } }
}
