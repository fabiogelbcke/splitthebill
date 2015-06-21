//
//  CalculatorBrain.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 5/3/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorBrain : NSObject
-(void) pushOperand: (double) operand;
-(double) popOperand;
-(double) performOperation:(NSString *) operation;
@property (nonatomic,strong) NSMutableArray *operandStack;
@end
