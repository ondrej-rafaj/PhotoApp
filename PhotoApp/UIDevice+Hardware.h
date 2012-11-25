//
//  UIDevice+Hardware.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

- (NSString *)platform;

- (NSString *)platformString;

- (BOOL)iPhone4;
- (BOOL)iPhone4s;
- (BOOL)iPhone5iPod5;

- (BOOL)hasRetinaDisplay;

- (BOOL)hasMultitasking;

- (BOOL)hasCamera;


@end
