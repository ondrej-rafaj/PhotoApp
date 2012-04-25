//
//  PAHomeViewController.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PAGalleryViewController.h"
#import "PAViewStyles.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface PAHomeViewController ()

@end

@implementation PAHomeViewController


#pragma mark Creating elements

- (void)createToolbar {
	mainToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (480 - 53), 320, 53)];
	[mainToolbar setBackgroundImage:[UIImage imageNamed:@"PA_bottomBar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	[PAViewStyles setStylesToToolbar:mainToolbar];
	[self.view addSubview:mainToolbar];
	
	NSMutableArray *arr = [NSMutableArray array];
	
	FTFlipBarButtonItem *gallery = [[FTFlipBarButtonItem alloc] initWithFlipBarButtonItem];
	[gallery.flipButton setDelegate:self];
	[gallery.flipButton.frontButton addTarget:self action:@selector(didClickGallery:) forControlEvents:UIControlEventTouchUpInside];
	[gallery.flipButton.backButton addTarget:self action:@selector(didClickGallery:) forControlEvents:UIControlEventTouchUpInside];
	[arr addObject:gallery];
	
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[arr addObject:flex];
	
	UIButton *snapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 102, 37)];
	[snapButton setBackgroundImage:[UIImage imageNamed:@"PA_cameraButton.png"] forState:UIControlStateNormal];
	[snapButton setImage:[UIImage imageNamed:@"PA_cameraIconBig.png"] forState:UIControlStateNormal];
	[snapButton addTarget:self action:@selector(didClickTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *snap = [[UIBarButtonItem alloc] initWithCustomView:snapButton];
	[arr addObject:snap];
	
	flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[arr addObject:flex];
	
	UIBarButtonItem *lib = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didClickLibrary:)];
	[arr addObject:lib];
	
	[mainToolbar setItems:arr animated:NO];
}

- (void)createOptionsTable {
	CGFloat s = [self numberOfSectionsInTableView:optionsTable];
	CGFloat r;
	CGFloat h = 0;
	for (int i = 0; i < s; i++) {
		r = [self tableView:optionsTable numberOfRowsInSection:i];
		for (int x = 0; x < r; x++) {
			h += [self tableView:optionsTable heightForRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:i]];
		}
	}
	optionsTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 56, 280, h) style:UITableViewStylePlain];
	[optionsTable setAlpha:0];
	[optionsTable setScrollEnabled:NO];
	[optionsTable setDelegate:self];
	[optionsTable setDataSource:self];
	[optionsTable setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	[optionsTable.layer setCornerRadius:15];
	[optionsTable.layer setBorderWidth:1];
	[optionsTable.layer setBorderColor:[UIColor darkGrayColor].CGColor];
	[self.view addSubview:optionsTable];
}

- (NSString *)getFlashButtonTitle {
	AVCaptureTorchMode m = [PAConfig torchMode];
	if (m == AVCaptureTorchModeAuto) {
		return @"Flash Auto";
	}
	else if (m == AVCaptureTorchModeOn) {
		return @"Flash On";
	}
	else {
		return @"Flash Off";
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
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch]) {
		NSString *title = [self getFlashButtonTitle];
		flashButton = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(10, 8, [self getFlashButtonWidth], 30)];
		[flashButton addTarget:self action:@selector(didClickFlashPhoto:) forControlEvents:UIControlEventTouchUpInside];
		[flashButton setTitle:title forState:UIControlStateNormal];
		[self.view addSubview:flashButton];
	}
	else torchMode = AVCaptureTorchModeOff;
	
	optionsButton = [[FTCameraButtonView alloc] initWithFrame:CGRectMake((320 - 10 - 74), 8, 75, 30)];
	[optionsButton addTarget:self action:@selector(didClickOptionsPhoto:) forControlEvents:UIControlEventTouchUpInside];
	[optionsButton setTitle:@"Options" forState:UIControlStateNormal];
	[self.view addSubview:optionsButton];
	
	[self createOptionsTable];
}

- (void)replaceMainView {
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	
    cameraView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	//cameraView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[self.view addSubview:cameraView];
	[self setView:cameraView];
}

