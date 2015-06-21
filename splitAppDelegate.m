//
//  splitAppDelegate.m
//  Split The Bill
//
//  Created by Fábio Gelbcke Work on 3/26/13.
//  Copyright (c) 2013 Fábio Gelbcke Work. All rights reserved.
//

#import "splitAppDelegate.h"
#import "LoginViewController.h"

@interface splitAppDelegate ()
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) UITabBarController *initialViewController;
@end

@implementation splitAppDelegate{
    UIStoryboard *MainStoryboard;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [FBProfilePictureView class];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self initializeStoryBoardBasedOnScreenSize];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"já ta logado");
        [self openSession];
    }
    else {
        [self showLoginView];
    }
    self.navController.navigationBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar"]];
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initializeStoryBoardBasedOnScreenSize {
    
 
        
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    self.initialViewController = [[UITabBarController alloc] init];
    [[[self initialViewController] tabBar] setBackgroundImage:[UIImage imageNamed:@"bg_tabbar"]];
    
   // [[self initialViewController] tabBar]
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            MainStoryboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
        }
        else if (iOSDeviceScreenSize.height == 568){
            MainStoryboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
        }
            
            // Instantiate the initial view controller object from the storyboard
            
            NSMutableArray
             *listOfViewControllers = [[NSMutableArray alloc] init];
             UIViewController *vc;
            UIViewController *main;
            
             
             main = [MainStoryboard instantiateViewControllerWithIdentifier:@"MainScreen"];
            UIEdgeInsets insets = {
                .top = 3,
                .left = 0,
                .bottom = -3,
                .right = 0
            };
            main.tabBarItem.title=@"";
            main.tabBarItem.imageInsets = insets;
            [[main tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_splitthebill_selecionado"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_splitthebill"]];
             [listOfViewControllers addObject:main];
             vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"Calculator"];
            vc.tabBarItem.imageInsets= insets;
            [[vc tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_calculator_selecionado"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_calculator"]];
            vc.tabBarItem.title=@"";
             [listOfViewControllers addObject:vc];
             UIViewController *navRootView = [MainStoryboard instantiateViewControllerWithIdentifier:@"NavRootView"];
             self.navController = [[UINavigationController alloc]
                                  initWithRootViewController:navRootView];
            self.navController.tabBarItem.imageInsets=insets;
            [[[self navController] tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_sharephotos_selecionado"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_sharephotos"]];
            [self.navController setNavigationBarHidden:YES];
             [listOfViewControllers addObject:_navController];
             
             [self.initialViewController setViewControllers:listOfViewControllers
             animated:YES];
            [[[self initialViewController] tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"selected_tabbar"]];
            
            

            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = _initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        //}
        
                
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self.navController popToRootViewControllerAnimated:YES];
            
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *presentedViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![presentedViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [MainStoryboard instantiateViewControllerWithIdentifier:@"loginView"];
        [self.navController pushViewController:loginViewController animated:NO];
    } else {
        LoginViewController* loginViewController =
        (LoginViewController*)presentedViewController;
        [loginViewController loginFailed];
    }
}

- (void)openSession {
    [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        default:
            return @"[Unknown]";
    }
}

@end
