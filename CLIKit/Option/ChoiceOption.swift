//
//  ChoiceOption.swift
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


/**An option that allows the user to pick from several choices (multiple-choice). */
public final class ChoiceOption : Option {
    public let defaultValue: OptionType?
    public let required: Bool = true
    public let longName : String
    public let shortHelp : String
    public let choices: [String]
    public func parse(_ args: inout [String], accumulateResult: inout ParseResult) throws {
        guard let index = args.index(of: "--\(longName)") else {
            //maybe there's a default value we can use
            if let defaultValue = defaultValue {
                accumulateResult[longName] = defaultValue
                return
            }
            //otherwise
            throw ParseError.optionMissing(self)
        }
        args.remove(at: index)
        let choice = args[index]
        guard let _ = choices.index(of: choice) else {throw ParseError.unknownChoice(choice, choices) }
        accumulateResult[longName] = OptionType.stringOption(choice)
    }
    
    /**
Construct a new ChoiceOption.
- parameters:
    - longName: The long name of the option, e.g. `--myLongName`
    - shortHelp: A one-line help for the option
    - choices: An array of choice strings
    - defaultValue: A default value for the choice, allowing the user to omit the option.
- bug: This constructor uses strings for choices due to 📡22393113 */
    public init(longName:String, shortHelp: String, choices: [String], defaultValue:OptionType? = nil) {
        self.longName = longName
        self.shortHelp = shortHelp
        self.defaultValue = defaultValue
        self.choices = choices
    }
    
    public var usageHelp: String {
        var h = "--\(longName) ["
        for choice in choices {
            h += "\(choice)|"
        }
        h = h[h.startIndex..<h.characters.index(before: h.endIndex)] //clamp comma
        h += "]"
        return h
    }
    
    public var longHelp: String {
        var h = "\(longName)"
        if defaultValue != nil {
            h += " (optional)"
        }
        h += ": \(shortHelp)\n"
        
        h += "Valid choices are: "
        for choice in choices {
            h += "\(choice), "
        }
        h = h[h.startIndex..<h.index(before: h.characters.index(before: h.endIndex))] //clamp comma
        h += "."
        if let d = defaultValue {
            h += "\n"
            h += "The default value is \(d.stringValue)."
        }
        return h
    }
}
