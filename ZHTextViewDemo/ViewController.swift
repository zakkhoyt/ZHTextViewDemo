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
    
    func formatAttributedText(attributedText: NSAttributedString, betweenToken: NSString, attributes: NSDictionary) -> NSAttributedString? {
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
                        return nil
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
                 
                    // Append a space to the end with no formatting. This allows the user to keep typing like normal.
                    let space = NSAttributedString(string: " ")
                    updateAttrString.appendAttributedString(space)
                    
                    return updateAttrString
                }
            }
        } catch _ {
            print("caught exeption creating regex")
        }
        return nil
    }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        
        if let pointSize = textView.font?.pointSize {
            let boldAttr = [NSFontAttributeName: UIFont.boldSystemFontOfSize(pointSize)]
            if let boldAttrText = formatAttributedText(textView.attributedText, betweenToken: "''", attributes: boldAttr) {
                textView.attributedText = boldAttrText;
            }
            
            let italicAttr = [NSFontAttributeName: UIFont.italicSystemFontOfSize(pointSize)]
            if let italicAttrText = formatAttributedText(textView.attributedText, betweenToken: "'", attributes: italicAttr) {
                textView.attributedText = italicAttrText;
            }
        }
    }
}