- (void)createCameraView {
	stillCamera = [[GPUImageStillCamera alloc] init];
	
	//GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
	
    filter = [[GPUImageSepiaFilter alloc] init];
	[filter prepareForImageCapture];
	
	//[vignette addTarget:filter];
	
    GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
	
    [stillCamera addTarget:rotationFilter];
    [rotationFilter addTarget:filter];
	
    GPUImageView *filterView = (GPUImageView *)cameraView;
    [filter addTarget:filterView];
    
    [stillCamera startCameraCapture];
	
	gridView = [[FTPhotoGridView alloc] init];
	[self.view addSubview:gridView];
	
	touchDetector = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[touchDetector setBackgroundColor:[UIColor clearColor]];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreenOnce:)];
	[touchDetector addGestureRecognizer:tap];
	[self.view addSubview:touchDetector];
}

- (void)createAllElements {
	library = [[ALAssetsLibrary alloc] init];
	[self createCameraView];
	[self createFunctionButtons];
	[self createToolbar];
}

#pragma mark Saving photo

- (void)saveImage:(UIImage *)image {
	//NSData *dataForPNGFile = UIImagePNGRepresentation(image);
	[library saveImage:image toAlbum:@"Sepia :)" withCompletionBlock:^(NSError *error) {
		if (error != nil) {
			NSLog(@"Big error: %@", [error description]);
		}
		else {
			library = nil;
			library = [[ALAssetsLibrary alloc] init];
		}
	}];
}

- (void)startBackgroundSaving:(UIImage *)image {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(saveImage:) withObject:image];
	}
}

#pragma mark Flip button delegate methods

- (void)flipButtonView:(FTFlipButtonView *)view didSelectViewScreen:(FTFlipButtonViewScreen)screen {
	
}

#pragma mark Button actions

- (void)didClickTakePhoto:(UIBarButtonItem *)sender {
	
//	[stillCamera.inputCamera lockForConfiguration:nil];
//	[stillCamera.inputCamera setTorchMode:torchMode];
//	[stillCamera.inputCamera unlockForConfiguration];
	
	[stillCamera capturePhotoProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
		NSLog(@"Did finish picking photo with size: %@", NSStringFromCGSize(processedImage.size));
		[NSThread detachNewThreadSelector:@selector(startBackgroundSaving:) toTarget:self withObject:processedImage];
    }];
}
- (void)didClickGallery:(UIBarButtonItem *)sender {
	
}

- (void)didClickLibrary:(UIBarButtonItem *)sender {
	PAGalleryViewController *c = [[PAGalleryViewController alloc] init];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
	[nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:nc animated:YES];
}

- (void)didClickFlashPhoto:(UIButton *)sender {
	AVCaptureTorchMode m = [PAConfig torchMode];
	if (m == AVCaptureTorchModeOff) m = AVCaptureTorchModeAuto;
	else if (m == AVCaptureTorchModeAuto) m = AVCaptureTorchModeOn;
	else if (m == AVCaptureTorchModeOn) m = AVCaptureTorchModeOff;
	[PAConfig setTorchMode:m];
	[flashButton setTitle:[self getFlashButtonTitle] forState:UIControlStateNormal];
	CGRect r = flashButton.frame;
	r.size.width = [self getFlashButtonWidth];
	[UIView beginAnimations:nil context:nil];
	[flashButton setFrame:r];
	[optionsTable setAlpha:0];
	[UIView commitAnimations];
	[optionsButton enableHighlight:NO];
}

- (void)didClickOptionsPhoto:(UIButton *)sender {
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
#warning Make me dynamic
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
	}
}

- (void)optionsTableViewCell:(PAOptionsTableViewCell *)cell didChangeValueTo:(CGFloat)value forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoEffectIntensity"]) [(GPUImageSepiaFilter *)filter setIntensity:value];
}

#pragma mark Tap detector

- (void)didTapScreenOnce:(UITapGestureRecognizer *)recognizer {
	if (optionsTable.alpha > 0) [self didClickOptionsPhoto:optionsButton];
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