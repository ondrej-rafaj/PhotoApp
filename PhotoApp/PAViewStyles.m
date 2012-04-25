//
//  PAViewStyles.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAViewStyles.h"

@implementation PAViewStyles

+ (void)setStylesToToolbar:(UIToolbar *)toolbar {
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar setTintColor:[UIColor grayColor]];
}

+ (void)setStylesToNavBar:(UINavigationBar *)navbar {
	[navbar setBarStyle:UIBarStyleBlack];
	[navbar setTintColor:[UIColor grayColor]];
}


@end
