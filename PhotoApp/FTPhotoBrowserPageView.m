//
//  FTPhotoBrowserPageView.m
//  PhotoApp
//
//  Created by Maxi Server on 25/11/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTPhotoBrowserPageView.h"
#import "UIColor+Tools.h"


@interface FTPhotoBrowserPageView ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation FTPhotoBrowserPageView

- (id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [_imageView setFrame:self.bounds];
    NSLog(@"Image frame: %@", NSStringFromCGRect(self.bounds));
    [_imageView setImage:image];
}


@end
