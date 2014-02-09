//
//  ImgViewController.m
//  Notification
//
//  Created by Tsai on 1/5/12.
//  Copyright 2012 Space Yak Creative Lab, LLC. All rights reserved.
//

#import "ImgViewController.h"


@implementation ImgViewController

@synthesize pref;
@synthesize marker;
@synthesize bgView;
@synthesize message;
@synthesize lbMmmdd;
@synthesize lbYyyy;
@synthesize lbTime;
@synthesize lbOne;
@synthesize lbTwo;
@synthesize lbThree;
@synthesize imgScrollView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	[cancelButton release];
	
	// set up scroll view
	
    [imgScrollView setCanCancelContentTouches:NO];
	
    imgScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	
    imgScrollView.clipsToBounds = YES;        // default is NO, we want to restrict drawing within our scrollview
	
    imgScrollView.scrollEnabled = YES;
    
    marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultImage.jpg"]];
	
}

- (void)displayImage:(UIImage *)image {
    

    [marker setImage:image];
    
    [marker sizeToFit];
    
    marker.contentMode = UIViewContentModeScaleAspectFit;
    
    
//    NSLog(@"marker width %f", marker.frame.size.width);
    marker.frame = CGRectMake((kScreenWidth-marker.frame.size.width)/2, kImagePosition, marker.frame.size.width, marker.frame.size.height);
    
	// set content size of the scroll view
	
	[imgScrollView setContentSize:CGSizeMake(marker.frame.size.width, marker.frame.size.height + kContentSizeBuffer)];
	
	[imgScrollView addSubview:marker];

}

- (void)loadImage {

    /*
     NSString *typeName = [[self.pref objectForKey:@"type"] lowercaseString];
     
     NSString *urlString = [NSString stringWithFormat:@"http://spaceyak.com/countdown/image?w=310&h=380&tags=%@", typeName];	
     
     NSLog(@"Url %@", urlString);
     
     NSURL *urlimg = [NSURL URLWithString: urlString];
     
     NSData* imageData = [[[NSData alloc] initWithContentsOfURL:urlimg] autorelease];
     /Users/cho/Downloads/Countdown_Cute_Ladies_Distr.mobileprovision
     UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    */
    
    
    srand(time(NULL)); 
    
    int rint = rand() % 303;
    
    NSString* myNewString = [NSString stringWithFormat:@"%d", rint];

    NSString* imageFileName = [NSString stringWithFormat:@"a%@.jpg", myNewString];
    
    UIImage* image = [UIImage imageNamed:imageFileName];
     
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
     
}


- (void)viewWillAppear:(BOOL)animated {

	
	NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
    
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImage)
                                        object:nil] autorelease];
    
    [queue addOperation:operation];
        
    
	// -- ## creating a separate thread to handle image ##
    
    // -- activity indicator (spinning)
    /*
    UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    
    spinner.frame = CGRectMake(160, 200, 24, 24);
    
    [imgScrollView addSubview:spinner];
    
    [spinner startAnimating];
      */  
	// -- load body message
    
	self.message.text = [self.pref objectForKey:@"msg"];
	
	// -- load date and time
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
									| NSMonthCalendarUnit 
									| NSYearCalendarUnit fromDate:[self.pref objectForKey:@"date"]];
	
	
	NSDateFormatter *f = [[[NSDateFormatter alloc] init] autorelease];

	[f setDateFormat:@"MMM"];	

	self.lbYyyy.text = [NSString stringWithFormat:@"%d", [components year]];
		
	self.lbMmmdd.text = [NSString stringWithFormat:@"%@ %d",  [f stringFromDate:[self.pref objectForKey:@"date"]], [components day]];
	
	[f setDateFormat:@"hh:mma"];	
	
	self.lbTime.text = [NSString stringWithFormat:@"%@",  [f stringFromDate:[self.pref objectForKey:@"date"]]];
	
	// -- loading sound
	NSString *soundFileName = [[self.pref objectForKey:@"sound"] lowercaseString];
	
	NSLog(@"Value of sound %@", soundFileName);
	
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"m4a"];
    
	NSLog(@"%@", soundPath);

	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", soundPath]];
	
	NSError *error;
		
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
				  
	audioPlayer.numberOfLoops = 0;
	
	if (audioPlayer == nil) {
        
		NSLog(@"%@", [error description]);
	
    } else {
        
        audioPlayer.delegate = self;
    
        [audioPlayer play];
        
        
    }
	
	
	// -- Check if reminder
//	NSTimeInterval timeInterval = [[self.pref objectForKey:@"date"] timeIntervalSinceNow];
//	
//	NSLog(@"Time interval imageview %f", timeInterval);
//	
//	if (timeInterval < 10) {
//		
//		NSLog(@"right now");
//		
//		self.lbOne.text = @"Yo";
//		
//		self.lbTwo.text = @"it's";
//		
//		self.lbThree.text = @"time!";
//		
//	} else {
//	
//		self.lbOne.text = @"10";
//		
//		self.lbTwo.text = @"min";
//		
//		self.lbThree.text = @"away";
//		
//	}
//	
	
			
	self.lbOne.text = @"Hi";
			
	self.lbTwo.text = @"It's";
			
	self.lbThree.text = @"time!";
	
	NSLog(@"view will appear");
}




- (void)cancelView {
	
	NSLog(@"cancel view");
	
	[[self navigationController] popToRootViewControllerAnimated:YES];
	
//	[self.delegate dismissImgViewController];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [audioPlayer release];
    
    NSLog(@"release audio player");
}


- (void)dealloc {
	
    [super dealloc];
	
	[marker release];
	
	[bgView release];
	
	[imgScrollView release];
	
}


@end
