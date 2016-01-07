//
//  ZHTextView.swift
//  ZHTextViewDemo
//
//  Created by Zakk Hoyt on 1/6/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

//    override func layoutSubviews() {
////            [_shutterButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//    }

    override func textInRange(range: UITextRange) -> String? {
        print("Text: " + self.text)
        return "here"
    }
    override func replaceRange(range: UITextRange, withText text: String) {
        print("here")
    }
}

//public protocol UITextViewDelegate : NSObjectProtocol, UIScrollViewDelegate {
//    
//    @available(iOS 2.0, *)
//    optional public func textViewShouldBeginEditing(textView: UITextView) -> Bool
//    @available(iOS 2.0, *)
//    optional public func textViewShouldEndEditing(textView: UITextView) -> Bool
//    
//    @available(iOS 2.0, *)
//    optional public func textViewDidBeginEditing(textView: UITextView)
//    @available(iOS 2.0, *)
//    optional public func textViewDidEndEditing(textView: UITextView)
//    
//    @available(iOS 2.0, *)
//    optional public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
//    @available(iOS 2.0, *)
//    optional public func textViewDidChange(textView: UITextView)
//    
//    @available(iOS 2.0, *)
//    optional public func textViewDidChangeSelection(textView: UITextView)
//    
//    @available(iOS 7.0, *)
//    optional public func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool
//    @available(iOS 7.0, *)
//    optional public func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool
//}

extension ZHTextView: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        print("SDF")
    }
}
