//
//  ViewController.swift
//  ZHTextViewDemo
//
//  Created by Zakk Hoyt on 1/6/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        if let pointSize = textView.font?.pointSize {
            let boldAttr = [NSFontAttributeName: UIFont.boldSystemFontOfSize(pointSize)]
            textView.formatText("**", attributes: boldAttr)
            
            let italicAttr = [NSFontAttributeName: UIFont.italicSystemFontOfSize(pointSize)]
            textView.formatText("*", attributes: italicAttr)
            
        } else {
            print("Font not set for UITextView")
        }
    }
}