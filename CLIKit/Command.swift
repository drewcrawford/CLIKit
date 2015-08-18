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

/**A command that outputs legal text. */
public final class LegalCommand : EasyCommand {
    public let name = "legal"
    public let options : [Option] = []
    public let shortHelp = "Display legal information"
    public init() { /* */ }
    
    private func getNoticeText(bundle bundle: NSBundle) -> String? {
        let notices = ["NOTICE","LICENSE"]
        for notice in notices {
            if let noticePath = bundle.pathForResource(notice, ofType: nil) {
                return (NSString(data:NSData(contentsOfFile: noticePath)!, encoding:NSUTF8StringEncoding) as! String)
            }
        }
        return nil
    }
    
    internal func getNoticeText() -> String {
        var legalText = ""
        for bundle in NSBundle.allBundles() + NSBundle.allFrameworks() {
            if let noticeText = getNoticeText(bundle: bundle) {
                //get bundle name and version
                var bundleName : String = bundle.description
                var bundleVersion : String = ""
                if let info = bundle.infoDictionary {
                    if let name = info[String(kCFBundleNameKey)] as? String { bundleName = name }
                    if let version = info[String(kCFBundleVersionKey)] as? String { bundleVersion = version }
                }
                legalText += "\(bundleName) \(bundleVersion)\n"
                legalText += noticeText
                legalText += "\n\n"
            }
        }
        return legalText
    }
    public func command(parseResult: ParseResult) {
        var legalText = getNoticeText()
        print(legalText)
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

/**Implement this to implement a command easily. */
public protocol EasyCommand: CLIKit.Command {
    var name: String { get }
    var options: [Option] { get }
    var shortHelp: String { get }
}

extension EasyCommand {
    public var parser: Parser {
        get {
            return CommandParser(name: self.name, options: self.options, help: self.shortHelp)
        }
    }
}