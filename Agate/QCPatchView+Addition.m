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
#import "STAConnectionTrackingView.h"
#import "NSObject+Addition.h"

@implementation QCPatchView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ag_swizzleInstanceMethod:@selector(_drawConnection:fromPort:point:toPoint:)];
        [self ag_swizzleInstanceMethod:@selector(_drawNode:bounds:)];
    });
}

- (void)viewDidMoveToWindow {
    STAConnectionTrackingView* trackingView = [STAConnectionTrackingView sharedView];
    trackingView.frame = self.bounds;
    NSView* patchEditorView = [[self.superview superview] superview];
    [patchEditorView addSubview:trackingView];
}

- (void)ag__drawConnection:(id)fp8 fromPort:(id)fp12 point:(NSPoint)fp16 toPoint:(NSPoint)fp24 {
    //[self ag_drawConnection:fp8 fromPort:fp12 point:fp16 toPoint:fp24];
    
    NSPoint p = [self.window mouseLocationOutsideOfEventStream];
    [self mouseMoved:[NSEvent mouseEventWithType:NSMouseMoved location:p modifierFlags:0 timestamp:[[NSDate date] timeIntervalSince1970] windowNumber:[self.window windowNumber] context:[NSGraphicsContext currentContext] eventNumber:0 clickCount:1 pressure:0]];
    
    STAConnectionTrackingView* view = [STAConnectionTrackingView sharedView];
    
    view.plot = YES;
    view.start = [self convertPoint:fp16 toView:[STAConnectionTrackingView sharedView]];
    view.end = [self convertPoint:fp24 toView:[STAConnectionTrackingView sharedView]];
    [view setNeedsDisplay:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"agConnectionStart" object:nil userInfo:@{@"fromPort": fp12}];
}

- (void)ag__drawNode:(id)fp8 bounds:(NSRect)fp12 {
    [self ag__drawNode:fp8 bounds:fp12];
    if ([fp8 isKindOfClass:[STAWidgetPatch class]]) {
        //NSLog(@"%.f %.f %.f %.f",fp12.origin.x, fp12.origin.y, fp12.size.width, fp12.size.height);
        STAWidgetPatch* patch = fp8;
        if (!patch.webView) {
            NSRect frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 100, 500, 500);
            
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
            patch.webView.frame = NSMakeRect(fp12.origin.x, fp12.origin.y + 100, 500, 500);
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
