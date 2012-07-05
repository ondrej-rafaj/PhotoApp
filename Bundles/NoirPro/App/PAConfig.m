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
	GPUImageMonochromeFilter *filter;
    GPUImageVignetteFilter *vignette;
	
	CGFloat r;
	CGFloat g;
	CGFloat b;
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
	return @"Noir Pro";
}

+ (NSString *)flurryCode {
	return @"4HQ5H9WPMXPF9NKR4MGY"; // Monochrome Pro
}

+ (NSString *)facebookAppId {
	return @"293927774039379"; // Monochrome Pro
}

+ (NSString *)dateFormat {
	return @"dd. MM. yyyy";
}

+ (NSString *)sincerelyApiKey {
	return @"O138T1YU6GY1HZ2E22PP86G46MAY2SUM09FIW3LD";
}

#pragma mark GPU Image section

- (id)init {
	self = [super init];
	if (self) {
		r = 0;
		g = 0;
		b = 0;
	}
	return self;
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

- (NSMutableArray *)optionsData {
	NSMutableArray * optionsData = [NSMutableArray array];
	[optionsData addObject:[self dictionaryWithName:@"Grid" withDescription:@"Enables photo grid" andIdentifier:@"photoGrid"]];
	
	[optionsData addObject:[self dictionaryWithName:@"Vignette size" withDescription:@"Size of the vignette" withIdentifier:@"photoVignetteIntensity" andType:@"slider"]];
	
	[optionsData addObject:[self dictionaryWithName:@"Intensity" withDescription:@"Intensity of the noir effect" withIdentifier:@"photoEffectIntensity" andType:@"slider"]];
	
	return optionsData;
}

- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView {
	filter = [[GPUImageMonochromeFilter alloc] init];
	[filter prepareForImageCapture];
	[filter setColorRed:0 green:0 blue:0];
	
	vignette = [[GPUImageVignetteFilter alloc] init];
	[vignette addTarget:filter];
	[vignette prepareForImageCapture];
    
    [stillCamera addTarget:vignette];
    [filter addTarget:cameraView];
}

- (GPUImageFilter *)upToCameraFilter {
	return filter;
}

- (void)configureSlider:(UISlider *)slider forIdentifier:(NSString *)identifier {
	[slider setTransform:CGAffineTransformMakeScale(1, 1)];
	if ([identifier isEqualToString:@"photoEffectIntensity"]) {
		[slider setMinimumValue:0.75];
		[slider setMaximumValue:1];
	}
	else if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		[slider setTransform:CGAffineTransformMakeScale(-1, 1)];
		[slider setMaximumTrackTintColor:[UIColor darkGrayColor]];
		[slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
		[slider setMinimumValue:-1.0];
		[slider setMaximumValue:0.74];
		[slider setValue:0.5];
		[[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:identifier];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self setIntensity:slider.value forIdentifier:identifier];
	}
}

- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoEffectIntensity"]) {
		[(GPUImageMonochromeFilter *)filter setIntensity:intensity];
	}
	else if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		[vignette setVignetteStart:intensity];
	}
}

- (void)didChangeValueForIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignette"]) {
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:identifier];
		[vignette setVignetteEnd:((enabled) ? 0.75 : 0)];
		[vignette setVignetteStart:((enabled) ? 0.5 : 0)];
		if (enabled) [FTTracking logEvent:@"Camera: Vignette enabled"];
		else [FTTracking logEvent:@"Camera: Vignette disabled"];
	}
}

- (UIImage *)applyFiltersManuallyOnImage:(UIImage *)image {
	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
	GPUImageMonochromeFilter *localFilter = [[GPUImageMonochromeFilter alloc] init];
	[localFilter setIntensity:filter.intensity];
	[localFilter setColorRed:0 green:0 blue:0];
	
	GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc] init];
	[vignetteFilter setVignetteEnd:vignette.vignetteEnd];
	[vignetteFilter setVignetteStart:vignette.vignetteStart];
	[vignette addTarget:localFilter];
	
	[stillImageSource addTarget:localFilter];
	[stillImageSource processImage];
	
	return [localFilter imageFromCurrentlyProcessedOutput];
}


@end
