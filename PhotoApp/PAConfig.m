//
//  PAConfig.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAConfig.h"

@implementation PAConfig

+ (AVCaptureTorchMode)torchMode {
	return (AVCaptureTorchMode)[[NSUserDefaults standardUserDefaults] integerForKey:@"PAConfigTorchMode"];
}

+ (void)setTorchMode:(AVCaptureTorchMode)mode {
	[[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"PAConfigTorchMode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstLaunch {
	BOOL didLaunchBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"PAConfigIsFirstLaunch"];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PAConfigIsFirstLaunch"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return !didLaunchBefore;
}

+ (NSString *)photoGalleryName {
	return @"Sepia Pro";
}

+ (NSString *)flurryCode {
	return @"6THGBQVWHALTY5KPVBID"; // Sepia Pro
}

+ (NSString *)facebookAppId {
	return @"221860844593941"; // Sepia Pro
}


@end
