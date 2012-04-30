//
//  PAHomeViewController.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PAViewStyles.h"
#import "PAAppDelegate.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "FlurryAnalytics.h"
#import "PAConfig.h"


#define degreesToRadians(x) (M_PI * (x) / 180.0)


@interface PAHomeViewController ()

@end

@implementation PAHomeViewController

@synthesize orientation = _orientation;


#pragma mark Positioning

- (CGRect)frameForOptionsButton {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationPortrait) {
		return CGRectMake((320 - 8 - 75), 8, 75, 30);
	}
	else if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(8, 8, 30, 75);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - 8 - 30), (480 - 53 - 75 - 8), 30, 75);
	}
	else {
		return CGRectMake(8, 8, 75, 30);
	}
}

- (CGFloat)getFlashButtonWidth {
	AVCaptureTorchMode m = [PAConfig torchMode];
	if (m == AVCaptureTorchModeAuto) {
		return 88;
	}
	else if (m == AVCaptureTorchModeOff) {
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
		return CGRectMake(8, (480 - 53 - [self getFlashButtonWidth] - 8), 30, [self getFlashButtonWidth]);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - 8 - 30), 8, 30, [self getFlashButtonWidth]);
	}
	else {
		return CGRectMake((320 - 8 - [self getFlashButtonWidth]), 8, [self getFlashButtonWidth], 30);
	}
}

- (CGRect)frameForOptionsTable {
	UIInterfaceOrientation o = _orientation;
	if (o == UIInterfaceOrientationLandscapeLeft) {
		return CGRectMake(56, ((480 - 53 - 280) / 2), optionsTableHeight, 280);
	}
	else if (o == UIInterfaceOrientationLandscapeRight) {
		return CGRectMake((320 - optionsTableHeight - 56), ((480 - 53 - 280) / 2), optionsTableHeight, 280);
	}
	else {
		return CGRectMake(20, 56, 280, optionsTableHeight);
	}
}

#pragma mark Data management

- (void)reloadData {
	assets = [NSMutableArray array];
	
	[library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		if (group != nil) {
			NSLog(@"Group name: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[PAConfig photoGalleryName]]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (result != nil) {
						NSLog(@"See asset: %@", result);
						[assets addObject:result];
						[galleryFlipButton.flipButton.frontButton setImage:[UIImage imageWithCGImage:[result thumbnail]] forState:UIControlStateNormal];
					}
				}];
			}
		}
		BOOL isData = ([assets count] > 0);
		[galleryFlipButton.flipButton setUserInteractionEnabled:isData];
		[UIView beginAnimations:nil context:nil];
		[galleryFlipButton.flipButton setAlpha:(isData ? 1 : 0)];
		[UIView commitAnimations];
		
		[galleryDisplayView setData:assets];
		[galleryDisplayView reloadData];
		
	} failureBlock:^(NSError *error) {
		
	}];
}

#pragma mark Creating elements

- (void)setButtonsForToolbarForFrontPage:(BOOL)front animated:(BOOL)animated {
	NSMutableArray *arr = [NSMutableArray array];
	
	if (!galleryFlipButton) {
		galleryFlipButton = [[FTFlipBarButtonItem alloc] initWithFlipBarButtonItem];
		[galleryFlipButton.flipButton setDelegate:self];
		[galleryFlipButton.flipButton.frontButton addTarget:self action:@selector(didClickGallery:) forControlEvents:UIControlEventTouchUpInside];
		[galleryFlipButton.flipButton.backButton addTarget:self action:@selector(didClickGallery:) forControlEvents:UIControlEventTouchUpInside];
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
	
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixed setWidth:34];
	[arr addObject:flex];
	
	//	lib = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didClickLibrary:)];
	//	[arr addObject:lib];
	
	[mainToolbar setItems:arr animated:animated];
}

- (void)createToolbar {
	mainToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (480 - 53), 320, 53)];
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
	optionsTable = [[UITableView alloc] initWithFrame:[self frameForOptionsTable] style:UITableViewStylePlain];
	[optionsTable setAlpha:0];
	[optionsTable setScrollEnabled:NO];
	[optionsTable setDelegate:self];
	[optionsTable setDataSource:self];
	[optionsTable setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	[optionsTable.layer setCornerRadius:15];
	[optionsTable.layer setBorderWidth:1];
	[optionsTable.layer setBorderColor:[UIColor darkGrayColor].CGColor];
	[cameraMainView addSubview:optionsTable];
}

- (NSString *)getFlashButtonTitle {
	AVCaptureTorchMode m = [PAConfig torchMode];
	if (m == AVCaptureTorchModeOn) {
		return @"Flash On";
	}
	else {
		return @"Flash Off";
	}
}

