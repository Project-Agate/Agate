//
//  QCPatch+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/14.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCPatch+Addition.h"
#import "STAWidgetPatch.h"

@implementation QCPatch (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleDeleteConnection];
    });
}

- (void)ag_deleteConnectionForKey:(NSString *)key {
    GFConnection* conn = [self connectionForKey:key];
    GFNode* node = conn.destinationPort.node;
    GFPort* port = conn.destinationPort;
    
    [self ag_deleteConnectionForKey:key];
    
    if ([node isKindOfClass:[STAWidgetPatch class]]) {
        [node deleteInputPortForKey:port.key];
    }
}

+ (void)swizzleDeleteConnection {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(deleteConnectionForKey:);
    SEL swizzledSelector = @selector(ag_deleteConnectionForKey:);
    
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





@end
