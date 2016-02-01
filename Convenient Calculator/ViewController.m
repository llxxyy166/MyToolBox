//
//  ViewController.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/14.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorCore.h"
#import "TMDb.h"
@interface ViewController ()
@property (strong, nonatomic) CalculatorCore *core;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *display;
@property (nonatomic) BOOL displayingResult;
@property (nonatomic) BOOL newNumber;
@property (nonatomic) NSInteger openParenthesis;


@end

@implementation ViewController

- (CalculatorCore *)core {
    if (!_core) {
        _core = [[CalculatorCore alloc] init];
    }
    return _core;
}

- (void)setDisplay:(NSString *)display {
    _display = display;
    self.resultLabel.text = display;
}

- (BOOL)isOperator: (NSString *)string {
    NSArray *op = @[@"+", @"-", @"×", @"÷"];
    for (NSString *opString in op) {
        if ([string isEqualToString:opString]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isNumber: (NSString *)string {
    NSString *numberString = @"0123456789";
    return [numberString containsString:string];
}

- (void)clear {
    self.display = @"0";
    self.displayingResult = NO;
    self.openParenthesis = 0;
    self.newNumber = YES;
}

- (IBAction)inputsButtonAction:(UIButton *)sender {
    NSString *current = sender.currentTitle;
    if ([current isEqualToString:@")"] && !self.openParenthesis) {
        return;
    }
    if ([current isEqualToString:@"."] && !self.newNumber) {
        return;
    }
    if ([self.display isEqualToString:@"error"]) {
        [self clear];
    }
    if (![self isOperator:current] && self.displayingResult) {
        self.display = @"0";
    }
    if (![self isOperator:current] && [self.display isEqualToString:@"0"]) {
        self.display = @"";
    }
    if ([current isEqualToString:@"("]) {
        self.openParenthesis ++;
    }
    self.displayingResult = NO;
    self.display = [self.display stringByAppendingString:current];
    if ([current isEqualToString:@")"]) {
        self.openParenthesis--;
    }
    if (![self isNumber:current]) {
        self.newNumber = YES;
    }
    if ([current isEqualToString:@"."]) {
        self.newNumber = NO;
    }
}
- (IBAction)enterAction:(UIButton *)sender {
    NSString *result = [self.core calByExpressionString:self.display];
    self.display = result;
    self.displayingResult = YES;
    self.newNumber = YES;
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clear];
    // Do any additional setup after loading the view, typically from a nib.
}



@end
