//
//  GPUImageLomoFilter.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 08/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "GPUImageColorMatrixFilter.h"

@interface GPUImageLomoFilter : GPUImageColorMatrixFilter {
	GLint xUniform, yUniform;
	GLint contrastUniform;
}

// The directional intensity of the vignette effect, with a default of x = 0.75, y = 0.5
@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;

// Contrast ranges from 0.0 to 4.0 (max contrast), with 1.0 as the normal level
@property(readwrite, nonatomic) CGFloat contrast; 


@end