//
//  Command.swift
//  CLIKit
//
//  Created by Drew Crawford on 8/10/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of CLIKit.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of CLIKit, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

/**The command protocol.
- note: You probably don't want to implement this directly; instead implementing EasyCommand. */
public protocol Command {
    var parser: CLIKit.Parser { get }
    func command(parseResult: ParseResult)
    var name: String { get }
}