//
//  UITextView+asterisk.swift
//  ZHTextViewDemo
//
//  Created by Zakk Hoyt on 1/6/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

enum UITextViewCursorPosition: UInt {
    case Front = 0
    case Back = 1
}


extension UITextView {
    func formatTextView(token: NSString, attributes: NSDictionary){
        
        let originalSelectedRange = self.selectedRange
        let attributedText = self.attributedText
        
        // TODO: This could be handled better with some Regex research. Generate the regex from token string
        // Note: This function is dendent on the token.length for setting cursor positions. Token is easier to understand and pass in than a regex string.
        var pattern: NSString = ""
        if(token == "*") {
            pattern = NSString(format: "\\*([^\\*]*?)\\*", token, token, token) as NSString
        } else if token == "**" {
            pattern = NSString(format: "\\*\\*([^\\*\\*]*?)\\*\\*", token, token, token) as NSString
        } else {
            return
        }
        
        do {
            let regex = try NSRegularExpression(pattern: pattern as String, options: .CaseInsensitive)
            let allRange = NSMakeRange(0, attributedText.length)
            let matchCount = regex.numberOfMatchesInString(attributedText.string, options: .ReportCompletion, range: allRange)
            
            if matchCount > 0 {
                print("\(matchCount) matches")
                if let result = regex.firstMatchInString(attributedText.string, options: .ReportCompletion, range: allRange) {
                    let fullRange = result.range
                    let fullTextString = attributedText.string as NSString // force NSString so we can use NSRange instead of Range<..>
                    let fullSubStr = fullTextString.substringWithRange(fullRange)
                    print("fullSubStr: " + fullSubStr)
                    
                    let prettyRange = NSMakeRange(fullRange.location + 1*token.length, fullRange.length - 2*token.length)
                    if prettyRange.length == 0 {
                        return
                    }
                    
                    // Get original attributed text and apply new attributes
                    let prettyAttrString = attributedText.attributedSubstringFromRange(prettyRange).mutableCopy() as! NSMutableAttributedString
                    print("prettyAttrString.string: " + prettyAttrString.string)
                    print("prettyAttrString: " + prettyAttrString.description)
                    prettyAttrString.addAttributes(attributes as! [String : AnyObject], range: NSMakeRange(0, prettyAttrString.string.characters.count))
                    
                    // If cursor is at end of sequence, append a space with no formatting
                    var cursor = UITextViewCursorPosition.Front
                    if fullRange.location + fullRange.length == originalSelectedRange.location {
                        // end
                        cursor = .Back
                        let space = NSAttributedString(string: " ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
                        prettyAttrString.appendAttributedString(space)
                    }
                    
                    // Apply the target attributedString to our whole attributedString
                    let updateAttrString = attributedText.mutableCopy() as! NSMutableAttributedString
                    updateAttrString.deleteCharactersInRange(fullRange)
                    updateAttrString.insertAttributedString(prettyAttrString, atIndex: fullRange.location)
                    
                    // Update textView.text
                    self.attributedText = updateAttrString
                    
                    // Now set cursor. It will either be at the beginning or end of your entry
                    if cursor == .Front {
                        // move to beginning
                        self.selectedRange = NSMakeRange(fullRange.location, 0)
                    } else {
                        // move to end
                        self.selectedRange = NSMakeRange(fullRange.location + prettyAttrString.string.characters.count, 0)
                    }
                }
            }
        } catch _ {
            print("caught exception creating regex")
        }
    }
}