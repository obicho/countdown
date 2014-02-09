//
//  RootViewController.m
//  Notification
//
//  Created by Space Yak Creative Lab, LLC
//

#import "RootViewController.h"
#import "SetNotificationViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

@synthesize notificationsArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	UINavigationBar *bar = [self.navigationController navigationBar];
	
	UIImage *image = [UIImage imageNamed: @"countdownAppLogo.png"];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
	
	self.navigationItem.titleView = imageView;
	
	[imageView release];
	
	// navigation bar color
	[bar setTintColor:[UIColor colorWithRed:kNavBarColorR green:kNavBarColorG blue:kNavBarColorB alpha:1.0]];
	
	// table color
	self.tableView.separatorColor = [UIColor colorWithRed:kSepColorR green:kSepColorG blue:kSepColorB alpha:1.0];
	
	self.title = @"Countdown";
	
	UIBarButtonItem *addNotificationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNotification)];
	
	self.navigationItem.rightBarButtonItem = addNotificationButton;
	
	[addNotificationButton release];
	
	//self.notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	self.notificationsArray = [[[[UIApplication sharedApplication] scheduledLocalNotifications] 
                                mutableCopy] autorelease];
    
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	
	[self.navigationItem setLeftBarButtonItem:editButton];
	
	[editButton release];
	
}

- (IBAction) EditTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
		
		[self.tableView setEditing:NO animated:NO];
		
		[self.tableView reloadData];
		
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	
	}
	
	else
	
	{
		
		[super setEditing:YES animated:YES];
	
		[self.tableView setEditing:YES animated:YES];
		
		[self.tableView reloadData];
		
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	
	}
}


+(UINavigationController*) myCustomNavigationController
{
	RootViewController *vc = [[[RootViewController alloc] init] autorelease];
	UINavigationController *nav = [[[NSBundle mainBundle] loadNibNamed:@"CustomNavigationController" owner:self options:nil] objectAtIndex:0];
	nav.viewControllers = [NSArray arrayWithObject:vc];
	return nav;
}



// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {

		UILocalNotification *toBeRemovedLocalNotif = [self.notificationsArray objectAtIndex:indexPath.row]; 
		
		[[UIApplication sharedApplication] cancelLocalNotification:toBeRemovedLocalNotif];
		
		[self.notificationsArray removeObjectAtIndex:indexPath.row];
		
		[self.tableView reloadData];
				
		NSArray *eventArray =[ [ UIApplication sharedApplication ] scheduledLocalNotifications ];
		
		for (int i=0; i<[eventArray count]; i++)
		{
			UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
			
			NSLog(@"LocalNoti: %@",oneEvent.alertBody);
			NSLog(@"%@", oneEvent.userInfo);
				
		}
		
	}
		
}



#pragma mark -
#pragma mark Class Methods

- (void)addNotification {
	
	SetNotificationViewController *setNotificationViewController = [[SetNotificationViewController alloc] initWithNibName:@"SetNotificationViewController" bundle:nil];
	
	[setNotificationViewController setDelegate:self];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:setNotificationViewController];
	
	[setNotificationViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	
}


#pragma mark -
#pragma mark SetNotificationViewController Delegate Methods

//dismisses the modal view controller
- (void)dismissSetNotificationViewController {
	
	//reload the notifications array and table view
//	self.notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	
    self.notificationsArray = [[[[UIApplication sharedApplication] scheduledLocalNotifications] 
      mutableCopy] autorelease];
    
	[self.tableView reloadData];
	
	[self dismissModalViewControllerAnimated:YES];
	
	NSLog(@"dismissModal setnotification view here");

}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.notificationsArray count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	UILocalNotification *notifcation = [self.notificationsArray objectAtIndex:indexPath.row];
	
	[[cell textLabel] setText:[notifcation alertBody]];
	
	// text color fo cell
	cell.textLabel.textColor = [UIColor colorWithRed:kFontLblColorR green:kFontLblColorG blue:kFontLblColorB alpha:1.0f];

	cell.detailTextLabel.textColor = cell.textLabel.textColor;
	
	cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:22];
	
	cell.detailTextLabel.font = [UIFont fontWithName:@"American Typewriter" size:13];
	

	// set style
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"MMM/dd/yyyy hh:mma"];

	[[cell detailTextLabel] setText:[self getCountdownString:[notifcation.userInfo objectForKey:@"date"]]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	DetailViewController *detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 400)] autorelease];
    
	label.font = [UIFont fontWithName:@"American Typewriter" size:22];
	
	label.backgroundColor = [UIColor clearColor];
    
	label.textAlignment = UITextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
	
	label.lineBreakMode = UILineBreakModeWordWrap;
	
	label.numberOfLines = 0; // dynamic
	
	UILocalNotification *notifcation = [self.notificationsArray objectAtIndex:indexPath.row];
	 
	label.text = [NSString stringWithFormat: @"%@ @ %@", 
				  [notifcation alertBody],[self getCountdownString:[notifcation.userInfo objectForKey:@"date"]]];
//	[NSString stringWithFormat: @"Hello %@", textfield.text];  
    [detailViewController.view addSubview:label];
	
	[[self navigationController] pushViewController:detailViewController animated:YES];

		
}
// return the string which display how far away the event is
- (NSString *)getCountdownString:(NSDate *) fireDate {
	
	//NSTimeInterval timeInterval = [[localNotification.userInfo objectForKey:@"date"] timeIntervalSinceDate:[NSDate date]];
	
	
	// Get the system calendar
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
	// Get conversion to months, days, hours, minutes
	unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:[NSDate date]  toDate:fireDate  options:0];
	
	NSLog(@"Break down: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"MMM/dd/yyyy hh:mma"];
	
	NSString *cdstring = [dateFormatter stringFromDate:fireDate];
	
	cdstring = [cdstring stringByAppendingString:@" time left "];
	
	
	if ([breakdownInfo month] > 0) {
		
		cdstring = [cdstring stringByAppendingString:[NSString stringWithFormat:@"%d month ", [breakdownInfo month]]];

	} 
	
	if ([breakdownInfo day] > 0) {
		
		cdstring = [cdstring stringByAppendingString:[NSString stringWithFormat:@"%d day ", [breakdownInfo day]]];

	} 
	
	if ([breakdownInfo hour] > 0) {
		
		cdstring = [cdstring stringByAppendingString:[NSString stringWithFormat:@"%d hours ", [breakdownInfo hour]]];

	} 
	
	if ([breakdownInfo minute] > 0) {
		
		cdstring = [cdstring stringByAppendingString:[NSString stringWithFormat:@"%d minute ", [breakdownInfo minute]]];
		
	}
	
	
	return cdstring;
	
	
	
	
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[notificationsArray release];
	
    [super dealloc];
}


@end

