//
//  GPUImageLomoFilter.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 08/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "GPUImageLomoFilter.h"

NSString *const kGPUImageLomoFragmentShaderString = SHADER_STRING
(
 // vignette
 uniform sampler2D inputImageTexture;
 varying highp vec2 textureCoordinate;
 
 uniform highp float vignetteX;
 uniform highp float vignetteY;
 
 // contrast
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float contrast;
 
 void main()
{
	// vignette
    lowp vec3 rgb = texture2D(inputImageTexture, textureCoordinate).xyz;
    lowp float d = distance(textureCoordinate, vec2(0.5,0.5));
    rgb *= smoothstep(vignetteX, vignetteY, d);
    gl_FragColor = vec4(vec3(rgb),1.0);
	
	// contrast
	lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
	gl_FragColor = vec4(((textureColor.rgb - vec3(0.5)) * contrast + vec3(0.5)), textureColor.w);
}
 );

NSString *const kGPUImageContrastFragmentShaderString2 = SHADER_STRING
( 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float contrast;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(((textureColor.rgb - vec3(0.5)) * contrast + vec3(0.5)), textureColor.w);
 }
 );



@implementation GPUImageLomoFilter

@synthesize x=_x, y=_y;
@synthesize contrast = _contrast;


#pragma mark -
#pragma mark Initialisation

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLomoFragmentShaderString]))
    {
		return nil;
    }
    
    xUniform = [filterProgram uniformIndex:@"vignetteX"];
    yUniform = [filterProgram uniformIndex:@"vignetteY"];
	
	contrastUniform = [filterProgram uniformIndex:@"contrast"];
    self.contrast = 1.0;
    
    self.x = 0.75;
    self.y = 0.50;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setContrast:(CGFloat)newValue;
{
    _contrast = newValue;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(contrastUniform, _contrast);
}

- (void) setX:(CGFloat)x {
    _x = x;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(xUniform, _x);
}

- (void) setY:(CGFloat)y {
    _y = y;
    
    [GPUImageOpenGLESContext useImageProcessingContext];
    [filterProgram use];
    glUniform1f(yUniform, _y);
}


@end
