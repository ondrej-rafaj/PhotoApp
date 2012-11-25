//
//  FTPhotoBrowserViewController.m
//  PhotoApp
//
//  Created by Maxi Server on 25/11/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTPhotoBrowserViewController.h"
#import "FTPhotoBrowserPageView.h"


@interface FTPhotoBrowserViewController ()

@property (nonatomic, strong) FT2PageScrollView *scrollView;
@property (nonatomic) NSInteger customStartIndex;

@end

@implementation FTPhotoBrowserViewController


#pragma mark Animations

- (void)toggleControls {
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _scrollView = [[FT2PageScrollView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnScreen:)];
    [_scrollView addGestureRecognizer:gr];
    [self.view addSubview:_scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_scrollView setFrame:self.view.bounds];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setDataSource:self];
    [_scrollView setDelegate:self];
    [_scrollView reloadData];
    [_scrollView scrollToPageAtIndex:_customStartIndex animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(toggleControls) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)setStartIndex:(NSInteger)index {
    _customStartIndex = index;
}

#pragma mark Gesture recognizer action methods

- (void)didTapOnScreen:(UITapGestureRecognizer *)recognizer {
    [self toggleControls];
}

#pragma mark Page scroll view delegate & data source methods

- (FT2PageView *)pageScrollView:(FT2PageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index reusedView:(UIView *)view {
    static NSString *reuseId = @"reuseId";
    FTPhotoBrowserPageView *v = (FTPhotoBrowserPageView *)view;
    if ([_dataSource respondsToSelector:@selector(photoBrowserViewController:requestsThumbnailImageWithIndex:)]) {
        if (!v) {
            v = [[FTPhotoBrowserPageView alloc] initWithReuseIdentifier:reuseId];
        }
        UIImage *image = [_dataSource photoBrowserViewController:self requestsThumbnailImageWithIndex:index];
        [v setAutoresizingMask:UIViewAutoresizingNone];
        [v setFrame:self.view.bounds];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [v setImage:image];
        return v;
    }
    else return nil;
}

- (NSInteger)numberOfPagesInPageScrollView:(FT2PageScrollView *)scrollView {
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInPhotoBrowserViewController:)]) {
        return [_dataSource numberOfItemsInPhotoBrowserViewController:self];
    }
    return 0;
}

- (void)pageScrollView:(FT2PageScrollView *)scrollView didSelectPageAtIndex:(NSInteger)index {
    NSInteger number = [self numberOfPagesInPageScrollView:_scrollView];
    [self setTitle:[NSString stringWithFormat:@"%d of %d", (index + 1), number]];
}


@end
