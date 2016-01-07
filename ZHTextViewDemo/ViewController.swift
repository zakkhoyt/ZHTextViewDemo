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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        print(": " + textView.text)
        
        do {
            let regex = try NSRegularExpression(pattern: "\'([^\']*?)\'", options: .CaseInsensitive)
            let match = regex.numberOfMatchesInString(textView.text, options: .ReportCompletion, range: NSMakeRange(0, textView.text.characters.count))
            if match > 0 {
                // Get string for first match
                if let first = regex.firstMatchInString(textView.text, options: .ReportCompletion, range: NSMakeRange(0, textView.text.characters.count)) {
                    let fullString = textView.text as NSString
                    
                    let subStringRange = first.range
                    let replacementRange = NSMakeRange(subStringRange.location + 1, subStringRange.length - 2)
                    
                    if let subString = fullString.substringWithRange(subStringRange) as? NSString {
                        if let trimmedSubstring = subString.substringWithRange(NSMakeRange(1, subString.length - 2)) as? NSString {
                            print("match: " + (subString as String) + " " + (trimmedSubstring as String))
                            
                            let pointSize = (textView.font?.pointSize)! // using ! is naughty but we can get by here else this delegate method wouldn't be called if it werent' set
                            let attr = [NSFontAttributeName: UIFont.boldSystemFontOfSize(pointSize)]
                            
                            
                            
                            let replacement = NSAttributedString(string: trimmedSubstring as String, attributes: attr)
                            let outputString  = NSMutableAttributedString(attributedString: textView.attributedText)
//                            outputString.mutableString.replaceOccurrencesOfString(subString as String, withString: replacement, options: .CaseInsensitiveSearch, range: NSMakeRange(0, outputString.length))

                            print("examine")
//                            textView.attributedText = replacement
                            
                        }
                        
                    }


//                    let trimedSubstring = subString.substringWithRange(0..<subString.characters.count - 2)
                
                }
                
            } else {
                print("no matches")
            }
            
        } catch _ {
            print("Bad regex")
        }
        
        
        
    }
}