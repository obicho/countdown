//
//  NotificationAppDelegate.m
//  Notification
//
//  Created by Space Yak Creative Lab, LLC
//

#import "NotificationAppDelegate.h"
#import "ImgViewController.h"
#import "SetNotificationViewController.h"
NSString *localReceived = @"localReceived";


@implementation NotificationAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize commCategory;
@synthesize gMyType;
@synthesize gMySound;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	// download latest category on separate thread
	[self load];
    
    self.gMyType = @"puppy";
    
    self.gMySound = @"chime";
	
	//self.commCategory = [[[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding] autorelease];
	
    self.commCategory = [NSString stringWithFormat:@"nurturing\nintriguing\ninsightful\npatient\nalluring\ngentle\nsultry\nperceptive\nempathic\nprotective\ncaring\nwitty\ncharming\npuppy\n"];

    
	imgViewController = [[ImgViewController alloc] initWithNibName:@"ImgViewController" bundle:nil];
	
	UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification) {
		
		// setting sound and type in the image view
		imgViewController.pref = localNotification.userInfo;
		
        NSLog(@"Received notification when app was closed: %@",localNotification.alertBody);
		
		NSLog(@"%@", localNotification.userInfo);

		[self pushImgView];
/*
		// Add 24hr reminder
		NSTimeInterval timeInterval = [localNotification.fireDate timeIntervalSinceDate:[localNotification.userInfo objectForKey:@"date"]];
		
		NSLog(@"time interval within app dele @%", timeInterval);
		
		if (timeInterval > (kReminderTime-50)) {
			
			NSTimeInterval timeToPostpone = kReminderTime;
			
			localNotification.fireDate = [localNotification.fireDate dateByAddingTimeInterval:timeToPostpone];

			[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

			NSLog(@"in notification app delegate more than 10 min");
			
		}
 */
		
	}
	
	// Add the navigation controller's view to the window and display.
	[self.window addSubview:navigationController.view];
	
    [self.window makeKeyAndVisible];
	
	//[responseData release];
	
	// workaround to prevent audioplay start lag - start
	NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"cow" ofType:@"m4a"];
    
	NSLog(@"%@", soundPath);

	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", soundPath]];
	
	NSError *error;
	
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	
	audioPlayer.numberOfLoops = 0;
	
	if (audioPlayer == nil)
		NSLog(@"%@", [error description]);
	else
		[audioPlayer prepareToPlay];
	
	[audioPlayer release];
	// workaround to prevent audioplay start lag - end

	
	NSLog(@"Application launched");
	
	
    return YES;
}


- (void)load 
{
/*
	//NSURL *myURL = [NSURL URLWithString:@"http://spaceyak.com/countdown/tags/animal"];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://spaceyak.com/countdown/tags/animal"] 
														   
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
														   
													       timeoutInterval:10];
	
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];	
	
	if (connection) {
		
		// Create the NSMutableData to hold the received data.
		
		// receivedData is an instance variable declared elsewhere.
		
		responseData = [[NSMutableData data] retain];
		
	} else {
		
		// Inform the user that the connection failed.
		NSLog(@"Unable to fetch data");
		
		self.commCategory = [NSString stringWithFormat:@"bunny\nkitten\npanda\npenguin\npuppy\n"];

	}
	
*/
   
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	    
	responseData = [[NSMutableData alloc] init];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{

    [responseData release];
	
	// could not download category use default
	self.commCategory = [NSString stringWithFormat:@"bunny\nkitten\npanda\npenguin\npuppy\n"];

	NSLog(@"Unable to fetch data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    
    NSLog(@"Succeeded! Received %d bytes of data",[responseData
                                                   length]);
	self.commCategory = [[[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding] autorelease];
	
	NSLog(@" response data %@", self.commCategory);
	
	[responseData release];
    
}


- (void) pushImgView {

	// Need to handle the case when the local notification fires off while img view still open
	if ([[self.navigationController topViewController] isKindOfClass:[ImgViewController class]]) {
		
		[[self navigationController] popViewControllerAnimated:NO];
		
	}
	
	[[self navigationController] pushViewController:imgViewController animated:YES];
	
	[imgViewController.view setNeedsDisplay];
	
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotification {
	
	// setting sound and type in the image view
	imgViewController.pref = localNotification.userInfo;

	[self pushImgView];
		
	NSLog(@"receive notification while app was opened: %@", localNotification.alertBody);
	NSLog(@"%@", localNotification.userInfo);
/*
	// Add 24hr reminder
	//		[notifcation.userInfo objectForKey:@"date"]
	NSDate *actualDate = [localNotification.userInfo objectForKey:@"date"];
	
	NSDate *fdate = localNotification.fireDate;
	
	NSTimeInterval timeInterval = [actualDate timeIntervalSinceDate:localNotification.fireDate];
	
	NSLog(@"actual %@ fdate %@ time interval within app dele %f", actualDate, fdate, timeInterval);
	
	if (timeInterval > (kReminderTime - 50)) {
		
		NSTimeInterval timeToPostpone = kReminderTime;
		
		localNotification.fireDate = [localNotification.fireDate dateByAddingTimeInterval:timeToPostpone];
		
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
		
		NSLog(@"in notification app delegate more than 5 min");
		
	}
 */
	
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"application did become active");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
	[navigationController release];
	
	[imgViewController release];
	
	[window release];
	
	[commCategory release];
    
    [gMyType release];

    [gMySound release];
		
	[super dealloc];
}


@end

