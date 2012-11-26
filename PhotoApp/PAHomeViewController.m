//
//  PAHomeViewController.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PAViewStyles.h"
#import "PAAppDelegate.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "GPUImageStillCamera+LowPixelHandling.h"
#import "UIDevice+Hardware.h"
#import "UIImage+Tools.h"
#import "FTTracking.h"
#import "FTAlertView.h"
#import "FTLang.h"
#import "FTSystem.h"


#define degreesToRadians(x) (M_PI * (x) / 180.0)


@interface PAHomeViewController ()

@end

@implementation PAHomeViewController

@synthesize orientation = _orientation;
@synthesize stillCamera = _stillCamera;


#pragma mark Positioning

- (CGFloat)screenHeight {
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        return 568;
    }
    return 480;
}

- (BOOL)isBigScreen {
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        return YES;
    }
    return NO;
}

- (CGRect)frameForOptionsButton {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationPortrait) {
		return CGRectMake((320 - 8 - 75), 8, 75, 30);
	}
	else if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(8, 8, 30, 75);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - 8 - 30), ([self screenHeight] - 53 - 75 - 8), 30, 75);
	}
	else {
		return CGRectMake(8, 8, 75, 30);
	}
}

- (CGFloat)getFlashButtonWidth {
	PAConfigFlashMode m = [PAConfig flashMode];
	if (m == PAConfigFlashModeAuto) {
		return 90;
	}
	else if (m == PAConfigFlashModeOff || m == PAConfigFlashModeAlwaysOn) {
		return 82;
	}
	else  {
		return 78;
	}
}

- (CGRect)frameForFlashButton {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationPortrait) {
		return CGRectMake(8, 8, [self getFlashButtonWidth], 30);
	}
	else if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(8, ([self screenHeight] - 53 - [self getFlashButtonWidth] - 8), 30, [self getFlashButtonWidth]);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - 8 - 30), 8, 30, [self getFlashButtonWidth]);
	}
	else {
		return CGRectMake((320 - 8 - [self getFlashButtonWidth]), 8, [self getFlashButtonWidth], 30);
	}
}

- (CGRect)frameForCameraSwitchButton {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationPortrait) {
		return CGRectMake(((320 - 50) / 2), 8, 50, 30);
	}
	else if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(8, ((480 - 53 - 50) / 2), 30, 50);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - 8 - 30), ((480 - 53 - 50) / 2), 30, 50);
	}
	else {
		return CGRectMake(((320 - 50) / 2), 8, 50, 30);
	}
}

- (CGRect)frameForOptionsTable {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(56, (([self screenHeight] - 53 - 280) / 2), optionsTableHeight, 280);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - optionsTableHeight - 56), (([self screenHeight] - 53 - 280) / 2), optionsTableHeight, 280);
	}
	else {
		return CGRectMake(20, 56, 280, optionsTableHeight);
	}
}

- (CGRect)frameForGalleryDisplayView {
	return galleryMainView.bounds;
}

#pragma mark Data management

- (void)reloadGalleryElements {
	BOOL isData = ([assets count] > 0);
	if (isData) {
		[galleryFlipButton.flipButton.frontButton setImage:[UIImage imageWithCGImage:[(ALAsset *)[assets objectAtIndex:0] thumbnail]] forState:UIControlStateNormal];
	}
	[galleryFlipButton.flipButton setUserInteractionEnabled:isData];
	[UIView beginAnimations:nil context:nil];
	[galleryFlipButton.flipButton setAlpha:(isData ? 1 : 0)];
	[UIView commitAnimations];
	
	[galleryDisplayView setData:assets];
	[galleryDisplayView reloadData];
}

