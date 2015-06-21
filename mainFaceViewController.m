//
//  mainFaceViewController.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 6/10/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "mainFaceViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import "TargetConditionals.h"

@interface mainFaceViewController ()< UITableViewDataSource,
UIImagePickerControllerDelegate,
FBFriendPickerDelegate,
UINavigationControllerDelegate,
FBPlacePickerDelegate,
CLLocationManagerDelegate,
UIActionSheetDelegate>

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSArray* selectedFriends;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *frame;
@property (strong, nonatomic) NSObject<FBGraphPlace> *selectedPlace;
@property (strong, nonatomic) FBCacheDescriptor *placeCacheDescriptor;
@property (strong, nonatomic) UIImage *foodPicture;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UILabel *photoLabel;

@end

@implementation mainFaceViewController{
    
    int n;
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self.whereButton addSubview:self.selectedPlaceLabel];
    [self.whoButton addSubview:self.selectedFriendsLabel];
    [self.userProfileImage addSubview:self.frame];
    [self updateSelections];

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To check into PLACES you must allow the app to use your current location" message:@"Go to Settings -> Privacy -> Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)viewDidLoad{
    
    self.selectedFriends = [[NSArray alloc] init];
   if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
               n=0;
    }
    self.userName.text=@"";
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    [self setNeedsStatusBarAppearanceUpdate];
    }

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.userName.font = [UIFont fontWithName:@"Bariol_Regular" size:17];
                 self.userName.text = [user.name uppercaseString];
                 self.userProfileImage.profileID = user.id;
             }
         }];
    }
}
- (IBAction)selectFriends:(id)sender {
    

    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        self.friendPickerController.title = @"Select friends";
        self.friendPickerController.delegate=self;
        self.friendPickerController.doneButton.target=self;
        [self.friendPickerController.doneButton setAction:@selector(doneButtonPressed)];
    }
    
    [self.friendPickerController loadData];
   

    [self.friendPickerController presentModallyFromViewController:self
                                                         animated:YES
                                                          handler:^(FBViewController *sender, BOOL donePressed) {
                                                              if (donePressed) {
                                                                  self.selectedFriends = self.friendPickerController.selection;
                                                                  [self updateSelections];
                                                              }
                                                          }];
}

-(void)doneButtonPressed{
    n=1;
    [self updateSelections];
    
    
}
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    n=1;
    self.selectedFriends = friendPicker.selection;
    [self updateSelections];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // FBSample logic
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url];
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
            NSLog(@"Got location: %f, %f",
                  newLocation.coordinate.latitude,
                  newLocation.coordinate.longitude);
        }
    
    [self setPlaceCacheDescriptorForCoordinates:newLocation.coordinate];
    [self.placeCacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
}

- (IBAction)wherePressed:(id)sender {
    if (!self.placePickerController) {
        self.placePickerController = [[FBPlacePickerViewController alloc]
                                      initWithNibName:nil bundle:nil];
        self.placePickerController.title = @"Select a Place";
    }
    self.placePickerController.locationCoordinate =
    self.locationManager.location.coordinate;
    self.placePickerController.radiusInMeters = 2500;
    self.placePickerController.resultsLimit = 300;
    
    [self.placePickerController loadData];
    [self.placePickerController presentModallyFromViewController:self
                                                         animated:YES
                                                          handler:^(FBViewController *sender, BOOL donePressed) {
                                                              if (donePressed) {
                                                                  if(self.placePickerController.selection)
                                                                  self.selectedPlace = (NSDictionary<FBGraphPlace>*)self.placePickerController.selection;
                                                                  else self.selectedPlace = nil;

                                                                    [self updateSelections];
                                                              }
                                                          }];
}

- (void)setPlaceCacheDescriptorForCoordinates:(CLLocationCoordinate2D)coordinates {
    self.placeCacheDescriptor =
    [FBPlacePickerViewController cacheDescriptorWithLocationCoordinate:coordinates
                                                        radiusInMeters:2500
                                                            searchText:@"restaurant bar coffee cafe pub"
                                                          resultsLimit:50
                                                      fieldsForRequest:nil];
}

