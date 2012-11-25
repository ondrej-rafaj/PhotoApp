//
//  GPUImageStillCamera+LowPixelHandling.m
//  PhotoApp
//
//  Created by Ondrej Rafaj on 08/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "GPUImageStillCamera+LowPixelHandling.h"
#import <CoreImage/CoreImage.h>


@implementation GPUImageStillCamera (LowPixelHandling)

- (void)capturePhotoAsJPEGProcessedUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *, NSError *))block andLowPixelTextureHandler:(void (^)(NSData *, NSError *))lowPixelBlock {
//    report_memory(@"Before still image capture");
//    [photoOutput captureStillImageAsynchronouslyFromConnection:[[photoOutput connections] objectAtIndex:0] completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
//        report_memory(@"Before filter processing");
//        
//		NSData *dataForJPEGFile = nil;
//		
//		//*
//		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(imageSampleBuffer);
//		CVPixelBufferLockBaseAddress(imageBuffer,0); 
//		size_t width = CVPixelBufferGetWidth(imageBuffer); 
//		size_t height = CVPixelBufferGetHeight(imageBuffer);
//		int maxTextureSize = ([GPUImageOpenGLESContext maximumTextureSizeForThisDevice] - 32);
//		// Dev hack to get inside even on iPhone 4s !!!!!!
//		//maxTextureSize = (maxTextureSize / 2);
//		if (width >= maxTextureSize || height >= maxTextureSize) {
//			CIImage *image = [CIImage imageWithCVPixelBuffer:imageBuffer];
//			CIContext *context = [CIContext contextWithOptions:nil];                
//			CGAffineTransform t = CGAffineTransformMakeScale(0.59, 0.59);
//			//t = CGAffineTransformRotate(t, (M_PI * -90 / 180.0));
//			image = [image imageByApplyingTransform:t];
//			
//			CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
//			UIImage *filteredPhoto = filteredPhoto = [UIImage imageWithCGImage:cgimg];
//			dataForJPEGFile = UIImageJPEGRepresentation(filteredPhoto, 0.8);
//            
//			CGImageRelease(cgimg);
//			
//			lowPixelBlock(dataForJPEGFile, error);
//		}
//		
//        [self captureOutput:photoOutput didOutputSampleBuffer:imageSampleBuffer fromConnection:[[photoOutput connections] objectAtIndex:0]];
//        report_memory(@"After filter processing");
//        
//        @autoreleasepool {
//            UIImage *filteredPhoto = [finalFilterInChain imageFromCurrentlyProcessedOutput];
//            
//            report_memory(@"After UIImage generation");
//			
//            dataForJPEGFile = UIImageJPEGRepresentation(filteredPhoto, 0.8);
//            report_memory(@"After JPEG generation");
//        }
//		
//        report_memory(@"After autorelease pool");
//		
//        block(dataForJPEGFile, error);        
//    }];
//    
//    return;
}

@end