- (NSMutableDictionary *)dictionaryWithName:(NSString *)name withDescription:(NSString *)desc withIdentifier:(NSString *)identifier andType:(NSString *)type {
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[d setValue:name forKey:@"name"];
	[d setValue:desc forKey:@"description"];
	[d setValue:identifier forKey:@"identifier"];
	[d setValue:type forKey:@"type"];
	return d;
}

- (NSMutableDictionary *)dictionaryWithName:(NSString *)name withDescription:(NSString *)desc andIdentifier:(NSString *)identifier {
	return [self dictionaryWithName:name withDescription:desc withIdentifier:identifier andType:@"switch"];
}

- (void)createFunctionButtons {
	data = [NSMutableArray array];
	[data addObject:[self dictionaryWithName:@"Grid" withDescription:@"Enables photo grid" andIdentifier:@"photoGrid"]];
	[data addObject:[self dictionaryWithName:@"Vignette" withDescription:@"Enables vignette around picture" andIdentifier:@"photoVignette"]];
	[data addObject:[self dictionaryWithName:@"Intensity" withDescription:@"Intensity of the sepia effect" withIdentifier:@"photoEffectIntensity" andType:@"slider"]];
	
	if ([PAConfig isFirstLaunch]) {
		for (NSDictionary *a in data) {
			[[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:[a objectForKey:@"identifier"]];
		}
		[[NSUserDefaults standardUserDefaults]synchronize];
	}
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch]) {
		torchMode = [PAConfig torchMode];
		NSString *title = [self getFlashButtonTitle];
		flashButton = [[FTCameraButtonView alloc] initWithFrame:[self frameForFlashButton]];
		[flashButton addTarget:self action:@selector(didClickFlashPhoto:) forControlEvents:UIControlEventTouchUpInside];
		[flashButton setTitle:title forState:UIControlStateNormal];
		[cameraMainView addSubview:flashButton];
	}
	else torchMode = AVCaptureTorchModeOff;
	
	optionsButton = [[FTCameraButtonView alloc] initWithFrame:[self frameForOptionsButton]];
	[optionsButton addTarget:self action:@selector(didClickOptionsPhoto:) forControlEvents:UIControlEventTouchUpInside];
	[optionsButton setTitle:@"Options" forState:UIControlStateNormal];
	[cameraMainView addSubview:optionsButton];
	
	[self createOptionsTable];
}

- (void)replaceMainView {
	CGRect r = [[UIScreen mainScreen] bounds];
	UIView *primaryView = [[UIView alloc] initWithFrame:r];
    [primaryView setBackgroundColor:[UIColor blackColor]];
	[self setView:primaryView];
	
	mainView = [[UIView alloc] initWithFrame:r];
	[self.view addSubview:mainView];
	
	r = mainView.bounds;
	cameraMainView = [[UIView alloc] initWithFrame:r];
	[mainView addSubview:cameraMainView];
	
	r.origin.y -= 27;
    cameraView = [[GPUImageView alloc] initWithFrame:r];
	[cameraView setFillMode:kGPUImageFillModePreserveAspectRatio];
	[cameraView setBackgroundColorRed:0 green:0 blue:0 alpha:0];
	[cameraMainView addSubview:cameraView];

	stillCamera = [[GPUImageStillCamera alloc] init];
    filter = [[GPUImageSepiaFilter alloc] init];
	[filter prepareForImageCapture];
	
	vignette = [[GPUImageVignetteFilter alloc] init];
	[vignette addTarget:filter];
	[vignette prepareForImageCapture];
	
	GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
    [stillCamera addTarget:rotationFilter];
    [rotationFilter addTarget:vignette];
    [filter addTarget:cameraView];
	
	GPUImageSepiaFilter *s = [[GPUImageSepiaFilter alloc] init];
	[s addTarget:cameraView];
    
    [stillCamera startCameraCapture];
}

