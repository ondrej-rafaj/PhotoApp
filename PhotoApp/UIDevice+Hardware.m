//
//  UIDevice+Hardware.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "UIDevice+Hardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation UIDevice (Hardware)

- (NSString *)platform {
    int mib[2];
	size_t len;
	char *machine;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	machine = malloc(len);
	sysctl(mib, 2, machine, &len, NULL, 0);
	
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
	return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod 5";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"Simulator";
    return platform;
}

- (BOOL)iPhone4 {
	NSString *platform = [self platform];
	return ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,3"]);
}

- (BOOL)iPhone4s {
	NSString *platform = [self platform];
	return ([platform isEqualToString:@"iPhone4,1"]);
}

- (BOOL)iPhone5iPod5 {
	NSString *platform = [self platform];
	return ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"] || [platform isEqualToString:@"iPod5,1"]);
}

- (BOOL)hasRetinaDisplay {
    NSString *platform = [self platform];
    BOOL ret = YES;
    if ([platform isEqualToString:@"iPhone1,1"]) {
        ret = NO;
    }
    else if ([platform isEqualToString:@"iPhone1,2"]) ret = NO;
	else if ([platform isEqualToString:@"iPhone2,1"]) ret = NO;
	else if ([platform isEqualToString:@"iPod1,1"]) ret = NO;
	else if ([platform isEqualToString:@"iPod2,1"]) ret = NO;
	else if ([platform isEqualToString:@"iPod3,1"]) ret = NO;
    return ret;
}

- (BOOL)hasMultitasking {
    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
        return [self isMultitaskingSupported];
    }
    return NO;
}

- (BOOL)hasCamera {
	BOOL ret = NO;
	// check camera availability
	return ret;
}

@end
