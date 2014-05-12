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
#import "FBOrigamiAdditions.h"

@interface EditorTracker : NSResponder <GFPlugInRegistration>

+ (id) sharedTracker;

@end


@implementation EditorTracker

+ (void)registerNodesWithManager:(GFNodeManager *)manager {
    [manager registerNodeWithClass:[STAWidgetPatch class]];
}


+ (id)sharedTracker {
    static EditorTracker *_sharedTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTracker = [[EditorTracker alloc] init];
    });
    return _sharedTracker;
}

- (void)mouseMoved:(NSEvent *)theEvent {
    //NSLog(@"tracker poked");
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSLog(@"tracker mouse dragged");
}

@end



@implementation GFGraphView (AgateAddition)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleDrawNode];
        [[self class] swizzleTrackConnection];
        //[[self class] swizzleDrawConnection];
        //[[self class] swizzleDrawSelection];
        [[self class] swizzleMouseMoved];
        [[self class] swizzleMouseDown];
        [[self class] swizzleMouseDrag];
        //[[self class] swizzleMouseDrag];
        [[self class] swizzleTrackMouse];
    });
}

+ (void)swizzleDrawConnection {
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = @selector(drawConnection:fromPoint:toPoint:);
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

- (void)_drawConnection:(id)fp8 fromPort:(id)fp12 point:(NSPoint)fp16 toPoint:(NSPoint)fp24{
    const CGSize contextSize = CGSizeMake(ceil(self.bounds.size.width), ceil(self.bounds.size.height));
    const size_t width = contextSize.width;
    const size_t height = contextSize.height;
    const size_t bytesPerPixel = 32;
    const size_t bitmapBytesPerRow = 64 * ((width * bytesPerPixel + 63) / 64 );
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, bitmapBytesPerRow, colorSpace, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    //[self ag_drawConnection:fp8 fromPort:fp12 point:fp16 toPoint:fp24];
    
    CGImageRef image = CGBitmapContextCreateImage(context);
     NSImage* nsImage = [[NSImage alloc] initWithCGImage:image size: NSMakeSize(CGImageGetWidth(image), CGImageGetHeight(image))];
    
    CGContextRelease(context);
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
    
    SEL originalSelector = @selector(mouseDragged:);
    SEL swizzledSelector = @selector(ag_mouseDragged:);
    
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
    
    SEL originalSelector = @selector(_trackMouse:inNode:bounds:);
    SEL swizzledSelector = @selector(ag_trackMouse:inNode:bounds:);
    
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

- (BOOL)ag_trackMouse:(id)fp8 {
    BOOL v = [self ag_trackMouse:fp8];
    NSEvent* evt = fp8;
    //if (evt.type == NSMouseMoved) {
        NSLog(@"dispatching");
        [self mouseMoved:fp8];
    //}
    return v;
}

- (void)ag_mouseDragged:(NSEvent *)theEvent {
    [self ag_mouseDragged:theEvent];
    NSLog(@"draggg");
}

- (void)viewDidMoveToWindow {

NSTrackingArea* area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
[self addTrackingArea:area];
}

- (void)ag_mouseDown:(NSEvent *)theEvent {
    [self ag_mouseDown:theEvent];
    if (theEvent.type == NSLeftMouseDragged) {
        NSLog(@"yo yo dragging");
    } else {
        NSLog(@"yo yo: %d", theEvent.type);
    }
    [super mouseDown:theEvent];
}


- (void)ag_mouseMoved:(NSEvent *)theEvent {
    [self ag_mouseMoved:theEvent];
    [super mouseMoved:theEvent];
    NSLog(@"webview %.f %.f", [theEvent locationInWindow].x, [theEvent locationInWindow].y);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"mm" object:nil userInfo:@{@"e": theEvent}];
    //[self resignFirstResponder];
    //NSLog(@"%@", self.nextResponder);
    if (theEvent.type == NSLeftMouseDragged || theEvent.type == NSLeftMouseDown) {
        NSLog(@"got me");
    }
}

- (BOOL)ag_trackConnection:(id)fp8 fromPort:(id)fp12 atPoint:(NSPoint)fp16 {
    BOOL v = [self ag_trackConnection:fp8 fromPort:fp12 atPoint:fp16];
    NSLog(@"connection yo!");
    return v;
}

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
            [self.window setAcceptsMouseMovedEvents:YES];
            
            NSView* splitV = [[self.superview superview] superview];
            /*[[splitV rac_signalForSelector:@selector(mouseMoved:)] subscribeNext:^(id x) {
                NSLog(@"split view move");
            }];*/
            
            
            
            [[[NSApp keyWindow] rac_signalForSelector:@selector(mou)] subscribeNext:^(id x) {
                NSLog(@"nsapp event happend");
            }];
            
            
            NSTrackingArea* area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag  owner:patch userInfo:nil];
            [[[NSApp keyWindow] contentView] addTrackingArea:area];

            
            //[context evaluateScript:@"Webview.startSelecting()"];
            webView.UIDelegate = self;
            webView.frameLoadDelegate = self;
            //[box setContentView:webView];
            
            [[RACSignal interval:0.01 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                NSPoint p = [self.window mouseLocationOutsideOfEventStream];
                NSLog(@"app event: %.f %.f", p.x, p.y);
                [self mouseMoved:[NSEvent mouseEventWithType:NSMouseMoved location:p modifierFlags:0 timestamp:[[NSDate date] timeIntervalSince1970] windowNumber:[self.window windowNumber] context:[NSGraphicsContext currentContext] eventNumber:0 clickCount:1 pressure:0]];
                
                //[self.window setAcceptsMouseMovedEvents:YES];
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

- (BOOL)ag_trackMouse:(id)fp8 inNode:(id)fp12 bounds:(NSRect)fp16 {
    BOOL v = [self ag_trackMouse:fp8 inNode:fp12 bounds:fp16];
    NSLog(@"new tracker");
    return v;
}

@end
