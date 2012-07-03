//
//  PAHomeViewController.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <Sincerely/Sincerely.h>
#import "FTCameraButtonView.h"
#import "FTFlipButtonView.h"
#import "FTPhotoGridView.h"
#import "PAOptionsTableViewCell.h"
#import "PAGalleryView.h"
#import "MBProgressHUD.h"
#import "GPUImage.h"
#import "PASharingView.h"
#import "PAPhotoDetailView.h"
#import "PAConfig.h"


@interface PAHomeViewController : PAViewController <FTFlipButtonViewDelegate, UITableViewDelegate, UITableViewDataSource, PAOptionsTableViewCellDelegate, MBProgressHUDDelegate, PAGalleryViewDelegate, FTShareFacebookDelegate, FTShareEmailDelegate, MFMailComposeViewControllerDelegate, SYSincerelyControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	PAConfig *config;
	
	UIToolbar *mainToolbar;
	FTFlipBarButtonItem *galleryFlipButton;
	
	UIView *mainView;
	UIActivityIndicatorView *mainViewAi;
	
	UIView *cameraMainView;
	GPUImageView *cameraView;
	UIView *touchDetector;
	FTPhotoGridView *gridView;
	UITableView *optionsTable;
	FTCameraButtonView *flashButton;
	FTCameraButtonView *optionsButton;
    FTCameraButtonView *cameraSwitchButton;
    UISlider *filterSettingsSlider;
	PAConfigFlashMode flashMode;
	UIButton *snapButton;
	CGFloat optionsTableHeight;
	MBProgressHUD *progressHud;
	
	UIView *galleryMainView;
	PAGalleryView *galleryDisplayView;
	PASharingView *sharingView;
	PAPhotoDetailView *galleryDetailView;
	
	NSMutableArray *optionsData;
	
	ALAssetsLibrary *library;
	NSMutableArray *assets;
	
	BOOL isTakingPhoto;
	
}

@property (nonatomic) UIInterfaceOrientation orientation;

@property (nonatomic, strong) GPUImageStillCamera *stillCamera;


- (void)rotateElements;


@end
