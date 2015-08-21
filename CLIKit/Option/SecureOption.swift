//
//  SecureOption.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/21/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
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
                accumulateResult[longName] = OptionType.StringOption(value_for_unit_testing as! String) //<U+1F41E> support more types
                return
            }
        #endif
        let value = getpass("Enter \(longName):")
        let strValue = String(CString: value, encoding: NSUTF8StringEncoding)!
        accumulateResult[longName] = OptionType.StringOption(strValue)
    }
}