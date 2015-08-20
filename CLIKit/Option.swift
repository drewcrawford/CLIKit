//
//  Option.swift
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

import Foundation

public enum OptionType {
    case StringOption(String)
    
    public var stringValue: String? {
        get {
            switch(self){
            case .StringOption(let str):
                return str
            }
        }
    }
}

public func ==(lhs: OptionType, rhs: String) -> Bool {
    switch(lhs) {
    case .StringOption(let str):
        return str == rhs
    }
}

extension OptionType : StringLiteralConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = Character
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = OptionType.StringOption("\(value)")
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self = OptionType.StringOption(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = OptionType.StringOption(value)
    }
}

public protocol Option {
    var defaultValue: OptionType? { get }
    var required: Bool { get }
    var longName: String { get }
    /**A one-line help for the option */
    var shortHelp: String { get }
    
    func parse(inout args: [String], inout accumulateResult: ParseResult) throws
}

extension Option {
    /**A more detailed help for the option.  This might include information about default values, remarks, etc. */
    public var longHelp : String {
        get {
            var helpStr = "\(longName)"
            if self.defaultValue != nil {
                helpStr += " (optional)"
            }
            helpStr += ": "
            helpStr += shortHelp
            if self.defaultValue != nil {
                helpStr += "\nThe default value is \(defaultValue!.stringValue!)."
            }
            return helpStr
        }
    }
}

public final class DefaultOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    public let shortHelp: String
    
    public init(longName: String, help: String, defaultValue: OptionType? = nil, required: Bool = false) {
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
        self.shortHelp = help
    }
    
    public func parse(inout args: [String], inout accumulateResult: ParseResult) throws {
        let idx = args.indexOf("--\(longName)")
        guard let index = idx else {
            //is there a default value?
            guard let d = defaultValue else { throw ParseError.OptionMissing(self) }
            accumulateResult[longName] = d
            return
        }
        args.removeAtIndex(index) //remove --whatever
        let value = args[index]
        args.removeAtIndex(index) //remove value itself
        accumulateResult[longName] = OptionType.StringOption(value)
    }
}

extension DefaultOption : CustomStringConvertible {
    public var description: String { get { return "<DefaultOption: \(longName)>" } }
}

/**An option for a secure field.  This kind of option cannot be passed as a command line argument.  Provide the default value or the user will be interactively prompted. */
public final class SecureOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    public let shortHelp: String
    #if ENABLE_TESTING
    private let value_for_unit_testing: Any!
    #endif

    public init(longName: String, help: String, defaultValue: OptionType? = nil, required: Bool = false, value_for_unit_testing: Any! = nil) {
        #if ENABLE_TESTING
            self.value_for_unit_testing = value_for_unit_testing
        #endif
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
        self.shortHelp = help
    }
    
    public func parse(inout args: [String], inout accumulateResult: ParseResult) throws {
        #if ENABLE_TESTING
            if value_for_unit_testing != nil {
                accumulateResult[longName] = OptionType.StringOption(value_for_unit_testing as! String) //🐞 support more types
                return
            }
        #endif
        let value = getpass("Enter \(longName):")
        let strValue = String(CString: value, encoding: NSUTF8StringEncoding)!
        accumulateResult[longName] = OptionType.StringOption(strValue)
    }
    
}