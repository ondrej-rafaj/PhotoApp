//
//  FTRedCameraButtonView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 01/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTRedCameraButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FTRedCameraButtonView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
	}
	return self;
}

- (void)didPressDown:(UIButton *)sender {
	[self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6]];
	[self.layer setBorderColor:[UIColor colorWithRed:0.1 green:0 blue:0 alpha:0.4].CGColor];
}

- (void)didPressUp:(UIButton *)sender {
	if (!highligtEnabled) [self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
	[self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
}

- (void)enableHighlight:(BOOL)enable {
	highligtEnabled = enable;
	if (highligtEnabled) [self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6]];
	else [self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4]];
}


@end