- (void)reloadData {
	assets = [NSMutableArray array];
	__block BOOL isGroup = NO;
	[library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		if (group) {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[PAConfig appName]]) {
				isGroup = YES;
				[group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (result) {
						[assets addObject:result];
					}
				}];
			}
		}
		
		[self performSelectorOnMainThread:@selector(reloadGalleryElements) withObject:nil waitUntilDone:NO];
	} failureBlock:^(NSError *error) {
		NSLog(@"Asset library error: %@", error);
	}];
	if (!isGroup) {
		[library addAssetsGroupAlbumWithName:[PAConfig appName] resultBlock:^(ALAssetsGroup *group) {
			NSLog(@"Library has been added: %@", group);
		} failureBlock:^(NSError *error) {
			NSLog(@"Add library error: %@", error);
		}];
	}
}

#pragma mark Creating elements

- (void)setButtonsForToolbarForFrontPage:(BOOL)front animated:(BOOL)animated {
	NSMutableArray *arr = [NSMutableArray array];
	
	if (!galleryFlipButton) {
		galleryFlipButton = [[FTFlipBarButtonItem alloc] initWithFlipBarButtonItem];
		[galleryFlipButton.flipButton setDelegate:self];
		[galleryFlipButton.flipButton.backButton setBackgroundColor:[UIColor blackColor]];
		[galleryFlipButton.flipButton.backButton setImage:[UIImage imageNamed:@"PA_cameraIconFlip.png"] forState:UIControlStateNormal];
	}
	[arr addObject:galleryFlipButton];
	
	UIBarButtonItem *flex;
	
	if (front) {
		flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[arr addObject:flex];
		
		if (!snapButton) {
			snapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 102, 37)];
			[snapButton setBackgroundImage:[UIImage imageNamed:@"PA_cameraButton.png"] forState:UIControlStateNormal];
			[snapButton setImage:[UIImage imageNamed:@"PA_cameraIconBig.png"] forState:UIControlStateNormal];
			[snapButton addTarget:self action:@selector(didClickTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		UIBarButtonItem *snap = [[UIBarButtonItem alloc] initWithCustomView:snapButton];
		[arr addObject:snap];
	}
	
	flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[arr addObject:flex];
	
	// TODO: Load image from library
	if (YES) {
		UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		[fixed setWidth:34];
		[arr addObject:fixed];
	}
	else {
		UIBarButtonItem *lib = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(selectImageFromImagePicker:)];
		[arr addObject:lib];
	}
	
	[mainToolbar setItems:arr animated:animated];
}

