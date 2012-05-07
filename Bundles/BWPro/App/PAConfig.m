//
//  PAConfig.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAConfig.h"
#import "FTTracking.h"


@interface PAConfig () {
	GPUImageFilter *filter;
    GPUImageVignetteFilter *vignette;
}

@end

@implementation PAConfig


#pragma mark Data retention

+ (PAConfigFlashMode)flashMode {
	return (PAConfigFlashMode)[[NSUserDefaults standardUserDefaults] integerForKey:@"PAConfigFlashMode"];
}

+ (void)setFlashMode:(PAConfigFlashMode)mode {
	[[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"PAConfigFlashMode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstLaunch {
	BOOL didLaunchBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"PAConfigIsFirstLaunch"];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PAConfigIsFirstLaunch"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return !didLaunchBefore;
}

#pragma mark General settings

+ (NSString *)appName {
	return @"B&W Pro";
}

+ (NSString *)flurryCode {
	return @"7Y2DGF9BIEFLMNNY6RN4";
}

+ (NSString *)facebookAppId {
	return @"378064265568103";
}

+ (NSString *)dateFormat {
	return @"dd MM yyyy";
}

+ (NSString *)sincerelyApiKey {
	return @"OEETCEGPKAKLSUAJKNYM27CGXPJDYBG3MAVAN0BY";
}

#pragma mark GPU Image section

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

- (NSMutableArray *)optionsData {
	NSMutableArray * optionsData = [NSMutableArray array];
	[optionsData addObject:[self dictionaryWithName:@"Grid" withDescription:@"Enables photo grid" andIdentifier:@"photoGrid"]];
	//[optionsData addObject:[self dictionaryWithName:@"Vignette size" withDescription:@"Enables vignette around picture" andIdentifier:@"photoVignette"]];
	[optionsData addObject:[self dictionaryWithName:@"Vignette size" withDescription:@"Size of the vignette" withIdentifier:@"photoVignetteIntensity" andType:@"slider"]];
	return optionsData;
}

- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView {
	filter = [[GPUImageGrayscaleFilter alloc] init];
	[filter prepareForImageCapture];
	
	vignette = [[GPUImageVignetteFilter alloc] init];
	[vignette addTarget:filter];
	[vignette prepareForImageCapture];
	
	// Do not touch if you don't have to :)
	GPUImageRotationFilter *rotationFilter = [[GPUImageRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
	[rotationFilter prepareForImageCapture];
	[stillCamera addTarget:rotationFilter];
	[rotationFilter addTarget:vignette];
	[filter addTarget:cameraView];
}

- (GPUImageFilter *)upToCameraFilter {
	return filter;
}

- (void)configureSlider:(UISlider *)slider forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		[slider setTransform:CGAffineTransformMakeScale(-1, 1)];
		[slider setMaximumTrackTintColor:[UIColor darkGrayColor]];
		[slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
		[slider setMinimumValue:-1.0];
		[slider setMaximumValue:0.74];
		[slider setValue:0.5];
		[[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:identifier];
		[[NSUserDefaults standardUserDefaults]synchronize];
		[self setIntensity:slider.value forIdentifier:identifier];
	}
}

- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		[vignette setY:intensity];
	}
}

- (void)didChangeValueForIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignette"]) {
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
		[vignette setX:((enabled) ? 0.75 : 0)];
		[vignette setY:((enabled) ? 0.5 : 0)];
		if (enabled) [FTTracking logEvent:@"Camera: Vignette enabled"];
		else [FTTracking logEvent:@"Camera: Vignette disabled"];
	}
}

- (UIImage *)applyFiltersManuallyOnImage:(UIImage *)image {
//	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//	
//	GPUImageGrayscaleFilter *g = [[GPUImageGrayscaleFilter alloc] init];
//	[g prepareForImageCapture];
	
	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
	GPUImageGrayscaleFilter *gray = [[GPUImageGrayscaleFilter alloc] init];
	
	[stillImageSource addTarget:gray];
	[stillImageSource processImage];
	
	return [gray imageFromCurrentlyProcessedOutput];
}


@end
