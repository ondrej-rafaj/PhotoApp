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


@interface PAHomeViewController : PAViewController <FTFlipButtonViewDelegate, UITableViewDelegate, UITableViewDataSource, PAOptionsTableViewCellDelegate, MBProgressHUDDelegate, PAGalleryViewDelegate, FTShareFacebookDelegate, FTShareEmailDelegate, MFMailComposeViewControllerDelegate> {
	
	PAConfig *config;
	
	UIToolbar *mainToolbar;
	FTFlipBarButtonItem *galleryFlipButton;
	
	UIView *mainView;
	
	UIView *cameraMainView;
	GPUImageView *cameraView;
	UIView *touchDetector;
	FTPhotoGridView *gridView;
	UITableView *optionsTable;
	FTCameraButtonView *flashButton;
	FTCameraButtonView *optionsButton;
    UISlider *filterSettingsSlider;
	AVCaptureSession *avSession;
	AVCaptureTorchMode torchMode;
	UIButton *snapButton;
	CGFloat optionsTableHeight;
	UIImageView *flyingView;
	MBProgressHUD *progressHud;
	
	UIView *galleryMainView;
	PAGalleryView *galleryDisplayView;
	PASharingView *sharingView;
	PAPhotoDetailView *galleryDetailView;
	
	NSMutableArray *optionsData;
	
	ALAssetsLibrary *library;
	NSMutableArray *assets;
	
	
	
}

@property (nonatomic) UIInterfaceOrientation orientation;

@property (nonatomic, strong) GPUImageStillCamera *stillCamera;


- (void)rotateElements;


@end
