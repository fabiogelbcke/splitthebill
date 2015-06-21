//
//  CalculatorBrain.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 5/3/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@end

@implementation CalculatorBrain

-(NSMutableArray *) operandStack{
    if(!_operandStack){
        _operandStack=[[NSMutableArray alloc] init];
    }
    return _operandStack;
}

-(void) pushOperand:(double)operand{
    
    NSNumber * operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
    
}

-(double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject)[self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

-(double) performOperation:(NSString *)operation{
    
    double result = 0;
    
    if([operation isEqualToString:@"+"]){
        result= [self popOperand] + [self popOperand];
    }
    else if([operation isEqualToString:@"*"]){
        double factor1 = [self popOperand];
        double factor2 = [self popOperand];
        result=factor1*factor2;
    }
    else if([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    else if([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        double dividend = [self popOperand];
        NSLog(@"%8lf", dividend/divisor);
        double oi = dividend/divisor;
        if (ceilf(dividend/divisor) == dividend/divisor){
            result = dividend/divisor;
        }
        else{
            NSString *resultString = [NSString stringWithFormat:@"%.02lf",oi];
            while ([[resultString substringFromIndex:resultString.length-1] isEqualToString:@"0"]) resultString=[resultString substringToIndex:resultString.length-1];
            result = [resultString doubleValue];
        }
    }
    [self pushOperand:result];
    return result;
}



@end
