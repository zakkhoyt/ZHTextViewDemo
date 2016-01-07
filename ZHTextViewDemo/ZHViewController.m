//
//  ZHViewController.m
//  ZHTextViewDemo
//
//  Created by Zakk Hoyt on 1/6/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

#import "ZHViewController.h"

@interface ZHViewController () <UITextViewDelegate>

@end

@implementation ZHViewController


- (void)textViewDidChange:(UITextView *)textView {
    NSDictionary *boldAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:textView.font.pointSize]};
    NSAttributedString *boldText = [self formatAttributedText:textView.attributedText betweenToken:@"''" attributes:boldAttr];
    if(boldText) {
        textView.attributedText = boldText;
    }

    NSDictionary *italicAttr = @{NSFontAttributeName: [UIFont italicSystemFontOfSize:textView.font.pointSize]};
    NSAttributedString *italicText = [self formatAttributedText:textView.attributedText betweenToken:@"'" attributes:italicAttr];
    if(italicText) {
        textView.attributedText = italicText;
    }
}


-(NSAttributedString*)formatAttributedText:(NSAttributedString*)attributedText betweenToken:(NSString*)token attributes:(NSDictionary*)attributes {
    NSError *error = nil;
    NSString *pattern = [NSString stringWithFormat:@"\%@([^\%@]*?)\%@", token, token, token];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSRange fullRange = NSMakeRange(0, attributedText.length);
    
    // TODO enumerateMatchesIn...
    NSUInteger boldMatchCount = [regex numberOfMatchesInString:attributedText.string options:NSMatchingReportCompletion range:fullRange];
    
    if(boldMatchCount > 0) {
        NSLog(@"%lu matches", (unsigned long)boldMatchCount);
        
        NSTextCheckingResult *result = [regex firstMatchInString:attributedText.string options:NSMatchingReportCompletion range:fullRange];
        if(result) {
            NSRange fullRange = result.range;
            NSString *fullSubStr = [attributedText.string substringWithRange:fullRange];
            NSLog(@"fullSubStr: %@", fullSubStr);
            
            NSRange prettyRange = NSMakeRange(fullRange.location + 1*token.length, fullRange.length - 2*token.length);
            
            if(prettyRange.length == 0) {
                return nil;
            }

            // Get original attributed text and apply new attributes
            NSMutableAttributedString *prettyAttrString = [[attributedText attributedSubstringFromRange:prettyRange] mutableCopy];
            NSLog(@"prettyAttrString.string: %@", prettyAttrString.string);
            NSLog(@"prettyAttrString: %@", prettyAttrString);
            // TODO: Find a way to "stack" attributes. There doesn't seem to be a simple way to do that.
            [prettyAttrString addAttributes:attributes range:NSMakeRange(0, prettyAttrString.string.length)];
            
            // Apply the target attributedString to our whole attributedString
            NSMutableAttributedString *updateAttrString = [attributedText mutableCopy];
            [updateAttrString deleteCharactersInRange:fullRange];
            [updateAttrString insertAttributedString:prettyAttrString atIndex:fullRange.location];
            
            // Append a space to the end with no formatting. This allows the user to keep typing like normal.
            NSAttributedString *space = [[NSAttributedString alloc]initWithString:@" " attributes:nil];
            [updateAttrString appendAttributedString:space];
            
            return updateAttrString;
            
        } else {
            NSLog(@"Error applying regex: %@", error.localizedDescription);
        }
    }
    
    return nil;
}

@end