- (void)createCameraView {
	
	/*
	 
	 - (UIImage*)lomo
	 {
	 UIImage *image = [[self saturate:1.2] contrast:1.15];
	 NSArray *redPoints = [NSArray arrayWithObjects:
	 [NSValue valueWithCGPoint:CGPointMake(0, 0)],
	 [NSValue valueWithCGPoint:CGPointMake(137, 118)],
	 [NSValue valueWithCGPoint:CGPointMake(255, 255)],
	 [NSValue valueWithCGPoint:CGPointMake(255, 255)],
	 nil];
	 NSArray *greenPoints = [NSArray arrayWithObjects:
	 [NSValue valueWithCGPoint:CGPointMake(0, 0)],
	 [NSValue valueWithCGPoint:CGPointMake(64, 54)],
	 [NSValue valueWithCGPoint:CGPointMake(175, 194)],
	 [NSValue valueWithCGPoint:CGPointMake(255, 255)],
	 nil];
	 NSArray *bluePoints = [NSArray arrayWithObjects:
	 [NSValue valueWithCGPoint:CGPointMake(0, 0)],
	 [NSValue valueWithCGPoint:CGPointMake(59, 64)],
	 [NSValue valueWithCGPoint:CGPointMake(203, 189)],
	 [NSValue valueWithCGPoint:CGPointMake(255, 255)],
	 nil];
	 image = [[[image applyCurve:redPoints toChannel:CurveChannelRed] 
	 applyCurve:greenPoints toChannel:CurveChannelGreen]
	 applyCurve:bluePoints toChannel:CurveChannelBlue];
	 
	 return [image darkVignette];
	 }
	 
	 */
	
	gridView = [[FTPhotoGridView alloc] init];
	[cameraMainView addSubview:gridView];

	touchDetector = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[touchDetector setBackgroundColor:[UIColor clearColor]];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreenOnce:)];
	[touchDetector addGestureRecognizer:tap];
	[cameraMainView addSubview:touchDetector];
	
	flyingView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[flyingView setBackgroundColor:[UIColor blackColor]];
	[flyingView setAlpha:0];
	[cameraMainView addSubview:flyingView];
	
	progressHud = [[MBProgressHUD alloc] initWithView:self.view];
	[progressHud setAnimationType:MBProgressHUDAnimationFade];
	[progressHud setDelegate:self];
	[self.view addSubview:progressHud];
}

- (void)createGalleryView {
	galleryMainView = [[UIView alloc] initWithFrame:self.view.bounds];
	[galleryMainView setBackgroundColor:[UIColor blackColor]];
	
	galleryDisplayView = [[PAGalleryView alloc] initWithFrame:galleryMainView.bounds];
	[galleryMainView setBackgroundColor:[UIColor clearColor]];
	[galleryMainView addSubview:galleryDisplayView];
	
	[self reloadData];
}

- (void)createAllElements {
	library = [[ALAssetsLibrary alloc] init];
	[self createCameraView];
	[self createFunctionButtons];
	[self createGalleryView];
	[self createToolbar];
}

#pragma mark HUD delegate method

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[FlurryAnalytics logEvent:@"Camera: Photo saved successfully"];
}

#pragma mark Saving photo

- (void)hideHud {
	[progressHud hide:YES];	
}

- (void)saveImage:(UIImage *)image {
	[library saveImage:image toAlbum:[PAConfig photoGalleryName] withCompletionBlock:^(NSError *error) {
		if (error != nil) {
			NSLog(@"Save image error: %@", [error description]);
		}
		else {
			library = nil;
			library = [[ALAssetsLibrary alloc] init];
		}
		[progressHud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PA_checkmark.png"]]];
		[progressHud setMode:MBProgressHUDModeCustomView];
		[progressHud setLabelText:@"Completed"];
		[progressHud setDetailsLabelText:nil];
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
		[UIView beginAnimations:nil context:nil];
		[flyingView setAlpha:0];
		[UIView commitAnimations];
	}];
}

- (void)startBackgroundSaving:(UIImage *)image {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(saveImage:) withObject:image];
	}
}

#pragma mark Flip button delegate methods

- (void)flipButtonView:(FTFlipButtonView *)view didSelectViewScreen:(FTFlipButtonViewScreen)screen {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:galleryFlipButton.flipButton.rotationInterval];
	if (screen == FTFlipButtonViewScreenFront) {
		[FlurryAnalytics logEvent:@"Gallery"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mainView cache:YES];
		[mainView addSubview:cameraMainView];
		[galleryMainView removeFromSuperview];
		
	}
	else {
		[FlurryAnalytics logEvent:@"Camera"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
		[mainView addSubview:galleryMainView];
		[cameraMainView removeFromSuperview];
	}
	[UIView commitAnimations];
	
	if (screen == FTFlipButtonViewScreenFront) [self setButtonsForToolbarForFrontPage:YES animated:YES];
	else [self setButtonsForToolbarForFrontPage:NO animated:YES];
}

#pragma mark Button actions

- (void)takePhoto {
	[stillCamera capturePhotoProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
		NSLog(@"Did finish picking photo with size: %@", NSStringFromCGSize(processedImage.size));
		[NSThread detachNewThreadSelector:@selector(startBackgroundSaving:) toTarget:self withObject:processedImage];
		
		[progressHud setMode:MBProgressHUDModeIndeterminate];
		[progressHud setLabelText:@"Saving photo"];
		[progressHud setDetailsLabelText:@"to the gallery"];
		[progressHud show:YES];
		
		if (torchMode == AVCaptureTorchModeOn || torchMode == AVCaptureTorchModeAuto) {
			NSError *error = nil;
			if (![stillCamera.inputCamera lockForConfiguration:&error])
			{
				NSLog(@"Error locking for configuration: %@", error);
			}
			[stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
			[stillCamera.inputCamera unlockForConfiguration];
		}
	}];
}

