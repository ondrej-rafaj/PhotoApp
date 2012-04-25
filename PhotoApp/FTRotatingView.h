//
//  FTRotatingView.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	FTRotatingViewRotationNone,
	FTRotatingViewRotationLeft,
	FTRotatingViewRotationRight
} FTRotatingViewRotation;


@interface FTRotatingView : UIView {
	
	FTRotatingViewRotation _rotation;
	
}

@property (nonatomic, readonly) UIView *innerView;

- (FTRotatingViewRotation)rotation;
- (void)setRotation:(FTRotatingViewRotation)rotation;
- (void)removeInnerView;


@end
