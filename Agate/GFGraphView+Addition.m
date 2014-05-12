//
//  GFGraphView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "GFGraphView+Addition.h"
#import "STAConnectionTrackingView.h"

@implementation GFGraphView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleMouseMoved];
        [[self class] swizzleTrackConnection];
    });
}

+ (void)swizzleMouseMoved {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(mouseMoved:);
    SEL swizzledSelector = @selector(ag_mouseMoved:);
    
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

+ (void)swizzleTrackConnection {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(trackConnection:fromPort:atPoint:);
    SEL swizzledSelector = @selector(ag_trackConnection:fromPort:atPoint:);
    
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

- (void)ag_mouseMoved:(NSEvent *)theEvent {
    [self ag_mouseMoved:theEvent];
    [super mouseMoved:theEvent];
}

- (BOOL)ag_trackConnection:(id)fp8 fromPort:(id)fp12 atPoint:(NSPoint)fp16 {
    BOOL v = [self ag_trackConnection:fp8 fromPort:fp12 atPoint:fp16];
    STAConnectionTrackingView* view = [STAConnectionTrackingView sharedView];
    view.plot = NO;
    [view setNeedsDisplay:YES];
    return v;
}
@end