- (IBAction)uploadPhoto {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an option"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Take Photo"];
    [actionSheet addButtonWithTitle:@"Choose Existing"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    if (buttonIndex==0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==1){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];

    }
}



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.foodPicture = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)post:(UIButton *)sender {
    if (!self.selectedPlace && !self.foodPicture){
        [self postIncomplete];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post to Facebook?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
  [alert show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    if(buttonIndex==1){
          [self post2:nil];
        
    }
    
}

-(NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = paths[0];
    return documentsDirectoryPath;
}


- (void)updateSelections {
    self.selectedPlaceLabel.text= (self.selectedPlace ?
                                self.selectedPlace.name :
                                @"");
    if ([self.selectedPlaceLabel.text isEqualToString: @""]) {
        [self.whereButton setBackgroundImage:[UIImage imageNamed:@"celula_where"] forState:UIControlStateNormal];
    }
    else {[self.whereButton setBackgroundImage:[UIImage imageNamed:@"celula_where2"] forState:UIControlStateNormal];
    }

    NSString *friendsSubtitle = @"";
    int friendCount = self.selectedFriends.count;
    if (friendCount > 2) {
        id<FBGraphUser> randomFriend = self.selectedFriends[arc4random() % friendCount];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %d others", randomFriend.name, friendCount - 1];
    } else if (friendCount == 2) {
        id<FBGraphUser> friend1 = self.selectedFriends[0];
        id<FBGraphUser> friend2 = self.selectedFriends[1];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %@", friend1.name, friend2.name];
    } else if (friendCount == 1) {
        id<FBGraphUser> friend = self.selectedFriends[0];
        friendsSubtitle = friend.name;
    }
    self.selectedFriendsLabel.text=friendsSubtitle;
    
    if ([friendsSubtitle isEqualToString:@""]) {
        [self.whoButton setBackgroundImage:[UIImage imageNamed:@"celula_who"] forState:UIControlStateNormal];
        NSLog(@"1");
    }
    else {[self.whoButton setBackgroundImage:[UIImage imageNamed:@"celula_who2"] forState:UIControlStateNormal];
        NSLog(@"2");
    }
    
if(self.foodPicture){
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"celula_photo2"] forState:UIControlStateNormal];
    self.photoLabel.text=@"Photo Chosen!";
    
}
else {
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"celula_photo"] forState:UIControlStateNormal];
    self.photoLabel.text=@"";
}
}
- (IBAction)post2:(id)sender {
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions", nil];
        [FBSession.activeSession requestNewPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 [self post2:sender];
                 return;
                 // If permissions granted, publish the story
                 
             }
         }];
    }
     else {
         self.postButton.enabled=NO;
    NSString *apiPath = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    if (self.foodPicture)apiPath = @"me/photos";
    else apiPath= @"me/feed";
    if(self.selectedPlace.id) {
        [params setObject:self.selectedPlace.id forKey:@"place"];
    }
    NSString *tag  = nil;
        if(self.selectedFriends != nil){
            for (NSDictionary *user in self.selectedFriends) {
                if(self.foodPicture)tag = [[NSString alloc] initWithFormat:@"{\"tag_uid\":\"%@\"}",[user objectForKey:@"id"] ];
            else tag = [[NSString alloc] initWithFormat:@"'%@'",[user objectForKey:@"id"] ];
                [tags addObject:tag];
            }
            NSString *friendIdsSeparation=[tags componentsJoinedByString:@","];
            NSString *friendIds = [[NSString alloc] initWithFormat:@"[%@]",friendIdsSeparation ];        [params setObject:friendIds forKey:@"tags"];
        }
    if (self.foodPicture){
        [params setObject:self.foodPicture forKey:@"picture"];
    }
    FBRequest *request = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:apiPath parameters:params HTTPMethod:@"POST"];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (error) {
            self.postButton.enabled=YES;
            NSString *errorString;
            NSLog(@"Error ===== %@",error.description);
            if(!self.foodPicture && !tag && !self.selectedPlace) errorString=@"To post to Facebook you must select a PLACE or upload a PHOTO";
            else if (!self.foodPicture && !self.selectedPlace) errorString=@"To post to Facebook you must select a PLACE or upload a PHOTO";
            else errorString = @"Could not post to Facebook";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            NSLog(@"posted!");
            self.postButton.enabled=YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posted!" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.foodPicture=nil;
            self.selectedPlace=nil;
            self.selectedFriends=nil;
            self.placePickerController = [[FBPlacePickerViewController alloc] init];
            self.friendPickerController = [[FBFriendPickerViewController alloc] init];
            [self updateSelections];
            }
    }];}
}


-(void)postIncomplete{
    NSString *errorString;
    if(!self.foodPicture && !self.selectedFriends && !self.selectedPlace) errorString=@"To post to Facebook you must select a PLACE or upload a PHOTO";
    else if (!self.foodPicture && !self.selectedPlace) errorString=@"To post to Facebook you must select a PLACE or upload a PHOTO";
    else errorString = @"Could not post to Facebook";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

    
}

@end
