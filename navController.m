//
//  navController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 5/16/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "navController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "splitAppDelegate.h"

@interface navController ()

@end

@implementation navController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar"]];
    
}
@end
