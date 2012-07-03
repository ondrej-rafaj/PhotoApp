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

@property (nonatomic, strong) UIButton *sendPostcard;
@property (nonatomic, strong) UIButton *sharingFacebook;
@property (nonatomic, strong) UIButton *sharingTwitter;
@property (nonatomic, strong) UIButton *sharingEmail;
@property (nonatomic, strong) UIButton *sharingCancel;

@property (nonatomic, assign) PAGalleryView *galleryDelegate;

- (void)setImage:(UIImage *)image;

- (void)showWithImage:(UIImage *)image;
- (void)show;
- (void)dismiss;


@end
