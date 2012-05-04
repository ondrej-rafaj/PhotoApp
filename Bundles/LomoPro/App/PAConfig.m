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
	GPUImageSepiaFilter *filter;
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
	return @"Lomo Pro";
}

+ (NSString *)flurryCode {
	return @"N3N6NTKQX5MLP27Z9DQB";
}

+ (NSString *)facebookAppId {
	return @"418786041478998";
}

+ (NSString *)dateFormat {
	return @"dd MM yyyy";
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
	[optionsData addObject:[self dictionaryWithName:@"Vignette" withDescription:@"Enables vignette around picture" andIdentifier:@"photoVignette"]];
	//[optionsData addObject:[self dictionaryWithName:@"Intensity" withDescription:@"Intensity of the sepia effect" withIdentifier:@"photoEffectIntensity" andType:@"slider"]];
	return optionsData;
}

- (UIImage *)radialGradientMaskForVintageEffect:(CGSize)size withColor:(UIColor *)color inverted:(BOOL)inverted {
	UIGraphicsBeginImageContextWithOptions(size, NO, 1);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGFloat BGLocations[3] = { 0.0, 1.0 };
	
	CGColorSpaceRef BgRGBColorspace = CGColorSpaceCreateDeviceRGB();
	
	const CGFloat *c = CGColorGetComponents(color.CGColor);
    
	CGGradientRef bgRadialGradient;
	
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
		CGFloat BgComponents[8] = { 0, 0, 0 , (inverted ? 1 : 0), c[0], c[0], c[0], (inverted ? 0 : c[3]) };
		bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
	}
	else {
		CGFloat BgComponents[8] = { 0, 0, 0 , (inverted ? 1 : 0), c[0], c[1], c[2], (inverted ? 0 : c[3]) };
		bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
	}
	
    CGPoint startBg = CGPointMake((size.width / 2), (size.height / 2)); 
    CGFloat endRadius= (size.width > size.height) ? size.width : size.height;
	CGFloat randMax = ((endRadius * 20) / 100);
	NSInteger rand = (((arc4random() % (int)randMax) + ((endRadius * 10) / 100)) - ((randMax + ((endRadius * 20) / 100)) / 2));
	endRadius -= randMax;
	startBg.x += rand;
	startBg.y += rand;
	
	CGContextDrawRadialGradient(context, bgRadialGradient, startBg, 0, startBg, endRadius, kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(BgRGBColorspace);
    CGGradientRelease(bgRadialGradient);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    return image;
}

/*
 
 - (UIImage *)effectLomo {
 CIImage *image = [CIImage imageWithCGImage:self.CGImage];
 CIContext *context = [CIContext contextWithOptions:nil];
 
 CIFilter *filter;
 
 filter = [CIFilter filterWithName:@"CIExposureAdjust"];  
 [filter setDefaults];  
 [filter setValue:image forKey:kCIInputImageKey];  
 [filter setValue:[NSNumber numberWithFloat: -0.2f] forKey:@"inputEV"]; 
 image = [filter outputImage];
 
 filter = [CIFilter filterWithName:@"CIColorControls"];  
 [filter setDefaults];  
 [filter setValue:image forKey:kCIInputImageKey];  
 [filter setValue:[NSNumber numberWithFloat: 1.1f] forKey:@"inputSaturation"]; // Max: 2
 [filter setValue:[NSNumber numberWithFloat: 0.0f] forKey:@"inputBrightness"]; // Max: 1
 [filter setValue:[NSNumber numberWithFloat: 1.2f] forKey:@"inputContrast"];   // Max: 4
 image = [filter outputImage];
 
 filter = [CIFilter filterWithName:@"CISepiaTone"];  
 [filter setDefaults];  
 [filter setValue:image forKey:kCIInputImageKey];  
 [filter setValue:[NSNumber numberWithFloat:0.1f] forKey:@"inputIntensity"]; 
 image = [filter outputImage];
 
 filter = [CIFilter filterWithName:@"CITemperatureAndTint"];  
 [filter setDefaults];  
 [filter setValue:image forKey:kCIInputImageKey]; 
 [filter setValue:[CIVector vectorWithX:600 Y:3000] forKey:@"inputNeutral"]; 
 [filter setValue:[CIVector vectorWithX:600 Y:3000] forKey:@"inputTargetNeutral"]; 
 image = [filter outputImage];
 
 
 image = [CIFilter filterWithName:@"CIToneCurve" keysAndValues:@"inputImage", image, @"inputPoint0", [CIVector vectorWithX:0 Y:0], @"inputPoint1", [CIVector vectorWithX:0.25 Y:0.25], @"inputPoint2", [CIVector vectorWithX:0.5 Y:0.5], @"inputPoint3", [CIVector vectorWithX:0.75 Y:0.75], @"inputPoint4", [CIVector vectorWithX:1 Y:1], nil].outputImage;
 
 
 UIImage *gradient = [self radialGradientMaskForVintageEffect:self.size withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] inverted:YES];
 
 filter = [CIFilter filterWithName:@"CISoftLightBlendMode"];  
 [filter setDefaults];  
 [filter setValue:[CIImage imageWithCGImage:gradient.CGImage] forKey:kCIInputImageKey];  
 [filter setValue:image forKey:@"inputBackgroundImage"];
 image = [filter outputImage];
 
 //	filter = [CIFilter filterWithName:@"CISharpenLuminance"];  
 //    [filter setDefaults];  
 //    [filter setValue:image forKey:kCIInputImageKey];
 //    [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputSharpness"]; 
 //	image = [filter outputImage];
 
 gradient = [self radialGradientMaskForVintageEffect:self.size withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.90] inverted:NO];
 
 filter = [CIFilter filterWithName:@"CISourceAtopCompositing"];  
 [filter setDefaults];  
 [filter setValue:[CIImage imageWithCGImage:gradient.CGImage] forKey:kCIInputImageKey];  
 [filter setValue:image forKey:@"inputBackgroundImage"]; 
 image = [filter outputImage];
 
 CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
 UIImage *newImage = [UIImage imageWithCGImage:cgimg];
 CGImageRelease(cgimg);
 
 return newImage;
 }

 
 */

- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView {
	filter = [[GPUImageSepiaFilter alloc] init];
	[filter setIntensity:0.25];
	[filter prepareForImageCapture];
	
	GPUImageExposureFilter *exposure = [[GPUImageExposureFilter alloc] init];
	[exposure setExposure:-0.2];
	[exposure addTarget:filter];
	[exposure prepareForImageCapture];
	
	//UIImage *gradient = [self radialGradientMaskForVintageEffect:CGSizeMake(500, 500) withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] inverted:YES];
	//GPUImageSoftLightBlendFilter *blend = [[GPUImageSoftLightBlendFilter alloc] init];
	//[blend set
	
//	GPUImageColorBurnBlendFilter *colorBurn = [[GPUImageColorBurnBlendFilter alloc] init];
//	[colorBurn initializeAttributes];
//	[colorBurn addTarget:exposure];
	
//	GPUImageColorInvertFilter *invert = [[GPUImageColorInvertFilter alloc] init];
//	[invert addTarget:exposure];
	
	GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
	[contrast setContrast:2];
	[contrast addTarget:exposure];
	
	vignette = [[GPUImageVignetteFilter alloc] init];
	[vignette addTarget:contrast];
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
		//[(GPUImageSepiaFilter *)filter setIntensity:intensity];
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
