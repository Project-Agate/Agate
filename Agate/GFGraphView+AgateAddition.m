//
//  GFGraphView+AgateAddition.m
//  Agate
//
//  Created by zeta on 2014/5/8.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "GFGraphView+AgateAddition.h"
#import "STAWidgetPatch.h"
#import "STAgatePrincipal.h"
#import <ReactiveCocoa/NSNotificationCenter+RACSupport.h>
#import "WebView+Addition.h"

@implementation GFGraphView (AgateAddition)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleDrawNode];
        //[[self class] swizzleDrawSelection];
        [[self class] swizzleMouseMoved];
        //[[self class] swizzleMouseDrag];
        //[[self class] swizzleTrackMouse];
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

+ (void)swizzleDrawSelection {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(_drawSelectionRingWithColor:width:forNode:bounds:);
    SEL swizzledSelector = @selector(ag_drawSelectionRingWithColor:width:forNode:bounds:);
    
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

+ (void)swizzleMouseDown {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(mouseDown:);
    SEL swizzledSelector = @selector(ag_mouseDown:);
    
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

+ (void)swizzleMouseDrag {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(mouseDown:);
    SEL swizzledSelector = @selector(ag_mouseDown:);
    
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

+ (void)swizzleTrackMouse {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(trackMouse:);
    SEL swizzledSelector = @selector(ag_trackMouse:);
    
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

- (BOOL)ag_trackMouse:(id)fp8 {
    BOOL v = [self ag_trackMouse:fp8];
    NSEvent* evt = fp8;
    if (evt.type == NSLeftMouseDown) {
        [self mouseMoved:fp8];
    }
    return v;
}

- (void)viewDidMoveToWindow {

NSTrackingArea* area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
[self addTrackingArea:area];
}

- (void)ag_mouseDown:(NSEvent *)theEvent {
    [self ag_mouseDown:theEvent];
    //[super mouseDown:theEvent];
}


- (void)ag_mouseMoved:(NSEvent *)theEvent {
    [self ag_mouseMoved:theEvent];
    [super mouseMoved:theEvent];
    NSLog(@"webview %.f %.f", [theEvent locationInWindow].x, [theEvent locationInWindow].y);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"mm" object:nil userInfo:@{@"e": theEvent}];
    //[self resignFirstResponder];
    //NSLog(@"%@", self.nextResponder);
}

//- (BOOL)ag_trackConnection:(id)fp8 fromPort:(id)fp12 atPoint:(NSPoint)fp16 {
  //  BOOL v = [self ag_trackConnection:fp8 fromPort:fp12 atPoint:fp16];
    //[self mouseMoved:[NSEvent alloc]]
//}

- (void)ag_drawNode:(id)fp8 bounds:(NSRect)fp12 {
    [self ag_drawNode:fp8 bounds:fp12];
    if ([fp8 isKindOfClass:[STAWidgetPatch class]]) {
        //NSLog(@"%.f %.f %.f %.f",fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
        STAWidgetPatch* patch = fp8;
        if (!patch.webView) {
            NSRect frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 500, 500);
            //NSBox* box = [[NSBox alloc] initWithFrame:frame];
            
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
            //[box setContentView:webView];
            
            [[RACSignal interval:0.001 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                //[self.window makeFirstResponder:webView];
            }];
            
            [self.window enableCursorRects];
            
            [self addSubview:webView];
            
            //[webView webViewFocus:webView];
            //[self.window makeFirstResponder:nil];
            //[webView becomeFirstResponder];
            //[self.window makeFirstResponder:webView];
            //[webView becomeFirstResponder];
        } else {
            patch.webView.frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 50, 500, 500);
        }
       // NSLog(@"%@", [fp8 userInfo]);
    }
    //GFNode* node = fp8;
    //NSLog(@"%@ %.f %.f %.f %.f",node, fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
}

- (void)ag_drawSelectionRingWithColor:(id)fp8 width:(CGFloat)fp12 forNode:(id)fp16 bounds:(NSRect)fp20 {
    [self ag_drawSelectionRingWithColor:fp8 width:fp12 forNode:fp16 bounds:fp20];
    
}

/*- (BOOL)trackConnection:(id)fp8 fromPort:(id)fp12 atPoint:(NSPoint)fp16 {
    NSLog(@"port: %@ to (%.f %.f)", fp12, fp16.x, fp16.y);
    return YES;
}*/

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags {
    NSLog(@"%@", elementInformation[@"WebElementDOMNode"]);
}

- (NSUInteger)webView:(WebView *)webView dragDestinationActionMaskForDraggingInfo:(id<NSDraggingInfo>)draggingInfo  {
    return WebDragDestinationActionAny;
}

@end
