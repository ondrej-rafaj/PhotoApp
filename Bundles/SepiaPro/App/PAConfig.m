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
	return @"Sepia Pro";
}

+ (NSString *)flurryCode {
	return @"6THGBQVWHALTY5KPVBID"; // Sepia Pro
}

+ (NSString *)facebookAppId {
	return @"221860844593941"; // Sepia Pro
}

+ (NSString *)dateFormat {
	return @"dd MM yyyy";
}

+ (NSString *)sincerelyApiKey {
	return @"1BRX0B0D4M2ZD32DL1UU3DA7Q28NKIDJSAISMTQE";
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
	[optionsData addObject:[self dictionaryWithName:@"Vignette" withDescription:@"Enables vignette around picture" andIdentifier:@"photoVignette"]];
	[optionsData addObject:[self dictionaryWithName:@"Intensity" withDescription:@"Intensity of the sepia effect" withIdentifier:@"photoEffectIntensity" andType:@"slider"]];
	return optionsData;
}

- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView {
	filter = [[GPUImageSepiaFilter alloc] init];
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

- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier {
	//intensity = ((in
	if ([identifier isEqualToString:@"photoEffectIntensity"]) {
		[(GPUImageSepiaFilter *)filter setIntensity:intensity];
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


@end
