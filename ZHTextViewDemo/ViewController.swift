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
        textView.formatText(UITextViewReplacement.SingleAsterisk)
        textView.formatText(UITextViewReplacement.DoubleAsterisk)
    }
}