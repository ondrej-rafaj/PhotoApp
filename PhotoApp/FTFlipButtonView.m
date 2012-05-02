//
//  FTFlipButtonView.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTFlipButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FTFlipButtonView

@synthesize delegate = _delegate;
@synthesize frontButton = _frontButton;
@synthesize backButton = _backButton;
@synthesize isAnimating = _isAnimating;
@synthesize rotationInterval = _rotationInterval;


#pragma mark Configure side view

- (void)configureSideView:(UIView *)view {
	[view.layer setCornerRadius:5];
	[view setClipsToBounds:YES];
}

#pragma mark Button actions

- (void)didFinishFlipAnimation {
	_isAnimating = NO;
}

- (void)didTapButton:(UIButton *)sender {
	if (!_isAnimating) {
		_isAnimating = YES;
		UIView *senderView = sender.superview;
		FTFlipButtonViewScreen s;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didFinishFlipAnimation)];
		[UIView setAnimationDuration:_rotationInterval];
		if (senderView == cameraView) {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:senderView.superview cache:YES];
			[cameraView removeFromSuperview];
			[mainView addSubview:galleryView];
			s = FTFlipButtonViewScreenBack;
		}
		else {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:senderView.superview cache:YES];
			[galleryView removeFromSuperview];
			[mainView addSubview:cameraView];
			s = FTFlipButtonViewScreenFront;
		}
		[UIView commitAnimations];
		
		if ([_delegate respondsToSelector:@selector(flipButtonView:didSelectViewScreen:)]) {
			[_delegate flipButtonView:self didSelectViewScreen:s];
		}
	}
}

#pragma Creating elements

- (void)createAllElements {
	_rotationInterval = 0.4;
	
	mainView = [[UIView alloc] initWithFrame:self.bounds];
	[mainView setBackgroundColor:[UIColor clearColor]];
	[self addSubview:mainView];
	
	cameraView = [[UIView alloc] initWithFrame:self.bounds];
	[cameraView setBackgroundColor:[UIColor blackColor]];
	[self configureSideView:cameraView];
	[mainView addSubview:cameraView];
	
	_frontButton = [[UIButton alloc] initWithFrame:self.bounds];
	[_frontButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[cameraView addSubview:_frontButton];
	
	galleryView = [[UIView alloc] initWithFrame:self.bounds];
	[galleryView setBackgroundColor:[UIColor blackColor]];
	[self configureSideView:galleryView];
	
	_backButton = [[UIButton alloc] initWithFrame:self.bounds];
	[_backButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[galleryView addSubview:_backButton];
}

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self createAllElements];
	}
	return self;
}

@end


@implementation FTFlipBarButtonItem

@synthesize flipButton = _flipButton;

- (id)initWithFlipBarButtonItem {
	_flipButton = [[FTFlipButtonView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
	self = [super initWithCustomView:_flipButton];
	if (self) {
		
	}
	return self;
}

@end
