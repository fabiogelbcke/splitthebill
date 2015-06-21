//
//  SplitBillViewController.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/25/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitBillViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *perPerson;
@property (strong, nonatomic) IBOutlet UITextField *tipPercentage;
@property (strong, nonatomic) IBOutlet UITableView *itemTable;

@end
