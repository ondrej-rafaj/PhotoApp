//
//  FTPhotoBrowserViewController.m
//  PhotoApp
//
//  Created by Maxi Server on 25/11/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTPhotoBrowserViewController.h"
#import <Social/Social.h>
#import "FTPhotoBrowserPageView.h"
#import "IconActionSheet.h"
#import "PAConfig.h"
#import "FTSystem.h"
#import "FTTracking.h"
#import "FTLang.h"
#import "UIView+Layout.h"
#import "UIImage+Tools.h"


@interface FTPhotoBrowserViewController ()

@property (nonatomic, strong) FT2PageScrollView *scrollView;
@property (nonatomic) NSInteger customStartIndex;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation FTPhotoBrowserViewController


#pragma mark Positioning

- (CGFloat)screenHeight {
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        
        if (scale > 1.0) {
            if([[UIScreen mainScreen] bounds].size.height == 568) {
                return 568;
            }
        }
    }
    return 480;
}

#pragma mark Image scaling

- (UIImage *)imageForSharingFromAsset:(ALAsset *)asset {
	ALAssetRepresentation *rep = [asset defaultRepresentation];
	CGImageRef iref = [rep fullResolutionImage];
	UIImage *inputImage = [UIImage imageWithCGImage:iref];
	inputImage = [UIImage imageWithCGImage:[inputImage scaleWithMaxSize:800].CGImage scale:1 orientation:[rep orientation]];
	return inputImage;
}

#pragma mark Animations

- (void)toggleControls {
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_toolBar setAlpha:(([_toolBar alpha] > 0) ? 0 : 1)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideControls {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_toolBar setAlpha:0];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showControls {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_toolBar setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma Email sharing

- (void)presentMailDialog:(NSData *)imageData {
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	[mc setMailComposeDelegate:self];
	[mc setSubject:[NSString stringWithFormat:@"Photo from %@ %@ app", [PAConfig appName], ([FTSystem isTabletSize] ? @"iPad" : @"iPhone")]];
	[mc setMessageBody:[NSString stringWithFormat:@"\n\n\n\%@ app by Fuerte International UK - http://www.fuerteint.com/", [PAConfig appName]] isHTML:NO];
	[mc setMessageBody:[NSString stringWithFormat:@"</br></br></br></br>%@ app by <a href='http://www.fuerteint.com/'>Fuerte International UK</a>", [PAConfig appName]] isHTML:YES];
	[mc addAttachmentData:imageData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png", [NSDate date]]];
	imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PA_logo" ofType:@"png"]];
	[mc addAttachmentData:imageData mimeType:@"image/png" fileName:@"Fuerte_International_UK.png"];
	[mc setModalPresentationStyle:UIModalPresentationPageSheet];
	[self presentViewController:mc animated:YES completion:^{
        
    }];
	[FTTracking logEvent:@"Mail: Sending image"];
}

- (void)prepareEmail:(ALAsset *)asset {
	NSData *imageData = UIImagePNGRepresentation([self imageForSharingFromAsset:[self getAssetForIndex:_currentIndex]]);
	[self performSelectorOnMainThread:@selector(presentMailDialog:) withObject:imageData waitUntilDone:NO];
}

#pragma mark Email delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			NSLog(@"Mail send canceled.");
			[FTTracking logEvent:@"Mail: Mail canceled"];
			break;
		case MFMailComposeResultSaved:
			//[UIAlertView showMessage:FTLangGet(@"Your email has been saved") withTitle:FTLangGet(@"Email")];
			[FTTracking logEvent:@"Mail: Mail saved"];
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent.");
			[FTTracking logEvent:@"Mail: Mail sent"];
			//[UIAlertView showMessage:FTLangGet(@"Your email has been sent") withTitle:FTLangGet(@"Email")];
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail send error: %@.", [error localizedDescription]);
			//[UIAlertView showMessage:[error localizedDescription] withTitle:FTLangGet(@"Error")];
			//FTAlertWithTitleAndMessage(FTLangGet(@"Error"), [error localizedDescription]);
			[FTTracking logEvent:@"Mail: Mail send failed"];
			break;
		default:
			break;
	}
	// hide the modal view controller
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma maek Message delegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
}

#pragma mark Creating elements

- (UIImage *)sharingImageForCurrentPage {
    if ([_dataSource respondsToSelector:@selector(photoBrowserViewController:requestsThumbnailImageWithIndex:)]) {
        return [_dataSource photoBrowserViewController:self requestsThumbnailImageWithIndex:0];
    }
    return nil;
}

- (ALAsset *)getAssetForIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(photoBrowserViewController:requestsAssetWithIndex:)]) {
        return [_dataSource photoBrowserViewController:self requestsAssetWithIndex:index];
    }
    return nil;
}

- (void)sendImageToTwitter:(UIImage *)img {
	[super.loadingProgressView setLabelText:FTLangGet(@"Posting to Twitter")];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"Cancelled");
        }
        else {
            NSLog(@"Done");
        }
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler = myBlock;
    
    [controller setInitialText:[NSString stringWithFormat:@"Photo from #%@ iPhone app", [PAConfig appName]]];
    //[controller addURL:[NSURL URLWithString:@"http://www.fuerteint.com/"]];
    [controller addImage:img];
    [self presentViewController:controller animated:YES completion:Nil];
}

