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


@end
