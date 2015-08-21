//
//  DefaultOption.swift
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