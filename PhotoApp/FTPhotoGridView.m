//
//  FTPhotoGridView.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 24/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTPhotoGridView.h"

@implementation FTPhotoGridView


- (BOOL)isBigScreen {
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        return YES;
    }
    else return NO;
}

- (CGFloat)screenHeight {
    if ([self isBigScreen]) return 568;
    else return 480;
}

- (id)init {
    self = [super init];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setClearsContextBeforeDrawing:YES];
        [self setFrame:CGRectMake(0, 0, 320, [self screenHeight])];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(ctx, 1);
	
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.1);
	
    CGContextMoveToPoint(ctx, 104, 0);
    CGContextAddLineToPoint(ctx, 104, [self screenHeight]);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 106, 0);
    CGContextAddLineToPoint(ctx, 106, [self screenHeight]);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, (320 - 104), 0);
    CGContextAddLineToPoint(ctx, (320 - 104), [self screenHeight]);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, (320 - 106), 0);
    CGContextAddLineToPoint(ctx, (320 - 106), [self screenHeight]);
    CGContextStrokePath(ctx);
    
    CGFloat y1 = ([self isBigScreen]) ? 186 : 141;
    CGFloat y2 = ([self isBigScreen]) ? 329 : 284;
	
	CGContextMoveToPoint(ctx, 0, y1);
    CGContextAddLineToPoint(ctx, 320, y1);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, (y1 + 2));
    CGContextAddLineToPoint(ctx, 320, (y1 + 2));
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, y2);
    CGContextAddLineToPoint(ctx, 320, y2);
    CGContextStrokePath(ctx);
	
	CGContextMoveToPoint(ctx, 0, (y2 + 2));
    CGContextAddLineToPoint(ctx, 320, (y2 + 2));
    CGContextStrokePath(ctx);

	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.4);
	
    CGContextMoveToPoint(ctx, 105, 0);
    CGContextAddLineToPoint(ctx, 105, [self screenHeight]);
    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, (320 - 105), 0);
    CGContextAddLineToPoint(ctx, (320 - 105), [self screenHeight]);
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, (y1 + 1));
    CGContextAddLineToPoint(ctx, 320, (y1 + 1));
    CGContextStrokePath(ctx);
	
    CGContextMoveToPoint(ctx, 0, (y2 + 1));
    CGContextAddLineToPoint(ctx, 320, (y2 + 1));
    CGContextStrokePath(ctx);
}

@end
