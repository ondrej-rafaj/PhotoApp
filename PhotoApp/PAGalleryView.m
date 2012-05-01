//
//  PAGalleryView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 30/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAGalleryView.h"
#import "PAGalleryViewCell.h"
#import "FTSystem.h"
#import "FTAlertView.h"


@implementation PAGalleryView

@synthesize data = _data;
@synthesize delegate = _delegate;


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
	return CGSizeMake(100, 100);
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString *cellIdentifier = @"galleryCellIdentifier";
	PAGalleryViewCell *cell = (PAGalleryViewCell *)[gridView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[PAGalleryViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100) reuseIdentifier:cellIdentifier];
		[cell setSelectionStyle:AQGridViewCellSelectionStyleNone];
	}
	ALAsset *a = [_data objectAtIndex:index];
	[cell.imageView setImage:[UIImage imageWithCGImage:[a thumbnail]]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
	[cell setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	_selectedAssetIndex = index;
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Share photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Email", @"Twitter", nil];
	[as showInView:self.superview];
}

#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	BOOL isConnection = [FTSystem isInternetAvailable];
	if (buttonIndex == 0) {
		if (isConnection) {
			if ([_delegate respondsToSelector:@selector(galleryView:requestsFacebookShareFor:)]) {
				[_delegate galleryView:self requestsFacebookShareFor:[_data objectAtIndex:_selectedAssetIndex]];
			}
		}
	}
	else if (buttonIndex == 1) {
		if ([_delegate respondsToSelector:@selector(galleryView:requestsEmailShareFor:)]) {
			[_delegate galleryView:self requestsEmailShareFor:[_data objectAtIndex:_selectedAssetIndex]];
		}
	}
	else if (buttonIndex == 2) {
		if (isConnection) {
			if ([_delegate respondsToSelector:@selector(galleryView:requestsTwitterShareFor:)]) {
				[_delegate galleryView:self requestsTwitterShareFor:[_data objectAtIndex:_selectedAssetIndex]];
			}
		}
	}
	if (!isConnection && buttonIndex != 3 && buttonIndex != 1) {
		FTAlertWithTitleAndMessage(@"No connection", @"No internet conection available");
	}
}


@end