- (void)createToolbar {
    CGFloat x = [self screenHeight];
	mainToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (x - 53), 320, 53)];
	[mainToolbar setBackgroundImage:[UIImage imageNamed:@"PA_bottomBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	[PAViewStyles setStylesToToolbar:mainToolbar];
	[self.view addSubview:mainToolbar];
	
	[self setButtonsForToolbarForFrontPage:YES animated:NO];
}

- (void)createOptionsTable {
	CGFloat s = [self numberOfSectionsInTableView:optionsTable];
	CGFloat r;
	optionsTableHeight = 0;
	for (int i = 0; i < s; i++) {
		r = [self tableView:optionsTable numberOfRowsInSection:i];
		for (int x = 0; x < r; x++) {
			optionsTableHeight += [self tableView:optionsTable heightForRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:i]];
		}
	}
    idealOptionsTableHeight = optionsTableHeight;
	BOOL scrollable = NO;
	if (optionsTableHeight > 240) {
		optionsTableHeight = 240;
		scrollable = YES;
	}
	optionsTable = [[UITableView alloc] initWithFrame:[self frameForOptionsTable] style:UITableViewStylePlain];
	[optionsTable setAlpha:0];
	[optionsTable setScrollEnabled:scrollable];
	[optionsTable setDelegate:self];
	[optionsTable setDataSource:self];
	[optionsTable setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	[optionsTable.layer setCornerRadius:15];
	[optionsTable.layer setBorderWidth:1];
	[optionsTable.layer setBorderColor:[UIColor darkGrayColor].CGColor];
	[cameraMainView addSubview:optionsTable];
}

- (NSString *)getFlashButtonTitle {
	PAConfigFlashMode m = [PAConfig flashMode];
	if (m == PAConfigFlashModeOn) {
		return @"Flash On";
	}
	else if (m == PAConfigFlashModeAuto) {
		return @"Flash Auto";
	}
	else if (m == PAConfigFlashModeAlwaysOn) {
		return @"Flash On!";
	}
	else {
		return @"Flash Off";
	}
}

- (void)createFunctionButtons {
	optionsData = [config optionsData];
	
	if ([PAConfig isFirstLaunch]) {
		for (NSDictionary *a in optionsData) {
			[[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:[a objectForKey:@"identifier"]];
		}
		[[NSUserDefaults standardUserDefaults]synchronize];
	}
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch]) {
		flashMode = [PAConfig flashMode];
		NSString *title = [self getFlashButtonTitle];
		flashButton = [[FTCameraButtonView alloc] initWithFrame:[self frameForFlashButton]];
		[flashButton addTarget:self action:@selector(didClickFlashPhoto:) forControlEvents:UIControlEventTouchUpInside];
		[flashButton setTitle:title forState:UIControlStateNormal];
		[cameraMainView addSubview:flashButton];
	}
	else flashMode = PAConfigFlashModeOff;
	if (NO) {
		cameraSwitchButton = [[FTCameraButtonView alloc] initWithFrame:[self frameForCameraSwitchButton]];
		[cameraSwitchButton addTarget:self action:@selector(didClickSwitchCameraButton:) forControlEvents:UIControlEventTouchUpInside];
		[cameraSwitchButton setTitle:@"" forState:UIControlStateNormal];
		[cameraSwitchButton setImage:[UIImage imageNamed:@"PA_rotateCam.png"] forState:UIControlStateNormal];
		[cameraMainView addSubview:cameraSwitchButton];
	}
	
	optionsButton = [[FTCameraButtonView alloc] initWithFrame:[self frameForOptionsButton]];
	[optionsButton addTarget:self action:@selector(didClickOptionsPhoto:) forControlEvents:UIControlEventTouchUpInside];
	[optionsButton setTitle:@"Options" forState:UIControlStateNormal];
	[cameraMainView addSubview:optionsButton];
	
	[self createOptionsTable];
}

- (void)createMainView {
	CGRect r = [[UIScreen mainScreen] bounds];
	UIView *primaryView = [[UIView alloc] initWithFrame:r];
    [primaryView setBackgroundColor:[UIColor blackColor]];
	[self setView:primaryView];
	
	mainView = [[UIView alloc] initWithFrame:r];
	[self.view addSubview:mainView];
	
	mainViewAi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[mainViewAi startAnimating];
	[mainViewAi setAlpha:0];
	[mainView addSubview:mainViewAi];
	[mainViewAi centerInSuperView];
	[mainViewAi positionAtY:([mainViewAi yPosition] - 53)];
	[mainViewAi setAutoresizingCenter];
}

- (void)createCameraView {
	CGRect r = mainView.bounds;
	cameraMainView = [[UIView alloc] initWithFrame:r];
	[mainView addSubview:cameraMainView];
	
	r.origin.y -= 27;
	cameraView = [[GPUImageView alloc] initWithFrame:r];
	
	[cameraView setFillMode:kGPUImageFillModePreserveAspectRatio];
	if ([[UIDevice currentDevice] iPhone4] || [[UIDevice currentDevice] iPhone5iPod5]) {
		[cameraView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
	}
	else {
		[cameraView setFillMode:kGPUImageFillModePreserveAspectRatio];
	}
	
	[cameraView setBackgroundColorRed:0 green:0 blue:0 alpha:0];
	[cameraMainView addSubview:cameraView];
	
	_stillCamera = [[GPUImageStillCamera alloc] init];
	[_stillCamera setOutputImageOrientation:UIInterfaceOrientationPortrait];
	
	[config configureForCamera:_stillCamera andCameraView:cameraView];
	
	[_stillCamera startCameraCapture];
}

- (void)createCameraViewElements {
	gridView = [[FTPhotoGridView alloc] init];
	[cameraMainView addSubview:gridView];

	touchDetector = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[touchDetector setBackgroundColor:[UIColor clearColor]];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreenOnce:)];
	[touchDetector addGestureRecognizer:tap];
	[cameraMainView addSubview:touchDetector];
		
	progressHud = [[MBProgressHUD alloc] initWithView:self.view];
	[progressHud setAnimationType:MBProgressHUDAnimationFade];
	[progressHud setDelegate:self];
	[self.view addSubview:progressHud];
}

