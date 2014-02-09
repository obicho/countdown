//
//  SoundImageTableViewController.h
//  Notification
//
//  Created by Tsai on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SoundImageTableViewController : UITableViewController 
	<UITableViewDelegate,UITableViewDataSource> {
		NSArray *listData;
}

@property(nonatomic, retain) NSArray *listData;

	
@end
