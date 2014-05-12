//
//  QCPatchView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCPatchView+Addition.h"
#import "STAWidgetPatch.h"
#import "STAgatePrincipal.h"
#import "GFGraphView+Addition.h"

@implementation QCPatchView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleDrawConnection];
        [[self class] swizzleDrawNode];
    });
}

+ (void)swizzleDrawNode {
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
    [self ag_drawConnection:fp8 fromPort:fp12 point:fp16 toPoint:fp24];
    
    NSPoint p = [self.window mouseLocationOutsideOfEventStream];
    [self mouseMoved:[NSEvent mouseEventWithType:NSMouseMoved location:p modifierFlags:0 timestamp:[[NSDate date] timeIntervalSince1970] windowNumber:[self.window windowNumber] context:[NSGraphicsContext currentContext] eventNumber:0 clickCount:1 pressure:0]];
}

- (void)ag_drawNode:(id)fp8 bounds:(NSRect)fp12 {
    [self ag_drawNode:fp8 bounds:fp12];
    if ([fp8 isKindOfClass:[STAWidgetPatch class]]) {
        //NSLog(@"%.f %.f %.f %.f",fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
        STAWidgetPatch* patch = fp8;
        if (!patch.webView) {
            NSRect frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 500, 500);
            
            WebView* webView = [[WebView alloc] initWithFrame:frame];
            id path = [[NSBundle bundleForClass:[STAgatePrincipal class]] URLForResource:@"demo" withExtension:@"html" subdirectory:@"webview"];
            id html = [[NSString alloc] initWithContentsOfURL:path];
            //[[webView mainFrame]loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:@"http://www.facebook.com"]]];
            [[self window] setAcceptsMouseMovedEvents:YES];
            [[webView mainFrame] loadHTMLString:html baseURL:[[[NSBundle bundleForClass:[STAgatePrincipal class]] resourceURL] URLByAppendingPathComponent:@"webview"]];
            patch.webView = webView;
            JSGlobalContextRef ref = [[webView mainFrame] globalContext];
            JSContext* context = [JSContext contextWithJSGlobalContextRef:ref];
            //[context setExceptionHandler:^(JSContext *c, JSValue *v) {
            
            //}];
            
            //[context evaluateScript:@"Webview.startSelecting()"];
            webView.UIDelegate = self;
            webView.frameLoadDelegate = self;
            
            [self addSubview:webView];
        } else {
            patch.webView.frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 500, 500);
        }
        // NSLog(@"%@", [fp8 userInfo]);
    }
    //GFNode* node = fp8;
    //NSLog(@"%@ %.f %.f %.f %.f",node, fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
}

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags {
    NSLog(@"%@", elementInformation[@"WebElementDOMNode"]);
}

@end
