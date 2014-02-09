     //
//  RootViewController.h
//  Notification
//
//  Created by Space Yak Creative Lab, LLC
//

#import <UIKit/UIKit.h>
#import "SetNotificationViewController.h"
#import "Constants.h"

@interface RootViewController : UITableViewController<SetNotificationDelegate> {
	NSMutableArray *notificationsArray;
}

- (IBAction) EditTable:(id)sender;

@property (nonatomic, retain) NSMutableArray *notificationsArray;

- (NSString *)getCountdownString:(NSDate *) fireDate;

@end
