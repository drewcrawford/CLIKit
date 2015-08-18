//
//  LegalCommand.swift
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
/**A command that outputs legal text. */
final class LegalCommand : EasyCommand {
    let name = "legal"
    let options : [Option] = []
    let shortHelp = "Display legal information"
    init() { /* */ }
    
    private func getNoticeText(bundle bundle: NSBundle) -> String? {
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
            if let noticeText = getNoticeText(bundle: bundle) {
                //get bundle name and version
                var bundleName : String = bundle.description
                var bundleVersion : String = ""
                if let info = bundle.infoDictionary {
                    if let name = info[String(kCFBundleNameKey)] as? String { bundleName = name }
                    if let version = info[String(kCFBundleVersionKey)] as? String { bundleVersion = version }
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