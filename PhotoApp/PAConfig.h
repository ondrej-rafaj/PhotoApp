//
//  PAConfig.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface PAConfig : NSObject

+ (AVCaptureTorchMode)torchMode;
+ (void)setTorchMode:(AVCaptureTorchMode)mode;


@end
