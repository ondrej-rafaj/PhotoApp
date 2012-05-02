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
@synthesize asset = _asset;
@synthesize shareButton = _shareButton;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
		UIView *v = [[UIView alloc] initWithFrame:self.bounds];
		[v setBackgroundColor:[UIColor whiteColor]];
		[self.contentView addSubview:v];
		[v makeMarginInSuperView:10];
		[v positionAtY:([v yPosition] + 5)];
		[v addShadow];
		
        _imageView = [[UIImageView alloc] initWithFrame:frame];
		[_imageView setContentMode:UIViewContentModeScaleAspectFill];
		[_imageView setClipsToBounds:YES];
		[self.contentView addSubview:_imageView];
		[_imageView makeMarginInSuperView:15];
		[_imageView positionAtY:([v yPosition] + 5)];
		
		_shareButton = [[PAGalleryShareButton alloc] init];
		[_shareButton setFrame:CGRectMake(([_imageView rightPosition] - 20), 8, 34, 34)];
		[_shareButton setImage:[UIImage imageNamed:@"PA_share.png"] forState:UIControlStateNormal];
		[_shareButton setBackgroundColor:[UIColor clearColor]];
		[self.contentView addSubview:_shareButton];
    }
    return self;
}


@end
