//
//  PAGalleryViewCell.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 30/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAGalleryViewCell.h"
#import "UIView+Layout.h"
#import "UIView+Effects.h"


@implementation PAGalleryViewCell

@synthesize imageView = _imageView;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
		UIView *v = [[UIView alloc] initWithFrame:self.bounds];
		[v setBackgroundColor:[UIColor whiteColor]];
		[self.contentView addSubview:v];
		[v makeMarginInSuperView:10];
		[v addShadow];
		
        _imageView = [[UIImageView alloc] initWithFrame:frame];
		[_imageView setContentMode:UIViewContentModeScaleAspectFill];
		[_imageView setClipsToBounds:YES];
		//[_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self.contentView addSubview:_imageView];
		[_imageView makeMarginInSuperView:15];
    }
    return self;
}


@end
