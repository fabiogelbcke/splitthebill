//
//  CalculatorViewController.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 5/3/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>
//operações limitadas em um caractere a menos


@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *displayOperation;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end
