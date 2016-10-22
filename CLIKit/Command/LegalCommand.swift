//
//  LegalCommand.swift
//  CLIKit
//
//  CLIKit © 2016 Drew Crawford
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

/**A command that outputs legal text.

This command looks for files called NOTICE or LICENSE, in the current bundle and its frameworks.  It outputs those notices to standard out.
This command is installed by default on all new MetaCommands.
*/
import pianissimo
import Foundation
final class LegalCommand : EasyCommand {
    let name = "legal"
    let options : [Option] = []
    let shortHelp = "Display legal information"
    init() { /* */ }
    
    /**Gets the legal notice text for the specified bundle, if any */
    static func getNoticeText(bundle: Bundle) -> String? {
        let notices = ["NOTICE","LICENSE"]
        for notice in notices {
            if let noticePath = bundle.path(forResource: notice, ofType: nil) {
                return (NSString(data:try! Data(contentsOf: URL(fileURLWithPath: noticePath)), encoding:String.Encoding.utf8.rawValue) as! String)
            }
        }
        return nil
    }
    
    internal func getNoticeText() -> String {
        return pianissimo.legalTexts.joined(separator: "\n\n")
    }
    func command(_ parseResult: ParseResult) {
        let legalText = getNoticeText()
        print(legalText)
    }
}
