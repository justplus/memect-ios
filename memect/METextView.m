//
//  METextView.m
//  memect
//
//  Created by zhaoliang on 15/3/29.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "METextView.h"

@implementation METextView

- (void)setText:(NSString *)text {
    [super setText:text];
    if (!text) {
        return;
    }
    
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:text];
    //设置属性
    NSDictionary *fullAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil];
    [attributeString addAttributes:fullAttributes range:NSMakeRange(0, [text length])];
    
    //遍历text，利用正则表达式获取所需的字符串，并存在数组里
    //NSString *linkPattern = @"(([http]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))[\\x00-\\xff]";
    NSString *linkPattern = @"http://t.cn/[a-zA-Z0-9]{7}";
    NSArray *linkMatches = [self scanString:linkPattern searchText:text];
    NSString *atPattern = @"@[\\u4e00-\\u9fa5\\w\\-]+";
    NSArray *usernameMatches = [self scanString:atPattern searchText:text];
    NSString *hashtagPattern = @"#([^\\#|.]+)#";
    NSArray *hashtagMatches = [self scanString:hashtagPattern searchText:text];
    //NSString *emojiPattern = @"\\[([^\\#|.]+)\\]";
    //NSArray *emojiMathces = [self scanString:emojiPattern searchText:text];
    
    //为链接添加属性（颜色、字体……）
    NSDictionary *MatchAttr = [[NSDictionary alloc] initWithObjectsAndKeys:
                               tintColor, NSForegroundColorAttributeName,
                               nil];
    
    for (NSString *usernameMatchedString in usernameMatches) {
        NSRange range = [text rangeOfString:usernameMatchedString];
        
        if (range.location != NSNotFound) {
            [attributeString addAttributes:MatchAttr range:range];
            [attributeString addAttribute:NSLinkAttributeName value:usernameMatchedString range:range];
        }
    }
    
    for (NSString *hashtagMatchedString in hashtagMatches) {
        NSRange range = [text rangeOfString:hashtagMatchedString];
        
        if (range.location != NSNotFound) {
            [attributeString addAttributes:MatchAttr range:range];
            [attributeString addAttribute:NSLinkAttributeName value:hashtagMatchedString range:range];
        }
    }
    
    /*for (NSString *emojiMatchedString in emojiMathces) {
        NSRange range = [text rangeOfString:emojiMatchedString];
        
        if (range.location != NSNotFound) {
            [attributeString addAttributes:MatchAttr range:range];
        }
    }*/
    
    
    for (int i=(int)linkMatches.count-1; i >= 0; i--) {
        NSRange range = [text rangeOfString:linkMatches[i]];
        if (range.location != NSNotFound) {
            [attributeString addAttributes:MatchAttr range:range];
            [attributeString addAttribute:NSLinkAttributeName value:linkMatches[i] range:range];
            [attributeString replaceCharactersInRange:range withString:@"☞链接 "];
        }
    }
    
    self.attributedText = attributeString;
}


- (NSMutableArray *)scanString:(NSString *)pattern searchText:(NSString *)searchText {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchResult = [regex matchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length)];
    for (NSTextCheckingResult *r in matchResult) {
        [result addObject:[searchText substringWithRange:r.range]];
    }
    return result;
}

@end
