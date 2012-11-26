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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL didTryToZoom;

@end


@implementation FTPhotoBrowserPageView


#pragma mark Initialization

- (id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setBackgroundColor:[UIColor blackColor]];
        [_scrollView setCanCancelContentTouches:NO];
        [_scrollView setClipsToBounds:YES];
        [_scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        [_scrollView setMinimumZoomScale:1];
        [_scrollView setMaximumZoomScale:3];
        [_scrollView setDelegate:self];
        [_scrollView setScrollEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setContentSize:_imageView.bounds.size];
        [_scrollView addSubview:_imageView];
    }
    return self;
}

#pragma mark Improve image quality

- (void)improveImageQuality {
    @autoreleasepool {
        NSDate *startDate = [NSDate date];
        ALAssetRepresentation *rep = [_asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:iref scale:1 orientation:rep.orientation];
        [_imageView setImage:img];
        //[_imageView setFrame:CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height)];
        NSLog(@"Image size: %@ Loaded in: %f", NSStringFromCGSize(img.size), ([[NSDate date] timeIntervalSinceNow] - [startDate timeIntervalSinceNow]));
    }
}

- (void)startImprovingImageQuality {
    @autoreleasepool {
        [self performSelectorInBackground:@selector(improveImageQuality) withObject:nil];
    }
}

#pragma mark Settings

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
}

- (void)setImage:(UIImage *)image {
    _didTryToZoom = NO;
    [_scrollView setZoomScale:1];
    [_scrollView setFrame:self.bounds];
    [_imageView setFrame:self.bounds];
    [_imageView setImage:image];
}

#pragma mark Scroll view delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (!_didTryToZoom) {
        _didTryToZoom = YES;
        [NSThread detachNewThreadSelector:@selector(startImprovingImageQuality) toTarget:self withObject:nil];
    }
}


@end
