//
//  PAConfig.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"


typedef enum {
	PAConfigFlashModeOff,
	PAConfigFlashModeOn,
	PAConfigFlashModeAuto,
	PAConfigFlashModeAlwaysOn
}
PAConfigFlashMode;

@interface PAConfig : NSObject

// Data retention

+ (PAConfigFlashMode)flashMode;
+ (void)setFlashMode:(PAConfigFlashMode)mode;

+ (BOOL)isFirstLaunch;

// General configuration

+ (NSString *)appName;

+ (NSString *)flurryCode;
+ (NSString *)facebookAppId;

+ (NSString *)dateFormat;

+ (NSString *)sincerelyApiKey;

// GPU Image section

- (NSMutableArray *)optionsData;
- (void)configureForCamera:(GPUImageStillCamera *)stillCamera andCameraView:(GPUImageView *)cameraView;
- (GPUImageFilter *)upToCameraFilter;
- (void)configureSlider:(UISlider *)slider forIdentifier:(NSString *)identifier;
- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier;
- (void)didChangeValueForIdentifier:(NSString *)identifier;
//- (UIImage *)applyFiltersManuallyOnImage:(UIImage *)image;


@end
