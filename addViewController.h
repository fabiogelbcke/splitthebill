//
//  addViewController.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/2/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UILabel *addedValue;
@property (strong, nonatomic) IBOutlet UITextField *tipPercentage;
@property (strong, nonatomic) IBOutlet UILabel *perPerson;
@property (strong, nonatomic) IBOutlet UITextField *numberOfPeople;
@property (strong, nonatomic) IBOutlet UIButton *addItem;
@property (strong, nonatomic) IBOutlet UIButton *removeItem;
@property (strong, nonatomic) IBOutlet UITableView *itemTable;
@end
