//
//  PAGalleryView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 30/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAGalleryView.h"
#import "PAGalleryViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation PAGalleryView

@synthesize data = _data;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        grid = [[AQGridView alloc] initWithFrame:self.bounds];
		[grid setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[grid setDelegate:self];
		[grid setDataSource:self];
		[grid setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
		[self addSubview:grid];
    }
    return self;
}

#pragma mark Data management

- (void)reloadData {
	[grid reloadData];
}

#pragma mark Grid view delegate & datasource methods

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
	return [_data count];
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView {
	return CGSizeMake(90, 90);
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *cellIdentifier = @"galleryCellIdentifier";
	PAGalleryViewCell *cell = (PAGalleryViewCell *)[gridView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[PAGalleryViewCell alloc] initWithFrame:CGRectMake(0, 0, 90, 90) reuseIdentifier:cellIdentifier];
		[cell setSelectionStyle:AQGridViewCellSelectionStyleNone];
	}
	ALAsset *a = [_data objectAtIndex:index];
	[cell.imageView setImage:[UIImage imageWithCGImage:[a thumbnail]]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
	[cell setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	
}


@end
