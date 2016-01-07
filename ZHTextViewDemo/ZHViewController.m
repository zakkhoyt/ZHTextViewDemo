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

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// Single ' = italic
// double '' = bold

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

            // Get original attr text: bolded 'test'
            NSMutableAttributedString *prettyAttrString = [[attributedText attributedSubstringFromRange:prettyRange] mutableCopy];
            NSLog(@"prettyAttrString.string: %@", prettyAttrString.string);
            NSLog(@"prettyAttrString: %@", prettyAttrString);
            [prettyAttrString addAttributes:attributes range:NSMakeRange(0, prettyAttrString.string.length)];
            
            // Apply the new formatting
            NSMutableAttributedString *updateAttrString = [attributedText mutableCopy];
            [updateAttrString deleteCharactersInRange:fullRange];
            [updateAttrString insertAttributedString:prettyAttrString atIndex:fullRange.location];
            return updateAttrString;
            
        } else {
            NSLog(@"Error applying regex: %@", error.localizedDescription);
        }
    }
    
    return nil;
}



//-(NSAttributedString*)formatText:(NSString*)text betweenToken:(NSString*)token attributes:(NSDictionary*)attributes {
//    NSError *error = nil;
//    NSString *pattern = [NSString stringWithFormat:@"\%@([^\%@]*?)\%@", token, token, token];
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
//                                                                               options:NSRegularExpressionCaseInsensitive
//                                                                                 error:&error];
//
//    NSRange fullRange = NSMakeRange(0, text.length);
//
//    NSUInteger boldMatchCount = [regex numberOfMatchesInString:text options:NSMatchingReportCompletion range:fullRange];
//
//    if(boldMatchCount > 0) {
//        NSLog(@"%lu matches", (unsigned long)boldMatchCount);
//
//        NSTextCheckingResult *result = [regex firstMatchInString:text options:NSMatchingReportCompletion range:fullRange];
//        if(result) {
//            NSRange fullRange = result.range;
//            NSString *fullSubStr = [text substringWithRange:fullRange];
//            NSLog(@"fullSubStr: %@", fullSubStr);
//
//            NSRange prettyRange = NSMakeRange(fullRange.location + 1*token.length, fullRange.length - 2*token.length);
//            NSString *prettySubStr = [text substringWithRange:prettyRange];
//            NSLog(@"prettySubStr: %@", prettySubStr );
//
//            if(prettyRange.length == 0) {
//                return nil;
//            }
//
//            NSMutableString *newString = [[NSMutableString alloc]initWithString:text];
//            [newString replaceCharactersInRange:fullRange withString:prettySubStr];
//
//            NSRange attrRange = NSMakeRange(fullRange.location, fullRange.length - 2*token.length);
//
//            NSMutableAttributedString *newAttrString = [[NSMutableAttributedString alloc]initWithString:newString];
//            [newAttrString addAttributes:attributes range:attrRange];
//
//            return newAttrString;
//        } else {
//            NSLog(@"Error");
//        }
//    } else {
//        NSLog(@"No matches");
//    }
//
//    return nil;
//}


@end
