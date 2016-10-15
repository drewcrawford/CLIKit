//
//  SecureOption.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/21/15.
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

/**An option for a secure field.  This kind of option cannot be passed as a command line argument, since then it would be listed in your `.bash_history`.  Provide the default value or the user will be interactively prompted. */
public final class SecureOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    public let shortHelp: String
    
    /**
Create a new SecureOption.
- parameters:
    - longName: The long name of the option, e.g. `--myLongName`
    - help: A one-line help for the option
    - defaultValue: Be aware that if you pass a default value here, the user will not be prompted.  This is specific to `SecureOption`.  While the `DefaultOption`s are often overridden by the user, in the `SecureOption` case, the defaultValue is often used in cases where we can't prompt the user interactively, such as unit tests and build servers.
    - required: Whether the option is required.  If `defaultValue != nil`, `required: true` is not sensible.
*/
    public init(longName: String, help: String, defaultValue: OptionType? = nil, required: Bool = false) {
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
        self.shortHelp = help
    }
    
    public func parse(_ args: inout [String], accumulateResult: inout ParseResult) throws {
        if let dv = self.defaultValue {
            accumulateResult[longName] = dv
            return
        }
        let value = getpass("Enter \(longName):")!
        let strValue = String(cString: value, encoding: String.Encoding.utf8)!
        switch(type) {
        case .stringOption:
            break
        default:
            preconditionFailure("Not implemented for type \(type)")
        }
        accumulateResult[longName] = OptionType.stringOption(strValue)
    }
}
