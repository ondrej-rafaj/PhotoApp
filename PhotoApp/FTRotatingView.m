//
//  FTRotatingView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTRotatingView.h"

@implementation FTRotatingView

@synthesize innerView = _innerView;


- (void)addSubview:(UIView *)view {
	if ([self.subviews count] > 0) {
		//NSAssert(<#condition...#><#condition, desc...#>)
	}
	else {
		_innerView = view;
		[super addSubview:view];
	}
}

- (FTRotatingViewRotation)rotation {
	return _rotation;
}

- (void)setRotation:(FTRotatingViewRotation)rotation {
	_rotation = rotation;
}

- (void)removeInnerView {
	if (_innerView) {
		[_innerView removeFromSuperview];
		_innerView = nil;
	}
}

@end
