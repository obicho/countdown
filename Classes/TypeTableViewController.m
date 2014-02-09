//
//  TypeTableViewController.m
//  Notification
//
//  Created by Tsai on 1/10/12.
//  Copyright 2012 Space Yak Creative Lab, LLC. All rights reserved.
//

#import "TypeTableViewController.h"
#import "NotificationAppDelegate.h"

@implementation TypeTableViewController

@synthesize type;
@synthesize listData;
@synthesize delegate=_delegate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self.tableView setBackgroundColor:[UIColor colorWithRed:kBGColorR green:kBGColorG blue:kBGColorB alpha:1.0]];

	// Get common value from appDelegate
	appDelegate = (NotificationAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	// convert from str to array
	NSString *categoryStr = appDelegate.commCategory;
	
	NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
	
	NSArray *Catarray = [categoryStr componentsSeparatedByCharactersInSet:newlines];

	NSLog(@"get common category value 2 - %@",Catarray); // Here you can set or get the value.
	
	
	// assign to the list
	self.listData = Catarray;
	
	//[Catarray release];
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
	
	NSLog(@"View will disappear type");


	//self.parentViewController.myType = @"s";
	
	

}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.listData count];;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *TypeTableIdentifier = @"TypeTableIdentifier";
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:TypeTableIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:TypeTableIdentifier] autorelease];
	
	}
	
	NSUInteger row = [indexPath row];
	
	cell.textLabel.textColor = [UIColor colorWithRed:kFontLblColorR green:kFontLblColorG blue:kFontLblColorB alpha:1.0f];
	
	cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:22];
	
	cell.textLabel.text = [listData objectAtIndex:row];
	
	return cell;
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
    
    appDelegate.gMyType = [listData objectAtIndex:indexPath.row];
    
	NSLog(@"type selected %@", appDelegate.gMyType);
	
	[self.delegate TypeTableViewControllerDidFinish: appDelegate.gMyType];

	[[self navigationController] popViewControllerAnimated:YES];
   
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
    
	[listData dealloc];
	
    [super dealloc];
	
}


@end

