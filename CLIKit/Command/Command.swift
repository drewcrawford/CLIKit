//
//  Command.swift
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

/**The command protocol.
- note: You probably don't want to implement this directly; instead consider implementing EasyCommand. */
public protocol Command {
    /**The command's parser.  Ordinarily this is a `CommandParser`. */
    var parser: CLIKit.Parser { get }
    /**A function to run when the command is selected.
- parameter parseResult: The result we parsed for this command */
    func command(parseResult: ParseResult)
    var name: String { get }
    
    /**Additional aliases for the given command.  Override this to specify alternatives. */
    var aliases : [String] { get }
}

extension Command {
    public var aliases : [String] {
        get {
            return []
        }
    }
}