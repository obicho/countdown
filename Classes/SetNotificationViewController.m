//
//  SetNotificationViewController.m
//  Notifier
//
//  Created by Space Yak Creative Lab, LLC
//

#import "SetNotificationViewController.h"
#import "TypeTableViewController.h"
#import "SoundTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "NotificationAppDelegate.h"

@implementation SetNotificationViewController

@synthesize delegate;
@synthesize datePicker;
@synthesize messageField;
@synthesize listData;
@synthesize prefTableView;

const int KTYPE = 1;
const int KSOUND = 0;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// set up navigation bar color
	UINavigationBar *bar = [self.navigationController navigationBar];
	
	[bar setTintColor:[UIColor colorWithRed:kNavBarColorR green:kNavBarColorG blue:kNavBarColorB alpha:1.0]];

	// Initialize default values for sound and type
	appDelegate = (NotificationAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.title = @"Add reminder";

	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddNotification)] autorelease];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNotification)] autorelease];

	self.navigationItem.rightBarButtonItem = addButton;
	
	// set the date pickers date and the minimum date to now
	NSDate *currentDate = [NSDate date];

	[self.datePicker setDate:currentDate];
	
	[self.datePicker setMinimumDate:currentDate];

	// set round corners
	prefTableView.layer.masksToBounds = YES;
	
	prefTableView.layer.cornerRadius = 5.0;
	
	// -- table data set up
	NSArray *array = [[NSArray alloc] initWithObjects:@"Pick Alarm", @"My Type",nil];
	
	self.listData = array;
	
	[array release];
	
}

- (void)cancelAddNotification {
	[self.delegate dismissSetNotificationViewController];
}

- (void)addNotification {
	
	UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
		/*
	// Setting up 5 min reminder before event. Only do so if the event is 5 min or more in advance
	NSTimeInterval timeInterval = [self.datePicker.date timeIntervalSinceNow];
	NSLog(@"Time interval %f", timeInterval);
	

	if (timeInterval > kReminderTime) {
		
		NSTimeInterval secondsToPostpone = -kReminderTime;

		localNotification.fireDate = [self.datePicker.date dateByAddingTimeInterval:secondsToPostpone];
		
		NSLog(@"fire date %@", localNotification.fireDate);
		
		NSLog(@" more than 10 min");
		
	} else {

		NSLog(@" less than 10 min");

		localNotification.fireDate = self.datePicker.date;
		
	}
	 */
	
	// start remove reminder so only keep this
	localNotification.fireDate = self.datePicker.date;
	// end remove reminder so only keep this

	localNotification.alertBody = self.messageField.text;
	
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	
	//localNotification.applicationIconBadgeNumber = 1;
	
	NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
	
	[infoDict setObject:appDelegate.gMyType forKey: @"type"];
	
	[infoDict setObject:appDelegate.gMySound forKey: @"sound"];
	
	[infoDict setObject:self.messageField.text forKey:@"msg"];
	
	[infoDict setObject:self.datePicker.date forKey:@"date"];
	
	localNotification.userInfo = infoDict;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	
	[self.delegate dismissSetNotificationViewController];
}

- (IBAction)dismissKeyboard {
	
	[self.messageField resignFirstResponder];
	
}

- (void)didReceiveMemoryWarning {
    
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
    
	[super viewDidUnload];
    
	self.datePicker = nil;
	
	self.messageField = nil;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:SimpleTableIdentifier] autorelease];
	
	}
	
	// text color, type fo cell
	cell.textLabel.textColor = [UIColor colorWithRed:kFontLblColorR green:kFontLblColorG blue:kFontLblColorB alpha:1.0f];
	
	cell.detailTextLabel.textColor = cell.textLabel.textColor;

	cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:22];
	
	cell.detailTextLabel.font = [UIFont fontWithName:@"American Typewriter" size:12];
	
	//Display image type and sound accordingly in uitableview
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSUInteger row = [indexPath row];
	
	cell.textLabel.text = [listData objectAtIndex:row];
	 
	if (indexPath.row == KTYPE) {
        
        [cell.detailTextLabel setText:appDelegate.gMyType];
	
	} else if (indexPath.row == KSOUND) {
	
        [cell.detailTextLabel setText:appDelegate.gMySound];
		
	}
	
	return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.row == KTYPE) {
		
		TypeTableViewController *typeController = [[[TypeTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		
		typeController.delegate = self;
		
		typeController.type = indexPath.row;
		
		NSLog(@"typeController %d ", typeController.type);
		
		[[self navigationController] pushViewController:typeController animated:YES];
		
	} else if (indexPath.row == KSOUND) {
	
		SoundTableViewController *soundController = [[[SoundTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		soundController.delegate = self;
		
		soundController.type = indexPath.row;
		
		NSLog(@"soundController %d ", soundController.type);
		
		[[self navigationController] pushViewController:soundController animated:YES];
		
	}
	
}

- (void)TypeTableViewControllerDidFinish:(NSString *) type
{
	
	NSLog(@"Parent Type %@", type);
	
	[prefTableView reloadData];
	
}

- (void)SoundTableViewControllerDidFinish:(NSString *) sound
{
	
    NSLog(@"Parent Sound %@", sound);
	
	[prefTableView reloadData];
	
}



- (void)dealloc {
    
	[messageField release];
	
	[datePicker release];
    
	[listData dealloc];
	
	[super dealloc];
	
}


@end
