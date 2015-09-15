//
//  CLIKit.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
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

/**An error occurred while parsing command line arguments */
enum ParseError : ErrorType {
    ///The user did not specify an option
    case OptionMissing(Option)
    ///A command is being routed to a parser that does not want to handle it
    case NotThisCommand
    ///No subparser can match the arguments
    case NoParserMatched
    ///A subparser failed to parse the arguments.  More information may be found in the associated values
    case InnerParserFailed(ErrorType, Parser)
    ///The user indicated that they want help, so parsing should not continue.
    case UserWantsHelp
    ///The user chose an option in the first associated value, but we expected a choice from the second associated value
    case UnknownChoice(String, [String])
    ///This is an `Int` option, but the text passed to the parser is not an integer.
    case NotInt(String)
    
    var 📡_22310636Description: String {
        switch(self) {
        case .OptionMissing(let option):
            return "Missing option --\(option.longName)"
        default:
            return "\(self)"
        }
    }
}

extension ErrorType {
    var 📡22310636Description: String {
        if let e = self as? ParseError {
            return e.📡_22310636Description
        }
        return "\(self)"
    }
}

/**Prints text to the standard error. */
public func printErr(items: Any...) {
    //this monstrosity to work around 📡22495195
    var joined = items.reduce("") { (accumulator, element) -> String in
        return accumulator + " \(element)"
    }
    joined.removeAtIndex(joined.characters.indices.startIndex)
    fputs(joined+"\n", stderr)
}