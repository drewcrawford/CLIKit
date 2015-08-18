//
//  CLIKit.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/18/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

enum ParseError : ErrorType {
    case OptionMissing(Option)
    case NotThisCommand
    case NoParserMatched
    case InnerParserFailed(ErrorType, Parser)
    
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