- (void)createGalleryView {
	CGRect r = self.view.bounds;
	r.size.height -= 53;
	galleryMainView = [[UIView alloc] initWithFrame:r];
	[galleryMainView setBackgroundColor:[UIColor blackColor]];
	
	galleryDisplayView = [[PAGalleryView alloc] initWithFrame:[self frameForGalleryDisplayView]];
	[galleryDisplayView setDelegate:self];
	[galleryMainView setBackgroundColor:[UIColor clearColor]];
	[galleryMainView addSubview:galleryDisplayView];
	
	[self reloadData];
}

- (void)createSharingView {
	sharingView = [[PASharingView alloc] initWithFrame:self.view.bounds];
	[sharingView setGalleryDelegate:galleryDisplayView];
	[self.view addSubview:sharingView];
}

- (void)enableVolumeButtonAsCameraShutter {
	AVAudioPlayer* p = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PA_sound_camera" ofType:@"wav"]] error:NULL];
	[p prepareToPlay];
	[p stop];
	
	CGRect frame = CGRectMake(-1000, -1000, 100, 100);
	MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:frame];
	[volumeView sizeToFit];
	[self.view addSubview:volumeView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)createAllElements {
	library = [[ALAssetsLibrary alloc] init];
	[self createCameraViewElements];
	[self createFunctionButtons];
	[self createGalleryView];
	[self createToolbar];
	[self createSharingView];
	[self enableVolumeButtonAsCameraShutter];
}

#pragma mark HUD delegate method

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[FTTracking logEvent:@"Camera: Photo saved successfully"];
}

#pragma mark Saving photo

- (void)hideHud {
	[progressHud hide:YES];
	isTakingPhoto = NO;
}

- (void)finishSavingImage {
	[progressHud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_checkmark.png"]]];
	[progressHud setMode:MBProgressHUDModeCustomView];
	[progressHud setLabelText:@"Completed"];
	[progressHud setDetailsLabelText:nil];
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
}

- (void)saveImage:(UIImage *)image {
	UIImageOrientation o = UIImageOrientationUp;
	if (_orientation == UIInterfaceOrientationLandscapeRight) {
		o = UIImageOrientationLeft;
	}
	else if (_orientation == UIInterfaceOrientationLandscapeLeft) {
		o = UIImageOrientationRight;
	}
	else if (_orientation == UIInterfaceOrientationPortraitUpsideDown) {
		o = UIImageOrientationDown;
	}
	image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:o];
	[library saveImage:image toAlbum:[PAConfig appName] withCompletionBlock:^(NSError *error) {
		if (error != nil) {
			NSLog(@"Save image error: %@", [error description]);
		}
		else {
			library = [[ALAssetsLibrary alloc] init];
		}
		[self performSelectorOnMainThread:@selector(finishSavingImage) withObject:nil waitUntilDone:NO];
	}];
}

- (void)saveImageWithoutOrientation:(UIImage *)image {
	[library saveImage:image toAlbum:[PAConfig appName] withCompletionBlock:^(NSError *error) {
		if (error != nil) {
			NSLog(@"Save image error: %@", [error description]);
		}
		else {
			//library = nil;
			library = [[ALAssetsLibrary alloc] init];
		}
		[self performSelectorOnMainThread:@selector(finishSavingImage) withObject:nil waitUntilDone:NO];
	}];
}

- (void)prepareImage:(UIImage *)image {
	@autoreleasepool {
		image = [config applyFiltersManuallyOnImage:image];
		[self saveImageWithoutOrientation:image];
		//[_stillCamera startCameraCapture];
	}
}

- (void)startBackgroundSaving:(UIImage *)image {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(saveImage:) withObject:image];
	}
}

- (void)startBackgroundSavingFromLibrary:(UIImage *)image {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(prepareImage:) withObject:image];
	}
}

