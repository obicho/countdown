//
//  SetNotificationViewController.h
//  Notifier
//
//  Created by Space Yak Creative Lab, LLC
//

#import <UIKit/UIKit.h>
#import "TypeTableViewController.h"
#import "SoundTableViewController.h"
#import "Constants.h"

@protocol SetNotificationDelegate;

@class NotificationAppDelegate;

@interface SetNotificationViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, TypeTableViewControllerDelegate, SoundTableViewControllerDelegate> {
	id<SetNotificationDelegate> delegate;
	
	UIDatePicker *datePicker;
	
	UITextField *messageField;
	
	NSArray *listData;
	
	IBOutlet UITableView *prefTableView;
	
	NotificationAppDelegate *appDelegate;
	
}

@property (nonatomic, assign) id<SetNotificationDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) UITableView *prefTableView;

- (void)cancelAddNotification;
- (void)addNotification;
- (IBAction)dismissKeyboard;

@end

@protocol SetNotificationDelegate <NSObject>

- (void)dismissSetNotificationViewController;

@end
