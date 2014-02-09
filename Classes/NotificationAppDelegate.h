//
//  NotificationAppDelegate.h
//  Notification
//
//  Created by Space Yak Creative Lab, LLC

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ImgViewController.h"
#import "Constants.h"

extern NSString *localReceived;

@interface NotificationAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
	UINavigationController *navigationController;
	
	ImgViewController *imgViewController;
	
	NSString *commCategory;
    
    NSString *gMyType;
    
    NSString *gMySound;

	NSMutableData *responseData;


}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *commCategory;
@property (nonatomic, retain) NSString *gMyType;
@property (nonatomic, retain) NSString *gMySound;

- (void)load;
- (void)pushImgView; 

@end

