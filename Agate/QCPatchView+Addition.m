//
//  QCPatchView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCPatchView+Addition.h"

@implementation QCPatchView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleDrawConnection];
    });
}

+ (void)swizzleDrawConnection {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(_drawConnection:fromPort:point:toPoint:);
    SEL swizzledSelector = @selector(ag_drawConnection:fromPort:point:toPoint:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ag_drawConnection:(id)fp8 fromPort:(id)fp12 point:(NSPoint)fp16 toPoint:(NSPoint)fp24 {
    const CGSize contextSize = CGSizeMake(ceil(self.bounds.size.width), ceil(self.bounds.size.height));
    const size_t width = contextSize.width;
    const size_t height = contextSize.height;
    const size_t bytesPerPixel = 32;
    const size_t bitmapBytesPerRow = 64 * ((width * bytesPerPixel + 63) / 64 );
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bitmapBytesPerRow, colorSpace, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    [self ag_drawConnection:fp8 fromPort:fp12 point:fp16 toPoint:fp24];
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: NSMakeSize(CGImageGetWidth(image), CGImageGetHeight(image))];
    
    CGContextRelease(context);
}

@end
