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


@interface PAConfig : NSObject

// Data retention

+ (AVCaptureTorchMode)torchMode;
+ (void)setTorchMode:(AVCaptureTorchMode)mode;

+ (BOOL)isFirstLaunch;

// General configuration

+ (NSString *)appName;

+ (NSString *)flurryCode;
+ (NSString *)facebookAppId;

+ (NSString *)dateFormat;

// GPU Image section

- (NSMutableArray *)optionsData;
- (GPUImageFilter *)cameraFilter;
- (GPUImageFilter *)upToCameraFilter;
- (void)setIntensity:(CGFloat)intensity forIdentifier:(NSString *)identifier;
- (void)didChangeValueForIdentifier:(NSString *)identifier;


@end
