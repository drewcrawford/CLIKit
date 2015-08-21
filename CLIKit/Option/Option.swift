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