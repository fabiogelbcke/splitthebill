//
//  CustomCell.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 4/2/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "CustomCell.h"
@interface CustomCell()
@end

@implementation CustomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {self.valueLabel = [[UILabel alloc]init];
        
        self.selectedImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.selectedImage];
        
        
        
        self.tickButton.selected=YES;
        
    }
    return self;
}

-(void)adjustButton:(NSNumber *)isTicked{
    if ( isTicked == [NSNumber numberWithInt:1]) {
        [self.tickButton setImage:[UIImage imageNamed:@"check_selecionado"] forState:UIControlStateSelected];
    }
    else {
        [self.tickButton setImage:[UIImage imageNamed:@"check_vazio"] forState:UIControlStateDisabled];
    }
}







@end
