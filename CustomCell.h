//
//  CustomCell.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/2/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitBillViewController.h"


@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *tickButton;
@property (strong, nonatomic) IBOutlet UILabel *qtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
@property (strong, nonatomic) IBOutlet UILabel *peopleLabel;
-(void)adjustButton:(NSNumber *)isTicked;
@end
