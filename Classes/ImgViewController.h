//
//  ImgViewController.h
//  Notification
//
//  Created by Tsai on 1/5/12.
//  Copyright 2012 Space Yak Creative Lab, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

@interface ImgViewController : UIViewController <AVAudioPlayerDelegate> {

	NSDictionary *pref;
		
	AVAudioPlayer *audioPlayer;
	
	UIImageView *marker;
	
	UIImageView *bgView;
	
	IBOutlet UILabel *message;
	
	IBOutlet UILabel *lbMmmdd;
	
	IBOutlet UILabel *lbYyyy;
	
	IBOutlet UILabel *lbTime;

	IBOutlet UILabel *lbOne;

	IBOutlet UILabel *lbTwo;

	IBOutlet UILabel *lbThree;

	IBOutlet UIScrollView *imgScrollView;

}

//- (IBAction)done:(id)sender;

@property (nonatomic, retain) NSDictionary *pref;
@property (nonatomic,retain) UIImageView* marker;
@property (nonatomic,retain) UIImageView* bgView;
@property (nonatomic,retain) UILabel *message;
@property (nonatomic,retain) UILabel *lbMmmdd;
@property (nonatomic,retain) UILabel *lbYyyy;
@property (nonatomic,retain) UILabel *lbTime;
@property (nonatomic,retain) UILabel *lbOne;
@property (nonatomic,retain) UILabel *lbTwo;
@property (nonatomic,retain) UILabel *lbThree;
@property (nonatomic,retain) UIScrollView *imgScrollView;

- (void)cancelView;

@end


