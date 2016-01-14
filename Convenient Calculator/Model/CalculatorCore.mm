//
//  CalculatorCore.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/14.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "CalculatorCore.h"
#include "Eval.hpp"

@implementation CalculatorCore

- (NSString *)calByExpressionString:(NSString *)expressionString {
    for (int i = 0; i < expressionString.length; i++) {
        unichar c = [expressionString characterAtIndex:i];
        if (c == 215) {
            expressionString = [expressionString stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
        if (c == 247) {
            expressionString = [expressionString stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"/"];
        }
    }
    NSLog(@"%@", expressionString);
    std::string cppExpression([expressionString UTF8String]);
    std::string cppStringResult = eval(cppExpression);
    NSString *result = [NSString stringWithUTF8String:cppStringResult.c_str()];
    return result;
}

@end
