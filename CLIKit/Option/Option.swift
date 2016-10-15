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

/**Indicates the type of the option. */
public enum OptionType {
    ///An int
    case intOption(Int)
    ///A string
    case stringOption(String)
    ///indicates the option wasn't present.  Typically used for optional options.
    case notPresent
    
    /**
    
Get the option as a `String`.
    
- note: If you call `.stringValue` on something that's an `Int`, we're calling that programmer error.
If you don't know if the user passed this option (e.g., if `required == false`), use `maybeStringValue?` instead.
- note: This function is non-optional because 90% of the time, you're dealing with non-optional stringValues and you don't want bangs everywhere.  Only if you're using optional options, should you upgrade to maybeStringValue.
    */
    public var stringValue: String {
        get {
            switch(self){
            case .stringOption(let str):
                return str
            default:
                abort()
            }
        }
    }
/** Gets the string value if the user passed an option, or else nil.*/
    public var maybeStringValue: String? {
        get {
            switch(self) {
            case.stringOption(let str):
                return str
            case .notPresent:
                return nil
            case .intOption:
                preconditionFailure("Don't use maybeStringValue for an int option.")
            }
        }
    }
    
/**Get the option as an `Int`.

- note: If you call `.intValue` on something that's a `String`, we're calling that programmer error.
- note: This function is non-optional because 90% of the time, you're dealing with non-optional stringValues and you don't want bangs everywhere.  Only if you're using optional options, should you upgrade to `maybeIntValue`.
- bug: There is no `maybeIntValue`.
*/
    public var intValue: Int {
        get {
            switch(self) {
            case .intOption(let int):
                return int
            default:
                preconditionFailure("No int available")
            }
        }
    }
    
    //todo: maybeIntValue?
}

public func ==(lhs: OptionType, rhs: String) -> Bool {
    switch(lhs) {
    case .stringOption(let str):
        return str == rhs
    case .notPresent:
        return false
    case .intOption:
        return false
    }
}

extension OptionType : ExpressibleByStringLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = Character
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = OptionType.stringOption("\(value)")
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self = OptionType.stringOption(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = OptionType.stringOption(value)
    }
}

public protocol Option {
    /**The default value for the option.  Setting a default value means the user can omit specifying an explicit value. */
    var defaultValue: OptionType? { get }
    /**Whether the option is required.  Note that, if `defaultValue != nil`, using `required: false` is not sensible. */
    var required: Bool { get }
    /** The long name for the option. */
    var longName: String { get }
    /**A one-line help for the option */
    var shortHelp: String { get }
    /**A usage string for the option.  This is typically e.g. `--option [option]` */
    var usageHelp: String { get }
    /**A more detailed help for the option.  This might include information about default values, remarks, etc. */
    var longHelp: String { get }
    
    /**A prototype for what type this option will hold.  The defualt is StringOption. */
    var type : OptionType { get }
    
    func parse(_ args: inout [String], accumulateResult: inout ParseResult) throws
}

extension Option {
    public var usageHelp: String {
        return "--\(longName) [\(longName)]"
    }
    public var type: OptionType {
        get {
            return OptionType.stringOption("")
        }
    }
    public var longHelp : String {
        get {
            var helpStr = "\(longName)"
            if self.defaultValue != nil || !self.required {
                helpStr += " (optional)"
            }
            helpStr += ": "
            helpStr += shortHelp
            if self.defaultValue != nil {
                helpStr += "\nThe default value is \(defaultValue!.stringValue)."
            }
            return helpStr
        }
    }
}
