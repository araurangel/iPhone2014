//
//  PostfixCalculator.m
//  CaculatorHW
//
//  Created by StarJade on 14-11-8.
//  Copyright (c) 2014年 StarJade. All rights reserved.
//


#import "PostfixCalculator.h"

@interface PostfixCalculator ()
- (NSDecimalNumber *) computeOperator:(NSString*) operator
					 withFirstOperand:(NSDecimalNumber*) firstOperand withSecondOperand:(NSDecimalNumber*) secondOperand;
@end

@implementation PostfixCalculator

- (PostfixCalculator*) init{
	self = [super init];
	if (self){
		operators = [NSArray arrayWithObjects: @"+", @"-", @"*", @"/", @"m", nil];	}
	
	return self;
}



- (NSDecimalNumber*) compute:(NSString*) postfixExpression{
	stack = [[SimpleStack alloc] init];
	NSString* strippedExpression = [postfixExpression stringByTrimmingCharactersInSet:
									[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *tokens = [strippedExpression componentsSeparatedByString: @" "];
	
	for(NSString* token in tokens){

		if ([operators containsObject:token]){
			// operator found : unstack 2 operands and use them as operator arguments
			NSDecimalNumber* secondOperand = (NSDecimalNumber*) [stack pop];
     		NSDecimalNumber* firstOperand= (NSDecimalNumber*) [stack pop];

			
			if (! (firstOperand && secondOperand)){
				NSLog(@"Not enough operands on stack for given operator");
				return nil;
			}
			
			// compute result, and push it back on the stack

			NSDecimalNumber * result =  [self computeOperator:token 
											 withFirstOperand: firstOperand 
											withSecondOperand:secondOperand];

			if (result == [NSDecimalNumber notANumber])
				return result; // an error occured during operator calculation, bail early
			
			  [stack push:result];
			
		} else {
			//number found, push it on the stack 
			NSDecimalNumber * operand = [NSDecimalNumber decimalNumberWithString : token];
			[stack push: operand];
		}
	}
	
	
	if ([stack size] != 1){
		NSLog(@"Error : Invalid RPN expression. Stack contains %d elements after computing expression, only one should remain.", 
			  [stack size]);
		return nil;
	} else {
		NSDecimalNumber * result = [stack pop];
		return result;
	}
}

/* private methods */

- (NSDecimalNumber *) computeOperator:(NSString*) operator
					 withFirstOperand:(NSDecimalNumber*) firstOperand withSecondOperand:(NSDecimalNumber*) secondOperand{
	NSDecimalNumber * result;
	
	if ([operator compare: @"+"] == 0) {
		result = [firstOperand decimalNumberByAdding: secondOperand];
	}else if ([operator compare: @"*"] == 0) {
		result = [firstOperand decimalNumberByMultiplyingBy: secondOperand];
	} else if ([operator compare: @"-"] == 0) {
		result = [firstOperand decimalNumberBySubtracting: secondOperand];
	} else if ([operator compare: @"m"] == 0) {
//        a - ((int)(a / b)) * b;
        
        int factor = [[self computeOperator:@"/"
             withFirstOperand: firstOperand
            withSecondOperand:secondOperand] intValue];
        double a = [firstOperand doubleValue];
        double b = [secondOperand doubleValue];
        double r = a - factor * b;
        result = [NSDecimalNumber decimalNumberWithDecimal:
                  [[NSNumber numberWithDouble:r] decimalValue]];
        
	} else if ([operator compare: @"/"] == 0) {
		if ([[NSDecimalNumber zero] compare: secondOperand] == NSOrderedSame){
			NSLog(@"Divide by zero !");
			return [NSDecimalNumber notANumber];
		}
		else 
			result = [firstOperand decimalNumberByDividingBy: secondOperand];	}
	
	return result;
}


@end