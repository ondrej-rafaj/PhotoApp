//
//  GPUImageStillCamera+LowPixelHandling.h
//  PhotoApp
//
//  Created by Ondrej Rafaj on 08/05/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "GPUImageStillCamera.h"

@interface GPUImageStillCamera (LowPixelHandling)

- (void)capturePhotoAsJPEGProcessedUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block andLowPixelTextureHandler:(void (^)(NSData *processedJPEG, NSError *error))lowPixelBlock;


@end
