//
//  PAPhotoDetailView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 02/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAPhotoDetailView.h"
#import "UIImage+Tools.h"


@implementation PAPhotoDetailView

@synthesize imageViewHolder = _imageViewHolder;
@synthesize imageView = _imageView;

- (void)initializeView {
	[super initializeView];
	
	[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
	[self setAlpha:0];
	[self setHidden:YES];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDismissView:)];
	[self addGestureRecognizer:tap];
	
	_imageViewHolder = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 440)];
	[_imageViewHolder setUserInteractionEnabled:YES];
	[_imageViewHolder setBackgroundColor:[UIColor whiteColor]];
	[self addSubview:_imageViewHolder];
	
	_imageView = [[UIImageView alloc] initWithFrame:_imageViewHolder.bounds];
	[_imageView setClipsToBounds:YES];
	[_imageView setAutoresizingWidthAndHeight];
	[_imageView setBackgroundColor:[UIColor grayColor]];
	[_imageViewHolder addSubview:_imageView];
	[_imageView makeMarginInSuperView:10];
	[_imageView setContentMode:UIViewContentModeScaleAspectFill];
	
	ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[ai setAlpha:0];
	[ai startAnimating];
	[_imageView addSubview:ai];
	[ai centerInSuperView];
	[ai setAutoresizingCenter];
}

- (void)setFrameForImage {
	int iw = (_imageView.image.size.width);
	int ih = (_imageView.image.size.height);
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		int v = ((280 * ih) / iw);
		v = 440;
		[_imageViewHolder setFrame:CGRectMake(20, 20, 280, v)];
	}
	else {
		int v = ((280 * iw) / ih);
		v = 440;
		[_imageViewHolder setFrame:CGRectMake(20, 20, 280, v)];
	}
}

- (void)show {
	[_imageView setImage:nil];
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

- (void)loadAssetOnBackground {
	@autoreleasepool {
		ALAssetRepresentation *rep = [asset defaultRepresentation];
		CGImageRef iref = [rep fullResolutionImage];
		//sleep(2);
		//UIImage *img = [[UIImage imageWithCGImage:iref scale:1 orientation:[rep orientation]] scaleWithMaxSize:500];
		UIImage *img = [UIImage imageWithCGImage:iref scale:1 orientation:[rep orientation]];
		[self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
	}
}

- (void)prepareAssetForBackgroundLoading {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(loadAssetOnBackground) withObject:nil];
	}
}

- (void)showWithAsset:(ALAsset *)_asset {
	asset = _asset;
	[self show];
	[UIView beginAnimations:nil context:nil];
	[ai setAlpha:1];
	[UIView commitAnimations];
	[NSThread detachNewThreadSelector:@selector(prepareAssetForBackgroundLoading) toTarget:self withObject:nil];
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
	[self setFrameForImage];
	[UIView beginAnimations:nil context:nil];
	[ai setAlpha:0];
	[UIView commitAnimations];
}

- (void)didTapDismissView:(UITapGestureRecognizer *)recognizer {
	[self dismiss];
}

- (void)setOrientation:(UIInterfaceOrientation)o {
	orientation = o;
	[self setFrameForImage];
}


@end
