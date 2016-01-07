//
//  UITextView+Asterisk.swift
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

enum UITextViewReplacement: UInt {
    case SingleAsterisk = 0
    case DoubleAsterisk = 1
    
    var token: NSString {
        switch self {
        case .SingleAsterisk:
            return "*"
        case .DoubleAsterisk:
            return "**"
        }
    }
    
    var pattern: NSString {
        switch self {
        case .SingleAsterisk:
            return "\\*([^\\*]*?)\\*"
        case .DoubleAsterisk:
            return "\\*\\*([^\\*\\*]*?)\\*\\*"
        }
    }
    
    var attributes: NSDictionary {
        switch self {
        case .SingleAsterisk:
            return [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)]
        case .DoubleAsterisk:
            return [NSFontAttributeName: UIFont.italicSystemFontOfSize(14)]
        }
        
    }
}

extension UITextView {
    
    
    func formatText(replacement: UITextViewReplacement) {
        
        let originalSelectedRange = self.selectedRange
        let attributedText = self.attributedText
        
        let token = replacement.token
        let pattern = replacement.pattern
        let attributes = replacement.attributes
        
        do {
            let regex = try NSRegularExpression(pattern: pattern as String, options: .CaseInsensitive)
            let allRange = NSMakeRange(0, attributedText.length)
            regex.enumerateMatchesInString(attributedText.string, options: .ReportCompletion, range: allRange, usingBlock: { (result: NSTextCheckingResult?, flags: NSMatchingFlags, pointer: UnsafeMutablePointer<ObjCBool>) -> Void in
                if let result = result {
                    let fullRange = result.range
                    
                    let prettyRange = NSMakeRange(fullRange.location + 1*token.length, fullRange.length - 2*token.length)
                    if prettyRange.length == 0 {
                        return
                    }
                    
                    // Get original attributed text and apply new attributes
                    let prettyAttrString = attributedText.attributedSubstringFromRange(prettyRange).mutableCopy() as! NSMutableAttributedString
                    prettyAttrString.addAttributes(attributes as! [String : AnyObject], range: NSMakeRange(0, prettyAttrString.string.characters.count))
                    
                    // If cursor is at end of sequence, append a space with no formatting
                    var cursor = UITextViewCursorPosition.Front
                    if fullRange.location + fullRange.length == originalSelectedRange.location {
                        // end
                        cursor = .Back
                        if let pointSize = self.font?.pointSize {
                            let space = NSAttributedString(string: " ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(pointSize)])
                            prettyAttrString.appendAttributedString(space)
                        } else {
                            print("Warning: Font not set")
                        }
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
            })
        } catch _ {
            print("caught exception creating regex")
        }
    }
}