- (void)prepareForTwitter:(ALAsset *)asset {
	UIImage *img = [self imageForSharingFromAsset:asset];
	[self performSelectorOnMainThread:@selector(sendImageToTwitter:) withObject:img waitUntilDone:NO];
}

- (void)sendImageOnFacebook:(UIImage *)img {
	//[super.loadingProgressView hide:YES];
    [super.loadingProgressView setLabelText:FTLangGet(@"Posting to Facebook")];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"Cancelled");
        }
        else {
            NSLog(@"Done");
        }
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler = myBlock;
    
    [controller setInitialText:[NSString stringWithFormat:@"Photo from %@ iPhone app", [PAConfig appName]]];
    //[controller addURL:[NSURL URLWithString:@"http://www.fuerteint.com/"]];
    [controller addImage:img];
    [self presentViewController:controller animated:YES completion:Nil];
}

- (void)prepareForFacebook:(ALAsset *)asset {
	UIImage *img = [self imageForSharingFromAsset:asset];
	[self performSelectorOnMainThread:@selector(sendImageOnFacebook:) withObject:img waitUntilDone:NO];
}


- (void)presentCustomActionSheet {
    __weak IconActionSheet *sheet = [IconActionSheet sheetWithTitle:nil];
    
    // Facebook
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [sheet addIconWithTitle:@"Facebook" image:[UIImage imageNamed:@"PA_icon_fb"] block:^{
            [self enableLoadingProgressViewWithTitle:FTLangGet(@"Generating image") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(prepareForFacebook:) onTarget:self withObject:[self getAssetForIndex:_currentIndex] animated:YES];
            [sheet dismissView];
        } atIndex:-1];
    }
    else{
        NSLog(@"Facebook unavailable!");
    }
    
    // Twitter
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [sheet addIconWithTitle:@"Twitter" image:[UIImage imageNamed:@"PA_icon_tw"] block:^{
            [self enableLoadingProgressViewWithTitle:FTLangGet(@"Generating image") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(prepareForTwitter:) onTarget:self withObject:[self getAssetForIndex:_currentIndex] animated:YES];
            
            [sheet dismissView];
        } atIndex:-1];
    }
    else{
        NSLog(@"Twitter unavailable!");
    }
    [sheet addIconWithTitle:@"Mail" image:[UIImage imageNamed:@"PA_icon_mail"] block:^{
        if ([MFMailComposeViewController canSendMail]) {
            [self enableLoadingProgressViewWithTitle:FTLangGet(@"Generating image") withAnimationStyle:FTProgressViewAnimationFade showWhileExecuting:@selector(prepareEmail:) onTarget:self withObject:[self getAssetForIndex:_currentIndex] animated:YES];
        }
        [sheet dismissView];
    } atIndex:-1];
//    [sheet addIconWithTitle:@"Print" image:[UIImage imageNamed:@"PA_icon_print"] block:^{
//        //label.text = @"You selected the settings icon!";
//        [sheet dismissView];
//    } atIndex:-1];
//    [sheet addIconWithTitle:@"iMessage" image:[UIImage imageNamed:@"PA_icon_imessage"] block:^{
//        //label.text = @"You selected the message icon!";
//        [sheet dismissView];
//    } atIndex:-1];
    [sheet addIconWithTitle:@"Postcard" image:[UIImage imageNamed:@"PA_icon_card"] block:^{
        ALAsset *asset = [self getAssetForIndex:_currentIndex];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        SYSincerelyController *controller = [[SYSincerelyController alloc] initWithImages:[NSArray arrayWithObject:[UIImage imageWithCGImage:iref]] product:SYProductTypePostcard applicationKey:[PAConfig sincerelyApiKey] delegate:self];
        if (controller) {
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
        [sheet dismissView];
    } atIndex:-1];
    
    [sheet showInView:self.view];
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    CGRect r = self.view.bounds;
    _scrollView = [[FT2PageScrollView alloc] initWithFrame:r];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnScreen:)];
    [_scrollView addGestureRecognizer:gr];
    [self.view addSubview:_scrollView];
    
    r.origin.y = ([self screenHeight] - 44);
    r.size.height = 44;
    _toolBar = [[UIToolbar alloc] initWithFrame:r];
    [_toolBar setAlpha:0];
    [_toolBar setTranslucent:YES];
    [_toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(presentCustomActionSheet)];
    [_toolBar setItems:[NSArray arrayWithObject:action]];
    [self.view addSubview:_toolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect r = self.view.bounds;
    [_scrollView setFrame:r];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setDataSource:self];
    [_scrollView setDelegate:self];
    [_scrollView reloadData];
    [_scrollView scrollToPageAtIndex:_customStartIndex animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showControls) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideControls];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_toolBar positionAtY:(320 - 44)];
            [_toolBar setWidth:568];
        }
        else {
            [_toolBar positionAtY:([[UIScreen mainScreen] bounds].size.height - 44)];
            [_toolBar setWidth:320];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setStartIndex:(NSInteger)index {
    _customStartIndex = index;
    NSInteger number = [self numberOfPagesInPageScrollView:_scrollView];
    [self setTitle:[NSString stringWithFormat:@"%d of %d", (index + 1), number]];
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

- (void)pageScrollView:(FT2PageScrollView *)scrollView didSlideToIndex:(NSInteger)index {
    NSInteger number = [self numberOfPagesInPageScrollView:_scrollView];
    [self setTitle:[NSString stringWithFormat:@"%d of %d", (index + 1), number]];
}

#pragma mark Sincerely delegate methods

- (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}


@end
