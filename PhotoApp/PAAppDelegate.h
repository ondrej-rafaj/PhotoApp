//
//  PAAppDelegate.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>


@class PAHomeViewController;

@interface PAAppDelegate : UIResponder <UIApplicationDelegate, UIAccelerometerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PAHomeViewController *viewController;

@property (nonatomic, strong) UIAccelerometer *accelerometer;
@property (nonatomic) UIInterfaceOrientation orientation;


@end
