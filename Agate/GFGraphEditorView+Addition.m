//
//  GFGraphEditorView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/11.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "GFGraphEditorView+Addition.h"

@implementation GFGraphEditorView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      //  [[self class] swizzleMouseDrag];
    });
}

+ (void)swizzleMouseDrag {
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


- (void)ag_mouseMoved:(NSEvent *)theEvent {
    [self ag_mouseMoved:theEvent];
    
}


@end
