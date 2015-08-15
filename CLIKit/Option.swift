//
//  Option.swift
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
    
    func parse<T: ParseResult>(inout args: [String], inout accumulateResult: T) throws
}

public final class DefaultOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    
    public init(longName: String, defaultValue: OptionType? = nil, required: Bool = false) {
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
    }
    
    public func parse<T: ParseResult>(inout args: [String], inout accumulateResult: T) throws {
        let idx = args.indexOf("--\(longName)")
        guard let index = idx else { throw ParseError.OptionMissing(self) }
        args.removeAtIndex(index) //remove --whatever
        let value = args[index]
        args.removeAtIndex(index) //remove value itself
        accumulateResult.setValue(value, forKey: longName)
    }
}

/**An option for a secure field.  This kind of option cannot be passed as a command line argument.  Provide the default value or the user will be interactively prompted. */
public final class SecureOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    #if ENABLE_TESTING
    private let value_for_unit_testing: Any!
    #endif

    public init(longName: String, defaultValue: OptionType? = nil, required: Bool = false, value_for_unit_testing: Any! = nil) {
        #if ENABLE_TESTING
            self.value_for_unit_testing = value_for_unit_testing
        #endif
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
    }
    
    public func parse<T: ParseResult>(inout args: [String], inout accumulateResult: T) throws {
        #if ENABLE_TESTING
            if value_for_unit_testing != nil {
                accumulateResult.setValue(value_for_unit_testing, forKey: longName)
                return
            }
        #endif
        let value = getpass("Enter \(longName):")
        let strValue = String(CString: value, encoding: NSUTF8StringEncoding)
        accumulateResult.setValue(strValue, forKey: longName)
    }
    
}