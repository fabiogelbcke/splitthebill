//
//  splitViewController.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 3/26/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface splitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *totalValue;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property (weak, nonatomic) IBOutlet UITextField *totalPeople;
@property (weak, nonatomic) IBOutlet UILabel *finalValue;
@property (strong, nonatomic) IBOutlet UISwitch *tipIncluded;
@end
