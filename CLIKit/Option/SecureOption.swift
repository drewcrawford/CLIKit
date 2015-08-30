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

import Foundation
/**An option for a secure field.  This kind of option cannot be passed as a command line argument.  Provide the default value or the user will be interactively prompted. */
public final class SecureOption: Option {
    public let defaultValue: OptionType?
    public let required: Bool
    public let longName: String
    public let shortHelp: String
    
    /**
- parameter defaultValue: Be aware that if you pass a default value here, the user will not be prompted.  This is specific to SecureOption.  While the normal options are often overridden by the user, in the SecureOption case, the defaultValue is often used in cases where we can't prompt the user interactively, such as unit tests and build servers.
*/
    public init(longName: String, help: String, defaultValue: OptionType? = nil, required: Bool = false) {
        self.required = required
        self.defaultValue = defaultValue
        self.longName = longName
        self.shortHelp = help
    }
    
    public func parse(inout args: [String], inout accumulateResult: ParseResult) throws {
        if let dv = self.defaultValue {
            accumulateResult[longName] = dv
            return
        }
        let value = getpass("Enter \(longName):")
        let strValue = String(CString: value, encoding: NSUTF8StringEncoding)!
        switch(type) {
        case .StringOption:
            break
        default:
            preconditionFailure("Not implemented for type \(type)")
        }
        accumulateResult[longName] = OptionType.StringOption(strValue)
    }
}