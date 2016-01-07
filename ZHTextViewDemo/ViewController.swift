//
//  ViewController.swift
//  ZHTextViewDemo
//
//  Created by Zakk Hoyt on 1/6/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: ZHTextView!
    
    func formatTextView(textView: UITextView, betweenToken: NSString, attributes: NSDictionary){
        let originalSelectedRange = textView.selectedRange
        let attributedText = textView.attributedText
        let token = betweenToken as String
        let pattern = NSString(format: "\\%@([^\\%@]*?)\\%@", token, token, token) as NSString
        
        do {
            let regex = try NSRegularExpression(pattern: pattern as String, options: .CaseInsensitive)

            let allRange = NSMakeRange(0, attributedText.length)
            let matchCount = regex.numberOfMatchesInString(attributedText.string, options: .ReportCompletion, range: allRange)
            
            if matchCount > 0 {
                print("\(matchCount) matches")
                
                if let result = regex.firstMatchInString(attributedText.string, options: .ReportCompletion, range: allRange) {
                    let fullRange = result.range
                    let textString = attributedText.string as NSString
                    let fullSubStr = textString.substringWithRange(fullRange)
                    print("fullSubStr: " + fullSubStr)
                    
                    let prettyRange = NSMakeRange(fullRange.location + 1*betweenToken.length, fullRange.length - 2*betweenToken.length)
                    if prettyRange.length == 0 {
                        return
                    }
                    
                    // Get original attributed text and apply new attributes
                    let prettyAttrString = attributedText.attributedSubstringFromRange(prettyRange).mutableCopy() as! NSMutableAttributedString
                    print("prettyAttrString.string: " + prettyAttrString.string)
                    print("prettyAttrString: " + prettyAttrString.description)
                    // TODO: Find a way to "Stack" attributes instead of replace
                    prettyAttrString.addAttributes(attributes as! [String : AnyObject], range: NSMakeRange(0, prettyAttrString.string.characters.count))
                    
                    
                    // Apply the target attributedString to our whole attributedString
                    let updateAttrString = attributedText.mutableCopy() as! NSMutableAttributedString
                    updateAttrString.deleteCharactersInRange(fullRange)
                    updateAttrString.insertAttributedString(prettyAttrString, atIndex: fullRange.location)
                 
                    // Update textView.text
                    textView.attributedText = updateAttrString
                    
                    // Now set cursor. It will either be at the beginning or end of your entry
                    if(originalSelectedRange.location-1*betweenToken.length == prettyRange.location - 1){
                        //beginning
                        textView.selectedRange = NSMakeRange(fullRange.location, 0)
                    } else {
                        //end
                        textView.selectedRange = NSMakeRange(fullRange.location + prettyAttrString.string.characters.count, 0)
                    }
                }
            }
        } catch _ {
            print("caught exception creating regex")
        }
    }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        if let pointSize = textView.font?.pointSize {
            let boldAttr = [NSFontAttributeName: UIFont.boldSystemFontOfSize(pointSize)]
            formatTextView(textView, betweenToken: "''", attributes: boldAttr)
            
            let italicAttr = [NSFontAttributeName: UIFont.italicSystemFontOfSize(pointSize)]
            formatTextView(textView, betweenToken: "'", attributes: italicAttr)
            
        } else {
            print("Font not set for UITextView")
        }
        
    }
}