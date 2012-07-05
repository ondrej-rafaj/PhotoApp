//
//  PAConfig.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAConfig.h"
#import "FTTracking.h"
#import "GPUImageSepiaFilter.h"


@interface PAConfig () {
	GPUImageFilterGroup *filter;
    GPUImageVignetteFilter *vignette;
	UIImage *radialImage;
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
	return @"Lomo Pro";
}

+ (NSString *)flurryCode {
	return @"N3N6NTKQX5MLP27Z9DQB";
}

+ (NSString *)facebookAppId {
	return @"418786041478998";
}

+ (NSString *)dateFormat {
	return @"dd. MM. yyyy";
}

+ (NSString *)sincerelyApiKey {
	return @"KOZJXR80LP9362C29I0YYC0JYFHLTL27NECT0TCE";
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
	//[optionsData addObject:[self dictionaryWithName:@"Vignette" withDescription:@"Enables vignette around picture" andIdentifier:@"photoVignette"]];
	[optionsData addObject:[self dictionaryWithName:@"Vignette size" withDescription:@"Size of the vignette" withIdentifier:@"photoVignetteIntensity" andType:@"slider"]];
	return optionsData;
}

- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView {
	filter = [[GPUImageFilterGroup alloc] init];
	
	GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
	[sepiaFilter setIntensity:0.25];
	[filter addFilter:sepiaFilter];
	
	GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
	[contrast setContrast:2];
	[sepiaFilter addTarget:contrast];
	
	vignette = [[GPUImageVignetteFilter alloc] init];
	[filter addTarget:vignette];
	[contrast addTarget:vignette];
	
	[filter setInitialFilters:[NSArray arrayWithObjects:sepiaFilter, contrast, nil]];
	[filter setTerminalFilter:vignette];
	
	[filter prepareForImageCapture];
	
	[stillCamera addTarget:vignette];
    [filter addTarget:cameraView];
}

- (GPUImageFilter *)upToCameraFilter {
	return (GPUImageFilter *)filter;
}

- (void)configureSlider:(UISlider *)slider forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		[slider setTransform:CGAffineTransformMakeScale(-1, 1)];
		[slider setMaximumTrackTintColor:[UIColor darkGrayColor]];
		[slider setMinimumTrackTintColor:[UIColor lightGrayColor]];
		[slider setMinimumValue:-1.0];
		[slider setMaximumValue:0.74];
		[slider setValue:0.33];
		[self setIntensity:slider.value forIdentifier:identifier];
	}
}

- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:@"photoVignetteIntensity"]) {
		NSLog(@"Vignette intensity: %f", intensity);
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
	return image;
}


@end
