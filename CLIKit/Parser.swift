//
//  Parser.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/10/15.
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

/**A type that holds the result of the parse.  The result is subscriptable.

- note: It's recommended that you use strngly-typed keys where possible.  Thus you could create

```
enum StringlyTyped: String {
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
    fileprivate var innerDict : [String: OptionType] = [:]
    /**
- returns: a non-optional.  If you're looking for a key that doesn't exist, that's programmer error. */
    public subscript(key: String) -> OptionType {
        get {
            return innerDict[key]!
        }
        set {
            innerDict[key] = newValue
        }
    }
}

/**This is the protocol that all Parsers conform to.  If you actually want an implementation, try `DefaultParser`.
*/
public protocol Parser {
    /**Implement parsing logic here.  Don't call this function directly, instead call `.parse` */
    func _parse(_ args: [String]) throws -> ParseResult
    var name: String { get }
    /**A short description to help the user understand how to use the parser */
    var shortHelp : String { get }
    /** A longer, potentially multi-line description of how to use the parser */
    var longHelp: String { get }
    
    /**Determines if the parser handles the arguments.  The default implementation attempts a parse, and returns false if the parse fails.
- discussion: This is used inside the `CommandParser` to indicate whether the command matches the input.  That way if the command matches, but some argument fails, we return an error to the user from the parser that handled the arguments. */
    func handlesArguments(_ args: [String]) -> Bool
    
    /**- returns: the best parser candidate for the given arguments.  The default implementation returns the receiver.
- note: With metaparsers, returning a child object here may yield better error/help messages.*/
    func underlyingParser(_ args: [String]) -> Parser
}
public extension Parser {
    func underlyingParser(_ args: [String]) -> Parser {
        return self
    }
    func parse(_ args: [String]) throws -> ParseResult {
        if args.index(of: "--help") != nil {
            print("\(self.underlyingParser(args).longHelp)")
            throw ParseError.userWantsHelp
        }
        return try _parse(args)
    }
    /**Parse the arguments from the environment, displaying error and usage information to the user on a parse error.*/
    public func parseArguments() -> ParseResult? {
        do {
            let args = ProcessInfo.processInfo.arguments
            let choppedArguments = [String](args[1..<args.count])
            let result : ParseResult = try self.parse(choppedArguments)
            return result
        }
        catch ParseError.innerParserFailed(let innerError, let parser) {
            print("\(innerError.📡22310636Description)")
            print("Usage: \(self.name) \(parser.longHelp)")
        }
        catch ParseError.userWantsHelp {
            /*In this case, we've already printed the help. */
            return nil
        }
        catch {
            print("\(error.📡22310636Description)")
            print("Usage: \(self.longHelp)")
            return nil
        }
        return nil
    }
    public func handlesArguments(_ args: [String]) -> Bool {
        do {
            try parse(args)
            return true
        }
        catch {
            return false
        }
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
    public func _parse(_ args: [String]) throws -> ParseResult {
        var args = args
        var t = ParseResult()
        for option in options {
            try option.parse(&args, accumulateResult: &t)
        }
        return t
    }
    public var shortHelp : String { get { return self.name } }
    public var longHelp : String { get { return self.shortHelp } }
}
