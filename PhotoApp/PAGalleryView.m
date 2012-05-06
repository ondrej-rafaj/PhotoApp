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
#import "PASharingView.h"


@implementation PAGalleryView

@synthesize data = _data;
@synthesize delegate = _delegate;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setClipsToBounds:YES];
		
		UIImageView *bcg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[bcg setContentMode:UIViewContentModeScaleAspectFill];
		[bcg setAutoresizingWidthAndHeight];
		[bcg setImage:[UIImage imageNamed:@"PA_gallery-bcg.png"]];
		[self addSubview:bcg];
			
        grid = [[AQGridView alloc] initWithFrame:self.bounds];
		[grid setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[grid setDelegate:self];
		[grid setDataSource:self];
		[grid setBackgroundColor:[UIColor clearColor]];
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
	ALAsset *a = (ALAsset *)[_data objectAtIndex:index];
	[cell setAsset:a];
	[cell.shareButton setButtonIndex:index];
	[cell.shareButton addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
	[cell.imageView setImage:[UIImage imageWithCGImage:[a thumbnail]]];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
	[cell setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	if (index < [_data count]) {
		_selectedAssetIndex = index;
		if ([_delegate respondsToSelector:@selector(galleryView:requestsDetailFor:)]) {
			[_delegate galleryView:self requestsDetailFor:(ALAsset *)[_data objectAtIndex:_selectedAssetIndex]];
		}
	}
}

- (void)didClickShareButton:(PAGalleryShareButton *)sender {
	if (sender.buttonIndex < [_data count]) {
		_selectedAssetIndex = sender.buttonIndex;
		if ([_delegate respondsToSelector:@selector(galleryView:requestsSharingOptionFor:)]) {
			[_delegate galleryView:self requestsSharingOptionFor:(ALAsset *)[_data objectAtIndex:_selectedAssetIndex]];
		}
		else {
			UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Share photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Email", @"Twitter", nil];
			[as showInView:self.superview];
		}
	}
}

#pragma mark Action sheet & sharing bridge delegate methods

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
	else if (buttonIndex == 3) {
		if ([_delegate respondsToSelector:@selector(galleryView:requestsPostcardFor:)]) {
			[_delegate galleryView:self requestsPostcardFor:[_data objectAtIndex:_selectedAssetIndex]];
		}
	}
	if (!isConnection && buttonIndex != 4 && buttonIndex != 1) {
		FTAlertWithTitleAndMessage(@"No connection", @"No internet conection available");
	}
}

- (void)sharingView:(PASharingView *)sharingView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[sharingView dismiss];
	[self actionSheet:nil clickedButtonAtIndex:buttonIndex];
}


@end
