//
//  NavItem.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 7/9/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "NavItem.h"

@implementation NavItem

-(id)init{
    self = [super init];
    
    UIButton *lbt=[UIButton buttonWithType:UIButtonTypeCustom];
    [lbt setFrame:CGRectMake(0, 0, 15, 30)];
    [lbt setImage:[UIImage imageNamed:@"botao_lixeira"] forState:UIControlStateNormal];
    [lbt addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:lbt];
    self.leftBarButtonItem=leftButton;
    UIButton *rbt=[UIButton buttonWithType:UIButtonTypeCustom];
    [rbt setFrame:CGRectMake(0, 0, 15, 30)];
    [rbt setImage:[UIImage imageNamed:@"botao_mais"] forState:UIControlStateNormal];
    [rbt addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithCustomView:rbt];
    self.rightBarButtonItem=rightButton;
    
    NSLog(@"ae");
    
    return self;
}

@end
