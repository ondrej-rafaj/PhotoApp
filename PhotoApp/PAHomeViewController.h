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
#import "FTCameraButtonView.h"
#import "FTFlipButtonView.h"
#import "FTPhotoGridView.h"
#import "PAOptionsTableViewCell.h"
#import "GPUImage.h"


@interface PAHomeViewController : PAViewController <FTFlipButtonViewDelegate, UITableViewDelegate, UITableViewDataSource, PAOptionsTableViewCellDelegate> {
	
	UIToolbar *mainToolbar;
	
	UIView *mainView;
	GPUImageView *cameraView;
	UIView *settingsView;
	
	UIView *touchDetector;
	
	FTPhotoGridView *gridView;
	
	UITableView *optionsTable;
	NSMutableArray *data;
	
	FTCameraButtonView *flashButton;
	FTCameraButtonView *optionsButton;
	
	GPUImageStillCamera *stillCamera;
    GPUImageFilter *filter;
    UISlider *filterSettingsSlider;
	
	ALAssetsLibrary *library;
	
	AVCaptureSession *avSession;
	
	AVCaptureTorchMode torchMode;
	
}


@end
