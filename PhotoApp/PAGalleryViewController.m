//
//  PAGalleryViewController.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "PAGalleryViewController.h"
#import "PAViewStyles.h"


@interface PAGalleryViewController ()

@end

@implementation PAGalleryViewController


#pragma mark Creating views

- (void)createTopBar {
	[PAViewStyles setStylesToNavBar:self.navigationController.navigationBar];
	
	UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(close:)];
	[self.navigationItem setLeftBarButtonItem:close];
}

- (void)createAllElements {
	[self createTopBar];
}

#pragma mark Actions

- (void)close:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createAllElements];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
