//
//  mealModel.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 8/10/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MealModel : UINavigationItem

@property (strong, nonatomic) NSString *objectId;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSArray *selectedFriends;
@property (strong, nonatomic) id<FBGraphPlace> selectedPlace;
@property (strong, nonatomic) NSString *selectedPlaceName;
@property (nonatomic, copy) NSString* imageName;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSArray *location;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *determiner;

+ (NSString *)generateUuidString;

@end
