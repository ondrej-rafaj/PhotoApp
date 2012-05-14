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
		[_dismissView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
		[self addSubview:_dismissView];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDismissView:)];
		[_dismissView addGestureRecognizer:tap];
		
		CGFloat width = 220;
		
		CGRect r = CGRectMake(0, 0, 100, 100);
		_imageViewHolder = [[UIView alloc] initWithFrame:r];
		[_imageViewHolder setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:_imageViewHolder];
		[_imageViewHolder centerInSuperView];
		[_imageViewHolder positionAtY:50];
		
		_imageView = [[UIImageView alloc] initWithFrame:r];
		[_imageView setBackgroundColor:[UIColor grayColor]];
		[_imageViewHolder addSubview:_imageView];
		[_imageView makeMarginInSuperView:5];
		
		_buttonHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (width + 20), ((30 * 5) + 60))];
		[_buttonHolder setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
		[_buttonHolder.layer setCornerRadius:15];
		[_buttonHolder.layer setBorderWidth:1];
		[_buttonHolder.layer setBorderColor:[UIColor darkGrayColor].CGColor];
		[self addSubview:_buttonHolder];
		[_buttonHolder centerInSuperView];
		[_buttonHolder positionAtY:([_buttonHolder yPosition] + 40)];
		
		_sendPostcard = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(10, 10, width, 30)];
		[_sendPostcard setTitle:@"Send postcard" forState:UIControlStateNormal];
		[_sendPostcard addTarget:self action:@selector(didTapPostcard:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sendPostcard];
		
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_share-postcard.png"]];
		[_buttonHolder addSubview:icon];
		[icon positionAtX:(width - 16) andY:([_sendPostcard yPosition] - 4)];
		
		_sharingFacebook = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(10, ([_sendPostcard bottomPosition] + 10), width, 30)];
		[_sharingFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
		[_sharingFacebook addTarget:self action:@selector(didTapFacebook:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingFacebook];
		
		icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_share-facebook.png"]];
		[_buttonHolder addSubview:icon];
		[icon positionAtX:(width - 16) andY:([_sharingFacebook yPosition] - 4)];
		
		_sharingEmail = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(10, ([_sharingFacebook bottomPosition] + 10), width, 30)];
		[_sharingEmail setTitle:@"Email" forState:UIControlStateNormal];
		[_sharingEmail addTarget:self action:@selector(didTapEmail:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingEmail];
		
		icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_share-email.png"]];
		[_buttonHolder addSubview:icon];
		[icon positionAtX:(width - 16) andY:([_sharingEmail yPosition] - 4)];
		
		_sharingTwitter = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(10, ([_sharingEmail bottomPosition] + 10), width, 30)];
		[_sharingTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
		[_sharingTwitter addTarget:self action:@selector(didTapTwitter:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonHolder addSubview:_sharingTwitter];
		
		icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_share-twitter.png"]];
		[_buttonHolder addSubview:icon];
		[icon positionAtX:(width - 16) andY:([_sharingTwitter yPosition] - 4)];
		
		_sharingCancel = [[FTRedCameraButtonView alloc] initWithFrame:CGRectMake(10, ([_sharingTwitter bottomPosition] + 10), width, 30)];
		[_sharingCancel setTitle:@"Cancel" forState:UIControlStateNormal];
		[_buttonHolder addSubview:_sharingCancel];
		[_sharingCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
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
