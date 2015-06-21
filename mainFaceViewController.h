//
//  mainFaceViewController.h
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 6/10/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface mainFaceViewController : UIViewController <FBFriendPickerDelegate, FBUserSettingsDelegate>
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *selectedFriendsLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedPlaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *whereButton;
@property (weak, nonatomic) IBOutlet UIButton *whoButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIButton *post2;


@end
