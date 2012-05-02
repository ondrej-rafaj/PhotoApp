//
//  PASharingView.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 01/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "FTRedCameraButtonView.h"


@class PAGalleryView;


@interface PASharingView : FTView {
	
	UIView *_dismissView;
	
}

@property (nonatomic, strong) UIView *buttonHolder;
@property (nonatomic, strong) UIView *imageViewHolder;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) FTCameraButtonView *sharingFacebook;
@property (nonatomic, strong) FTCameraButtonView *sharingTwitter;
@property (nonatomic, strong) FTCameraButtonView *sharingEmail;
@property (nonatomic, strong) FTRedCameraButtonView *sharingCancel;

@property (nonatomic, assign) PAGalleryView *galleryDelegate;

- (void)setImage:(UIImage *)image;

- (void)showWithImage:(UIImage *)image;
- (void)show;
- (void)dismiss;


@end
