//
//  PASharingView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 01/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PASharingView.h"
#import "UIView+Layout.h"
#import "PAGalleryView.h"


@implementation PASharingView

@synthesize buttonHolder = _buttonHolder;
@synthesize imageViewHolder = _imageViewHolder;
@synthesize imageView = _imageView;
@synthesize sendPostcard = _sendPostcard;
@synthesize sharingFacebook = _sharingFacebook;
@synthesize sharingEmail = _sharingEmail;
@synthesize sharingTwitter = _sharingTwitter;
@synthesize sharingCancel = _sharingCancel;
@synthesize galleryDelegate = _galleryDelegate;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setAlpha:0];
		[self setHidden:YES];
		
		_dismissView = [[UIView alloc] initWithFrame:self.bounds];
		[_dismissView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
		[self addSubview:_dismissView];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDismissView:)];
		[_dismissView addGestureRecognizer:tap];
		
		CGFloat width = 230;
		
		CGRect r = CGRectMake(0, 0, 100, 100);
		_imageViewHolder = [[UIView alloc] initWithFrame:r];
		[_imageViewHolder setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:_imageViewHolder];
		[_imageViewHolder centerInSuperView];
		[_imageViewHolder positionAtY:40];
		
		_imageView = [[UIImageView alloc] initWithFrame:r];
		[_imageView setBackgroundColor:[UIColor grayColor]];
		[_imageViewHolder addSubview:_imageView];
		[_imageView makeMarginInSuperView:5];
		
		_buttonHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 222)];
		[self addSubview:_buttonHolder];
		
		_sendPostcard = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 52)];
		[_sendPostcard addTarget:self action:@selector(didTapPostcard:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sendPostcard];
        UIImage *icon = [[UIImage imageNamed:@"PP_btn_sendpost.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:26];
		[_sendPostcard setBackgroundImage:icon forState:UIControlStateNormal];
		UIImage *text = [UIImage imageNamed:@"PP_txt_sendpost.png"];
		[_sendPostcard setImage:text forState:UIControlStateNormal];
		[_sendPostcard setImageEdgeInsets:UIEdgeInsetsMake(1, 25, 0, 80)];
		
		_sharingFacebook = [[UIButton alloc] initWithFrame:CGRectMake(0, ([_sendPostcard bottomPosition] + 10), width, 40)];
		[_sharingFacebook addTarget:self action:@selector(didTapFacebook:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingFacebook];
		icon = [[UIImage imageNamed:@"PP_btn_facebook.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:26];
		[_sharingFacebook setBackgroundImage:icon forState:UIControlStateNormal];
		text = [UIImage imageNamed:@"PP_txt_facebook.png"];
		[_sharingFacebook setImage:text forState:UIControlStateNormal];
		[_sharingFacebook setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 80)];
		
		_sharingEmail = [[UIButton alloc] initWithFrame:CGRectMake(0, ([_sharingFacebook bottomPosition] + 4), width, 40)];
		[_sharingEmail addTarget:self action:@selector(didTapEmail:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingEmail];
		icon = [[UIImage imageNamed:@"PP_btn_email.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:26];
		[_sharingEmail setBackgroundImage:icon forState:UIControlStateNormal];
		text = [UIImage imageNamed:@"PP_txt_email.png"];
		[_sharingEmail setImage:text forState:UIControlStateNormal];
		[_sharingEmail setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 80)];
		
		_sharingTwitter = [[UIButton alloc] initWithFrame:CGRectMake(0, ([_sharingEmail bottomPosition] + 4), width, 40)];
		[_sharingTwitter addTarget:self action:@selector(didTapTwitter:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingTwitter];
		icon = [[UIImage imageNamed:@"PP_btn_twitter.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:26];
		[_sharingTwitter setBackgroundImage:icon forState:UIControlStateNormal];
		text = [UIImage imageNamed:@"PP_txt_twitter.png"];
		[_sharingTwitter setImage:text forState:UIControlStateNormal];
		[_sharingTwitter setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 80)];
		
		_sharingCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, ([_sharingTwitter bottomPosition] + 4), width, 40)];
		[_buttonHolder addSubview:_sharingCancel];
		[_sharingCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		icon = [[UIImage imageNamed:@"PP_btn_cancel.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:26];
		[_sharingCancel setBackgroundImage:icon forState:UIControlStateNormal];
		text = [UIImage imageNamed:@"PP_txt_cancel.png"];
		[_sharingCancel setImage:text forState:UIControlStateNormal];
		[_sharingCancel setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 80)];
		
		[_buttonHolder setHeight:[_sharingCancel bottomPosition]];
		[_buttonHolder centerInSuperView];
		[_buttonHolder positionAtY:([_buttonHolder yPosition] + 40)];
    }
    return self;
}

- (void)show {
	[self setHidden:NO];
	[UIView animateWithDuration:0.3 animations:^{
		[self setAlpha:1];
	}completion:^(BOOL finished) {
		
	}];
}

- (void)showWithImage:(UIImage *)image {
	[self setImage:image];
	[self show];
}

- (void)dismiss {
	[UIView animateWithDuration:0.3 animations:^{
		[self setAlpha:0];
	}completion:^(BOOL finished) {
		[self setHidden:YES];
		[_imageView setImage:nil];
	}];
}

- (void)setImage:(UIImage *)image {
	[_imageView setImage:image];
}

- (void)didTapDismissView:(UITapGestureRecognizer *)recognizer {
	[self dismiss];
}

- (void)didTapFacebook:(UIButton *)sender {
	[_galleryDelegate sharingView:self clickedButtonAtIndex:0];
}

- (void)didTapEmail:(UIButton *)sender {
	[_galleryDelegate sharingView:self clickedButtonAtIndex:1];
}

- (void)didTapTwitter:(UIButton *)sender {
	[_galleryDelegate sharingView:self clickedButtonAtIndex:2];
}

- (void)didTapPostcard:(UIButton *)sender {
	[_galleryDelegate sharingView:self clickedButtonAtIndex:3];
}


@end