- (void)didClickTakePhoto:(UIBarButtonItem *)sender {
	[FlurryAnalytics logEvent:@"Camera: Take photo"];
	if (torchMode == AVCaptureTorchModeOn) {
		NSError *error = nil;
		if (![stillCamera.inputCamera lockForConfiguration:&error])
		{
			NSLog(@"Error locking for configuration: %@", error);
		}
		[stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
		[stillCamera.inputCamera unlockForConfiguration];
		[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(takePhoto) userInfo:nil repeats:NO];
	}
	else [self takePhoto];
}

- (void)didClickFlashPhoto:(UIButton *)sender {
	[FlurryAnalytics logEvent:@"Camera: Toggle flash"];
	AVCaptureTorchMode m = [PAConfig torchMode];
	if (m == AVCaptureTorchModeOff) m = AVCaptureTorchModeOn;
	else if (m == AVCaptureTorchModeOn) m = AVCaptureTorchModeOff;
	torchMode = m;
	[PAConfig setTorchMode:m];
	[flashButton setTitle:[self getFlashButtonTitle] forState:UIControlStateNormal];
	CGRect r = flashButton.frame;
	if (UIInterfaceOrientationIsPortrait(_orientation)) r.size.width = [self getFlashButtonWidth];
	else r.size.height = [self getFlashButtonWidth];
	[UIView beginAnimations:nil context:nil];
	[flashButton setFrame:r];
	[optionsTable setAlpha:0];
	[UIView commitAnimations];
	[optionsButton enableHighlight:NO];
}

- (void)didClickOptionsPhoto:(UIButton *)sender {
	[FlurryAnalytics logEvent:@"Camera: Toggle options"];
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

#pragma mark Options table data source & delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *d = [data objectAtIndex:indexPath.row];
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
	NSDictionary *d = [data objectAtIndex:indexPath.row];
	[cell setIdentifier:[d objectForKey:@"identifier"]];
	[cell.titleLabel setText:[d objectForKey:@"name"]];
	[cell.descriptionLabel setText:[d objectForKey:@"description"]];
	[cell setType:[d objectForKey:@"type"]];
//#warning Make me dynamic
	[cell.valueSlider setMinimumValue:0.5];
	
	[cell setDelegate:self];
	[cell reloadData];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Option cell delegate methods

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeStatusForIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoGrid"]) {
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
		CGFloat alpha;
		if (enabled) alpha = 1;
		else alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[gridView setAlpha:alpha];
		[UIView commitAnimations];
		if (enabled) [FlurryAnalytics logEvent:@"Camera: Grid enabled"];
		else [FlurryAnalytics logEvent:@"Camera: Grid disabled"];
	}
	else if ([identifier isEqualToString:@"photoVignette"]) {
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
		[vignette setX:((enabled) ? 0.75 : 0)];
		[vignette setY:((enabled) ? 0.5 : 0)];
		if (enabled) [FlurryAnalytics logEvent:@"Camera: Vignette enabled"];
		else [FlurryAnalytics logEvent:@"Camera: Vignette disabled"];
	}
}

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeValueTo:(CGFloat)value forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoEffectIntensity"]) [(GPUImageSepiaFilter *)filter setIntensity:value];
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
		[flashButton setAlpha:0];
		[optionsButton setAlpha:0];
		[optionsTable setAlpha:0];
		[snapButton.imageView setTransform:CGAffineTransformMakeRotation(rad)];
		[galleryFlipButton.flipButton setTransform:CGAffineTransformMakeRotation(rad)];
		[progressHud setTransform:CGAffineTransformMakeRotation(rad)];
	} completion:^(BOOL finished) {
		//[snapButton.imageView setTransform:CGAffineTransformMakeRotation(rad)];
		[flashButton setTransform:CGAffineTransformMakeRotation(rad)];
		[optionsButton setTransform:CGAffineTransformMakeRotation(rad)];
		[optionsTable setTransform:CGAffineTransformMakeRotation(rad)];
		
		[optionsButton setFrame:[self frameForOptionsButton]];
		[flashButton setFrame:[self frameForFlashButton]];
		[optionsTable setFrame:[self frameForOptionsTable]];
		
		[UIView animateWithDuration:0.3 animations:^{
			[flashButton setAlpha:1];
			[optionsButton setAlpha:1];
			if (isShowingOptionsTable) [optionsTable setAlpha:1];
		} completion:^(BOOL finished) {
			
		}];
	}];
}

#pragma mark View lifecycle

- (void)loadView {
	[self replaceMainView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createAllElements];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
    library = nil;
    [super viewDidUnload];
}


@end