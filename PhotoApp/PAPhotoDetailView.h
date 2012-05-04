//
//  PAPhotoDetailView.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 02/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface PAPhotoDetailView : FTView {
	
	CGFloat maxHeight;
	UIInterfaceOrientation orientation;
	ALAsset *asset;
	UIActivityIndicatorView *ai;
	
}

@property (nonatomic, strong) UIView *imageViewHolder;
@property (nonatomic, strong) UIImageView *imageView;


- (void)setImage:(UIImage *)image;

- (void)showWithAsset:(ALAsset *)asset;
- (void)showWithImage:(UIImage *)image;
- (void)show;
- (void)dismiss;

- (void)setOrientation:(UIInterfaceOrientation)orientation;


@end
