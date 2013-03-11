//
//  FTCameraButtonView.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTCameraButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FTCameraButtonView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]];
		[self.layer setCornerRadius:15];
		[self.layer setBorderWidth:1];
		[self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		[self addTarget:self action:@selector(didPressDown:) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(didPressUp:) forControlEvents:UIControlEventTouchUpInside];
		self.layer.shouldRasterize = 1;
		self.layer.rasterizationScale = [UIScreen mainScreen].scale;
	}
	return self;
}

- (void)didPressDown:(UIButton *)sender {
	[self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	[self.layer setBorderColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4].CGColor];
}

- (void)didPressUp:(UIButton *)sender {
	if (!highligtEnabled) [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]];
	[self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
}

- (void)enableHighlight:(BOOL)enable {
	highligtEnabled = enable;
	if (highligtEnabled) [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	else [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]];
}


@end
