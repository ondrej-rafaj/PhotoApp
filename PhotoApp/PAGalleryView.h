//
//  PAGalleryView.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 30/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "AQGridView.h"

@interface PAGalleryView : UIView <AQGridViewDelegate, AQGridViewDataSource> {
	
	AQGridView *grid;
	
}

@property (nonatomic, strong) NSArray *data;

- (void)reloadData;


@end
