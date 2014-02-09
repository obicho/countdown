//
//  TypeTableViewController.h
//  Notification
//
//  Created by Tsai on 1/10/12.
//  Copyright 2012 Space Yak Creative Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol TypeTableViewControllerDelegate;

@class NotificationAppDelegate;

@interface TypeTableViewController : UITableViewController 
<UITableViewDelegate,UITableViewDataSource> {
	
	int type;
	
	NSArray *listData;
	
	NotificationAppDelegate *appDelegate;

}

@property (nonatomic, retain) NSArray *listData;
@property(nonatomic, assign) int type;
// Delegate properties should be weak references - i.e. should use
// assign instead of retain in their property declarations.
@property (nonatomic, assign) id<TypeTableViewControllerDelegate> delegate;

@end

// 3. Definition of the delegate's interface
@protocol TypeTableViewControllerDelegate

-(void)TypeTableViewControllerDidFinish:(NSString *) type;

@end


