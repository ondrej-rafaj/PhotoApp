//
//  FTCameraButtonView.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCameraButtonView : UIButton {
	
	BOOL highligtEnabled;
	
}

- (void)enableHighlight:(BOOL)enable;

@end
