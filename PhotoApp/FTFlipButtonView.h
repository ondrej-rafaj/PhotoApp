//
//  FTFlipButtonView.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	FTFlipButtonViewScreenFront,
	FTFlipButtonViewScreenBack
} FTFlipButtonViewScreen;


@class FTFlipButtonView;

@protocol FTFlipButtonViewDelegate <NSObject>

- (void)flipButtonView:(FTFlipButtonView *)view didSelectViewScreen:(FTFlipButtonViewScreen)screen;

@end


@interface FTFlipButtonView : UIView {
	
	UIView *mainView;
	UIView *cameraView;
	UIView *galleryView;
	
}

@property (nonatomic, assign) id <FTFlipButtonViewDelegate> delegate;

@property (nonatomic, strong) UIButton *frontButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic) NSTimeInterval rotationInterval;


@end


@interface FTFlipBarButtonItem : UIBarButtonItem

@property (nonatomic, strong) FTFlipButtonView *flipButton;

- (id)initWithFlipBarButtonItem;

@end
