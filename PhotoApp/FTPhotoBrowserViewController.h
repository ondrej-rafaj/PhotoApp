//
//  FTPhotoBrowserViewController.h
//  PhotoApp
//
//  Created by Maxi Server on 25/11/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FT2PageScrollView.h"


@class FTPhotoBrowserViewController;


@protocol FTPhotoBrowserViewControllerDataSource <NSObject>

- (NSInteger)numberOfItemsInPhotoBrowserViewController:(FTPhotoBrowserViewController *)controller;
- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsThumbnailImageWithIndex:(NSInteger)index;
- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsImageWithIndex:(NSInteger)index;

@optional

- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsImageForSharingWithIndex:(NSInteger)index;

@end


@protocol FTPhotoBrowserViewControllerDelegate <NSObject>

@optional

- (void)photoBrowserViewController:(FTPhotoBrowserViewController *)controller didScrollToPageWithIndex:(NSInteger)index;

@end


@interface FTPhotoBrowserViewController : UIViewController <FT2PageScrollViewDataSource, FT2PageScrollViewDelegate>

@property (nonatomic, weak) id<FTPhotoBrowserViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<FTPhotoBrowserViewControllerDelegate> delegate;

- (void)setStartIndex:(NSInteger)index;


@end
