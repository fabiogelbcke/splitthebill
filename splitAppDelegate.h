//
//  splitAppDelegate.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 3/26/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Socialize/Socialize.h"

@interface splitAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *tickArray;
-(void) openSession;

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
