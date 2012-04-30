//
//  PAAppDelegate.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAAppDelegate.h"
#import "PAHomeViewController.h"
#import "FlurryAnalytics.h"
#import "PAConfig.h"


@implementation PAAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize accelerometer = _accelerometer;
@synthesize orientation = _orientation;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_accelerometer = [UIAccelerometer sharedAccelerometer];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[PAHomeViewController alloc] init];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	[FlurryAnalytics startSession:[PAConfig flurryCode]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[_accelerometer setDelegate:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[_accelerometer setDelegate:self];
	[_accelerometer setUpdateInterval:1.4];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Accelerometer delegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	float xx = -[acceleration x];
	float yy = [acceleration y];
	float angle = atan2(yy, xx);
	
	BOOL isChange = NO;
	if(angle >= -2.25 && angle <= -0.75) {
		if(_orientation != UIInterfaceOrientationPortrait) {
			_orientation = UIInterfaceOrientationPortrait;
			isChange = YES;
		}
	}
	else if(angle >= -0.75 && angle <= 0.75) {
		if(_orientation != UIInterfaceOrientationLandscapeRight) {
			_orientation = UIInterfaceOrientationLandscapeRight;
			isChange = YES;
		}
	}
	else if(angle >= 0.75 && angle <= 2.25) {
		if(_orientation != UIInterfaceOrientationPortraitUpsideDown) {
			_orientation = UIInterfaceOrientationPortraitUpsideDown;
			isChange = YES;
		}
	}
	else if(angle <= -2.25 || angle >= 2.25) {
		if(_orientation != UIInterfaceOrientationLandscapeLeft) {
			_orientation = UIInterfaceOrientationLandscapeLeft;
			isChange = YES;
		}
	}
	if (isChange) {
		[_viewController setOrientation:_orientation];
		[_viewController rotateElements];
	}
}


@end