#pragma mark Flip button delegate methods

- (void)flipButtonView:(FTFlipButtonView *)view didSelectViewScreen:(FTFlipButtonViewScreen)screen {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:galleryFlipButton.flipButton.rotationInterval];
	if (screen == FTFlipButtonViewScreenFront) {
		[FTTracking logEvent:@"Camera"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mainView cache:YES];
		[mainView addSubview:cameraMainView];
		[galleryMainView removeFromSuperview];
		
	}
	else {
		[FTTracking logEvent:@"Gallery"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
		[mainView addSubview:galleryMainView];
		[cameraMainView removeFromSuperview];
	}
	[UIView commitAnimations];
	
	if (screen == FTFlipButtonViewScreenFront) {
		[self setButtonsForToolbarForFrontPage:YES animated:YES];
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:_stillCamera selector:@selector(startCameraCapture) userInfo:nil repeats:NO];
	}
	else {
		[self setButtonsForToolbarForFrontPage:NO animated:YES];
		[_stillCamera stopCameraCapture];
	}
}

#pragma mark Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[picker dismissModalViewControllerAnimated:YES];
	
	NSLog(@"Did finish picking photo with size: %@", NSStringFromCGSize(image.size));
	[NSThread detachNewThreadSelector:@selector(startBackgroundSavingFromLibrary:) toTarget:self withObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Button actions

- (void)selectImageFromImagePicker:(UIBarButtonItem *)sender {
	UIImagePickerController *c = [[UIImagePickerController alloc] init];
	[c setDelegate:self];
	[c setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[self presentViewController:c animated:YES completion:^{
        
    }];
}

- (void)reloadTorch {
	if ([_stillCamera.inputCamera isTorchAvailable]) {
		NSError *error = nil;
		if (![_stillCamera.inputCamera lockForConfiguration:&error])
		{
			NSLog(@"Error locking for configuration: %@", error);
		}
		if (_stillCamera.cameraPosition == AVCaptureDevicePositionBack) {
			if (flashMode == PAConfigFlashModeAlwaysOn) {
				[_stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
				[_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
			}
			else {
				[_stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
				if (flashMode == PAConfigFlashModeOn) [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
				else if (flashMode == PAConfigFlashModeAuto) [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeAuto];
				else [_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
			}
		}
		else {
			[_stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
			[_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
		}
		[_stillCamera.inputCamera unlockForConfiguration];
	}
}

- (void)takePhoto {
	if (!isTakingPhoto) {
		isTakingPhoto = YES;
		
		[progressHud setMode:MBProgressHUDModeIndeterminate];
		[progressHud setLabelText:@"Saving photo"];
		[progressHud setDetailsLabelText:@"to the gallery"];
		[progressHud show:YES];
		
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self];
		[animation setDuration:0.4];
		animation.timingFunction = UIViewAnimationCurveEaseInOut;
		[animation setType:@"cameraIris"];
		[cameraView.layer addAnimation:animation forKey:nil];
		
		[_stillCamera capturePhotoAsJPEGProcessedUpToFilter:[config upToCameraFilter] withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
			UIImage *processedImage = [UIImage imageWithData:processedJPEG];
			NSLog(@"Did finish picking photo with size: %@", NSStringFromCGSize(processedImage.size));
			[NSThread detachNewThreadSelector:@selector(startBackgroundSaving:) toTarget:self withObject:processedImage];
			
			[progressHud setMode:MBProgressHUDModeIndeterminate];
			[progressHud setLabelText:@"Saving photo"];
			[progressHud setDetailsLabelText:@"to the gallery"];
			[progressHud show:YES];
		}];
	}
}

- (void)didClickTakePhoto:(UIBarButtonItem *)sender {
	[FTTracking logEvent:@"Camera: Take photo"];
	[self takePhoto];
}

- (void)volumeChanged:(NSNotification *)notification{
	//[FTTracking logEvent:@"Camera: Take photo using volume button"];
    //[self takePhoto];
}

- (void)didClickOptionsPhoto:(UIButton *)sender {
	[FTTracking logEvent:@"Camera: Toggle options"];
	CGFloat alpha = (optionsTable.alpha > 0) ? 0 : 1;
	if (alpha == 0) {
		[optionsButton setTitle:@"Options" forState:UIControlStateNormal];
	}
	else {
		[optionsButton setTitle:@"Done" forState:UIControlStateNormal];
	}
	[optionsButton enableHighlight:(BOOL)alpha];
	[UIView beginAnimations:nil context:nil];
	[optionsTable setAlpha:alpha];
	[UIView commitAnimations];
}

- (void)didClickFlashPhoto:(UIButton *)sender {
	[FTTracking logEvent:@"Camera: Toggle flash"];
	
	PAConfigFlashMode m = [PAConfig flashMode];
	if (m == PAConfigFlashModeOff) m = PAConfigFlashModeAuto;
	else if (m == PAConfigFlashModeAuto) m = PAConfigFlashModeOn;
	else if (m == PAConfigFlashModeOn) m = PAConfigFlashModeAlwaysOn;
	else if (m == PAConfigFlashModeAlwaysOn) m = PAConfigFlashModeOff;
	flashMode = m;
	[PAConfig setFlashMode:m];
	
	[flashButton setTitle:[self getFlashButtonTitle] forState:UIControlStateNormal];
	CGRect r = flashButton.frame;
	if (UIInterfaceOrientationIsPortrait(_orientation)) r.size.width = [self getFlashButtonWidth];
	else r.size.height = [self getFlashButtonWidth];
	[UIView beginAnimations:nil context:nil];
	[flashButton setFrame:r];
	[UIView commitAnimations];
	if (optionsTable.alpha > 0) [self didClickOptionsPhoto:optionsButton];
	[optionsButton enableHighlight:NO];
	
	[self reloadTorch];
}

- (void)didClickSwitchCameraButton:(UIButton *)sender {
	[mainToolbar setItems:nil animated:YES];
	[_stillCamera stopCameraCapture];
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
		[cameraMainView positionAtX:-320];
		[mainViewAi setAlpha:1];
	} completion:^(BOOL finished) {
		[cameraMainView positionAtX:320];
		if (_stillCamera.cameraPosition == AVCaptureDevicePositionBack) {
			flashMode = PAConfigFlashModeOff;
			[self reloadTorch];
		}
		[_stillCamera rotateCamera];
		[_stillCamera startCameraCapture];
		if (_stillCamera.cameraPosition == AVCaptureDevicePositionBack) {
			AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
			if ([device hasTorch]) {
				[flashButton setHidden:NO];
				flashMode = [PAConfig flashMode];
			}
			[cameraView setTransform:CGAffineTransformMakeScale(1, 1)];
		}
		else {
			[flashButton setHidden:YES];
			[cameraView setTransform:CGAffineTransformMakeScale(-1, 1)];
		}
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
			[cameraMainView positionAtX:0];
			[mainViewAi setAlpha:0];
		} completion:^(BOOL finished) {
			[self setButtonsForToolbarForFrontPage:YES animated:YES];
		}];
	}];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTorch) userInfo:nil repeats:NO];
}

#pragma mark Options table data source & delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [optionsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *d = [optionsData objectAtIndex:indexPath.row];
	if ([[d objectForKey:@"type"] isEqualToString:@"switch"]) return 50.0f;
	else return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"optionsTableViewCell";
	PAOptionsTableViewCell *cell = (PAOptionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[PAOptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	NSDictionary *d = [optionsData objectAtIndex:indexPath.row];
	[cell setIdentifier:[d objectForKey:@"identifier"]];
	[cell.titleLabel setText:[d objectForKey:@"name"]];
	[cell.descriptionLabel setText:[d objectForKey:@"description"]];
	[cell setType:[d objectForKey:@"type"]];
	
	if ([[d objectForKey:@"type"] isEqualToString:@"slider"]) {
		[cell.valueSlider setMinimumTrackTintColor:[UIColor darkGrayColor]];
		[cell.valueSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
		[config configureSlider:cell.valueSlider forIdentifier:[d objectForKey:@"identifier"]];
		[cell.enableSwitch setHidden:YES];
		[cell.valueSlider setHidden:NO];
	}
	else {
		[cell.valueSlider setHidden:YES];
		[cell.enableSwitch setHidden:NO];
	}
	
	[cell setDelegate:self];
	[cell reloadData];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Option cell delegate methods

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeStatusForIdentifier:(NSString *)identifier {
	//[config 
	if ([identifier isEqualToString:@"photoGrid"]) {
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
		CGFloat alpha;
		if (enabled) alpha = 1;
		else alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[gridView setAlpha:alpha];
		[UIView commitAnimations];
		if (enabled) [FTTracking logEvent:@"Camera: Grid enabled"];
		else [FTTracking logEvent:@"Camera: Grid disabled"];
	}
	else {
		[config didChangeValueForIdentifier:identifier];
	}
}

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeValueTo:(CGFloat)value forIdentifier:(NSString *)identifier {
	[config setIntensity:value forIdentifier:identifier];
}

#pragma mark Tap detector

- (void)didTapScreenOnce:(UITapGestureRecognizer *)recognizer {
	if (optionsTable.alpha > 0) [self didClickOptionsPhoto:optionsButton];
}

#pragma mark Rotating elements

- (void)rotateElements {
	CGFloat deg = 0;
	if (_orientation == UIInterfaceOrientationPortraitUpsideDown) deg = 180;
	else if (_orientation == UIInterfaceOrientationLandscapeRight) deg = 90;
	else if (_orientation == UIInterfaceOrientationLandscapeLeft) deg = -90;
	
	CGFloat rad = (deg == 0) ? 0 : degreesToRadians(deg);
	
	BOOL isShowingOptionsTable = (optionsTable.alpha > 0);
	
	[UIView animateWithDuration:0.3 animations:^{
		// Setting alpha channels
		[flashButton setAlpha:0];
		[optionsButton setAlpha:0];
		[cameraSwitchButton setAlpha:0];
		[optionsTable setAlpha:0];
		// Setting rotations
		[snapButton.imageView setTransform:CGAffineTransformMakeRotation(rad)];
		[galleryFlipButton.flipButton setTransform:CGAffineTransformMakeRotation(rad)];
		[progressHud setTransform:CGAffineTransformMakeRotation(rad)];
		[galleryDisplayView setTransform:CGAffineTransformMakeRotation(rad)];
		[sharingView.imageViewHolder setTransform:CGAffineTransformMakeRotation(rad)];
		[sharingView.buttonHolder setTransform:CGAffineTransformMakeRotation(rad)];
		[galleryDetailView.imageViewHolder setTransform:CGAffineTransformMakeRotation(rad)];
		// Setting custom values
		[galleryDetailView setOrientation:_orientation];
		// Setting frames
		[galleryDisplayView setFrame:[self frameForGalleryDisplayView]];
	} completion:^(BOOL finished) {
		[flashButton setTransform:CGAffineTransformMakeRotation(rad)];
		[optionsButton setTransform:CGAffineTransformMakeRotation(rad)];
		[cameraSwitchButton setTransform:CGAffineTransformMakeRotation(rad)];
		[optionsTable setTransform:CGAffineTransformMakeRotation(rad)];
		
		[optionsButton setFrame:[self frameForOptionsButton]];
		[flashButton setFrame:[self frameForFlashButton]];
		[cameraSwitchButton setFrame:[self frameForCameraSwitchButton]];
		[optionsTable setFrame:[self frameForOptionsTable]];
		
		[UIView animateWithDuration:0.3 animations:^{
			[flashButton setAlpha:1];
			[optionsButton setAlpha:1];
			[cameraSwitchButton setAlpha:1];
			if (isShowingOptionsTable) [optionsTable setAlpha:1];
		} completion:^(BOOL finished) {
			
		}];
	}];
}	

#pragma mark Gallery view sharing delegate

- (NSString *)shareStringForImage {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:[PAConfig dateFormat]];
	return [NSString stringWithFormat:@"Photo from %@ %@ app on %@", [PAConfig appName], ([FTSystem isTabletSize] ? @"iPad" : @"iPhone"), [dateFormat stringFromDate:[NSDate date]]];
}

- (UIImage *)imageForSharingFromAsset:(ALAsset *)asset {
	ALAssetRepresentation *rep = [asset defaultRepresentation];
	CGImageRef iref = [rep fullResolutionImage];
	UIImage *inputImage = [UIImage imageWithCGImage:iref];
	inputImage = [UIImage imageWithCGImage:[inputImage scaleWithMaxSize:800].CGImage scale:1 orientation:[rep orientation]];
	return inputImage;
}

- (void)galleryView:(PAGalleryView *)gallery requestsPostcardFor:(ALAsset *)asset {
	ALAssetRepresentation *rep = [asset defaultRepresentation];
	CGImageRef iref = [rep fullResolutionImage];
	SYSincerelyController *controller = [[SYSincerelyController alloc] initWithImages:[NSArray arrayWithObject:[UIImage imageWithCGImage:iref]] product:SYProductTypePostcard applicationKey:[PAConfig sincerelyApiKey] delegate:self];
	if (controller) {
		[self presentViewController:controller animated:YES completion:^{
            
        }];
	}
}

- (void)galleryView:(PAGalleryView *)gallery requestsSharingOptionFor:(ALAsset *)asset {
	[self galleryView:gallery requestsPostcardFor:asset];
}

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

- (void)galleryView:(PAGalleryView *)gallery requestsDetailFor:(ALAsset *)asset {
    NSInteger index = [galleryDisplayView.data indexOfObject:asset];
    FTPhotoBrowserViewController *c = [[FTPhotoBrowserViewController alloc] init];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_logo"]];
    [c.view addSubview:logo];
    [logo positionAtX:-35 andY:120];
    [c.view sendSubviewToBack:logo];
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, DegreesToRadians(-90));
    logo.transform = rotationTransform;
    [c setStartIndex:index];
    [c.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    [c setDataSource:self];
    [c setDelegate:self];
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark Photo view controller delegate and data source methods

- (NSInteger)numberOfItemsInPhotoBrowserViewController:(FTPhotoBrowserViewController *)controller {
    return [galleryDisplayView.data count];
}

- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsImageWithIndex:(NSInteger)index {
    if (index >= [galleryDisplayView.data count] || index < 0) return nil;
    ALAsset *asset = [galleryDisplayView.data objectAtIndex:index];
    ALAssetRepresentation *rep = [asset defaultRepresentation];
	CGImageRef iref = [rep fullResolutionImage];
	UIImage *image = [UIImage imageWithCGImage:iref];
    return image;
}

- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsThumbnailImageWithIndex:(NSInteger)index {
    if (index >= [galleryDisplayView.data count] || index < 0) return nil;
    ALAsset *asset = [galleryDisplayView.data objectAtIndex:index];
    ALAssetRepresentation *rep = [asset defaultRepresentation];
	CGImageRef iref = [rep fullScreenImage];
	UIImage *image = [UIImage imageWithCGImage:iref];
    return image;
}

- (UIImage *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsImageForSharingWithIndex:(NSInteger)index {
    if (index >= [galleryDisplayView.data count]) return nil;
    return nil;
}

- (ALAsset *)photoBrowserViewController:(FTPhotoBrowserViewController *)controller requestsAssetWithIndex:(NSInteger)index {
    ALAsset *asset = [galleryDisplayView.data objectAtIndex:index];
    return asset;
}

- (void)photoBrowserViewController:(FTPhotoBrowserViewController *)controller didScrollToPageWithIndex:(NSInteger)index {
    
}

#pragma mark Sincerely delegate methods

- (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
} 

#pragma mark View lifecycle

- (void)loadView {
	[super loadView];
	
	config = [[PAConfig alloc] init];
	
	[self createMainView];
	[self createCameraView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createAllElements];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self reloadTorch];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidUnload {
    library = nil;
    [super viewDidUnload];
}


@end