//
//  FTPhotoGridView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 24/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTPhotoGridView.h"

@implementation FTPhotoGridView



- (id)init {
    self = [super init];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setClearsContextBeforeDrawing:YES];
        [self setFrame:CGRectMake(0, 0, 320, 480)];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.4] set];
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//CGContextClearRect(ctx, rect);
    
	CGContextSetLineWidth(ctx, 1);
	
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.1);
	
    CGContextMoveToPoint(ctx, 104, 0);
    CGContextAddLineToPoint(ctx, 104, 480);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 106, 0);
    CGContextAddLineToPoint(ctx, 106, 480);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, (320 - 104), 0);
    CGContextAddLineToPoint(ctx, (320 - 104), 480);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, (320 - 106), 0);
    CGContextAddLineToPoint(ctx, (320 - 106), 480);
    CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, 0, 141);
    CGContextAddLineToPoint(ctx, 320, 141);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, 143);
    CGContextAddLineToPoint(ctx, 320, 143);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, 284);
    CGContextAddLineToPoint(ctx, 320, 284);
    CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, 0, 286);
    CGContextAddLineToPoint(ctx, 320, 286);
    CGContextStrokePath(ctx);

	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.4);
	
    CGContextMoveToPoint(ctx, 105, 0);
    CGContextAddLineToPoint(ctx, 105, 480);
    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, (320 - 105), 0);
    CGContextAddLineToPoint(ctx, (320 - 105), 480);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, 142);
    CGContextAddLineToPoint(ctx, 320, 142);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, 285);
    CGContextAddLineToPoint(ctx, 320, 285);
    CGContextStrokePath(ctx);
}

@end
