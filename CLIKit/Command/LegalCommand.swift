//
//  LegalCommand.swift
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

import Foundation
/**A command that outputs legal text. */
final class LegalCommand : EasyCommand {
    let name = "legal"
    let options : [Option] = []
    let shortHelp = "Display legal information"
    init() { /* */ }
    
    /**Gets the legal notice text for the specified bundle, if any */
    static func getNoticeText(bundle bundle: NSBundle) -> String? {
        let notices = ["NOTICE","LICENSE"]
        for notice in notices {
            if let noticePath = bundle.pathForResource(notice, ofType: nil) {
                return (NSString(data:NSData(contentsOfFile: noticePath)!, encoding:NSUTF8StringEncoding) as! String)
            }
        }
        return nil
    }
    
    internal func getNoticeText() -> String {
        var legalText = ""
        for bundle in NSBundle.allBundles() + NSBundle.allFrameworks() {
            if let noticeText = LegalCommand.getNoticeText(bundle: bundle) {
                //get bundle name and version
                var bundleName : String = bundle.description
                var bundleVersion : String = ""
                if let info = bundle.infoDictionary {
                    if let name = info[String(kCFBundleNameKey)] as? String { bundleName = name }
                    if let version = info[String("CFBundleShortVersionString")] as? String { bundleVersion = version }
                }
                legalText += "\(bundleName) \(bundleVersion)\n"
                legalText += noticeText
                legalText += "\n\n"
            }
        }
        return legalText
    }
    func command(parseResult: ParseResult) {
        let legalText = getNoticeText()
        print(legalText)
    }
}