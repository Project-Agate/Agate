//
//  GFGraphView+AgateAddition.m
//  Agate
//
//  Created by zeta on 2014/5/8.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "GFGraphView+AgateAddition.h"
#import "STAWidgetPatch.h"

@implementation GFGraphView (AgateAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(_drawNode:bounds:);
        SEL swizzledSelector = @selector(ag_drawNode:bounds:);
        
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
    });
}

- (void)ag_drawNode:(id)fp8 bounds:(NSRect)fp12 {
    [self ag_drawNode:fp8 bounds:fp12];
    if ([fp8 isKindOfClass:[STAWidgetPatch class]]) {
        NSLog(@"%.f %.f %.f %.f",fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
        STAWidgetPatch* patch = fp8;
        if (!patch.webView) {
            NSRect frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 200, 100);
            WebView* webView = [[WebView alloc] initWithFrame:frame];
            patch.webView = webView;
            [self addSubview:webView];
        } else {
            patch.webView.frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 200, 100);
        }
       // NSLog(@"%@", [fp8 userInfo]);
    }
    //GFNode* node = fp8;
    //NSLog(@"%@ %.f %.f %.f %.f",node, fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
}


@end
