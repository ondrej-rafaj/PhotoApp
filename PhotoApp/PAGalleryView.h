//
//  PAGalleryView.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 30/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "AQGridView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FTShare.h"


@class PAGalleryView;

@protocol PAGalleryViewDelegate <NSObject>

- (void)galleryView:(PAGalleryView *)gallery requestsFacebookShareFor:(ALAsset *)asset;
- (void)galleryView:(PAGalleryView *)gallery requestsEmailShareFor:(ALAsset *)asset;
- (void)galleryView:(PAGalleryView *)gallery requestsTwitterShareFor:(ALAsset *)asset;

@end


@interface PAGalleryView : UIView <AQGridViewDelegate, AQGridViewDataSource, UIActionSheetDelegate> {
	
	AQGridView *grid;
	
	NSInteger _selectedAssetIndex;
	
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) id <PAGalleryViewDelegate> delegate;

- (void)reloadData;


@end
