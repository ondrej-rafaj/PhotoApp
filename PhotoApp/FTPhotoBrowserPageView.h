//
//  FTPhotoBrowserPageView.h
//  PhotoApp
//
//  Created by Maxi Server on 25/11/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2PageView.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface FTPhotoBrowserPageView : FT2PageView <UIScrollViewDelegate>


@property (nonatomic, strong) ALAsset *asset;

- (void)setImage:(UIImage *)image;


@end
