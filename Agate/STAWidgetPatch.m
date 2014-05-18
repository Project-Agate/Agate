//
//  STAWidgetPatch.m
//  Agate
//
//  Created by zeta on 2014/5/6.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAWidgetPatch.h"
#import "Origami/FBOrigamiAdditions.h"
#import "STAConnectionTrackingView.h"
#import "STAgateAdditions.h"
#import "QCPatchView+Addition.h"
#import "WebView+Addition.h"

@interface STAWidgetPatch ()

@property (nonatomic, strong) NSString* selectedElementId;
@property (nonatomic, strong) QCPort* connectFromPort;

@end

@implementation STAWidgetPatch

+(BOOL)isSafe
{
	return NO;
}

+(BOOL)allowsSubpatchesWithIdentifier:(id)identifier
{
	return NO;
}

+(int)executionModeWithIdentifier:(id)identifier
{
	return 0;
}

+(int)timeModeWithIdentifier:(id)identifier
{
	return 0;
}

+ (BOOL)canInstantiateWithFile:(NSString *)filePath {
    return [[filePath pathExtension] isEqualToString:@"html"];
}

+ (id)instantiateWithFile:(NSString *)filePath {
    STAWidgetPatch* patch = [[[self class] alloc] initWithIdentifier:nil];
    if (patch) {
        patch.htmlPath = filePath;
        
        WebView* webView = [[WebView alloc] initWithFrame:NSZeroRect];
        
        //[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[filePath stringByStandardizingPath]]]];
        NSURL* demo = [[[[STAgateAdditions sharedInstance] bundleURL] URLByAppendingPathComponent:@"webview"] URLByAppendingPathComponent:@"demo.html"];
        
        [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:demo]];
        
        patch.webView = webView;
    }
    return patch;
}


-(id)initWithIdentifier:(id)identifier
{
	if(self = [super initWithIdentifier:identifier])
	{
		[[self userInfo] setObject:@"Agate Widget" forKey:@"name"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStarted:) name:@"agConnectionStart" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionEnded:) name:@"agConnectionEnd" object:nil];
	}
	return self;
}

-(BOOL)setup:(QCOpenGLContext*)context
{
	return YES;
}

-(void)cleanup:(QCOpenGLContext*)context
{
}

-(void)enable:(QCOpenGLContext*)context
{
}

-(void)disable:(QCOpenGLContext*)context
{
}

-(BOOL)execute:(QCOpenGLContext*)context time:(double)time arguments:(NSDictionary*)arguments
{
    if (self.webView) {
        [self.webView becomeFirstResponder];
    }
	return YES;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
}

- (void)setWebView:(WebView *)webView {
    if (webView != _webView) {
        _webView = webView;
        _webView.UIDelegate = self;
        _webView.frameLoadDelegate = self;
    }
}

- (void)stateUpdated {
    if (!self.userInfo[@".old-position"] && self.userInfo[@"position"]) {
        id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
        QCPatchView* view = [shared performSelector:@selector(patchView)];
        
        NSPoint point;
        [self.userInfo[@"position"] getValue:&point];
        
        NSLog(@"%.f %.f", point.x, point.y);
        //NSTextField* field = [[NSTextField alloc] initWithFrame:NSMakeRect(size.x, size.y, 100, 20)];
        //[gv addSubview:field];
        
    } else if (self.userInfo[@"position"]) {
        if (self.webView) {
            //NSPoint point;
            //[self.userInfo[@"position"] getValue:&point];
            //self.webView.frame = NSMakeRect(point.x, point.y, 100, 100);
        }
    }
    //NSLog(@"userinfo: %@", self.userInfo);
}

#pragma mark - Custom Notification Handler

- (void)connectionStarted: (id) sender {
    JSGlobalContextRef ref = [[self.webView mainFrame] globalContext];
    JSContext* context = [JSContext contextWithJSGlobalContextRef:ref];
    [context evaluateScript:@"Webview.startSelecting()"];
    self.connectFromPort = [sender userInfo][@"fromPort"];
}

- (void)connectionEnded: (id) sender {
    JSValue* selectedElement = [self.webView.ag_jsContext evaluateScript:@"Webview.getCurrentElementDetail()"];
    if (![selectedElement isNull]) {
        // show contextual menu
        self.selectedElementId = [[selectedElement[@"uid"] toString] stringByReplacingOccurrencesOfString:@"VRAC-" withString:@""];
        
        NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Select Binding"];
        
        NSDictionary* dict = [selectedElement toDictionary];
        
        for (NSString* attribute in dict[@"attributes"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:attribute action:@selector(menuItemSelected:) keyEquivalent:@""];
            [item setTarget:self];
            [theMenu addItem:item];
        }
        
        NSPoint p = [[NSApp keyWindow] mouseLocationOutsideOfEventStream];
        NSEvent* event = [NSEvent mouseEventWithType:NSMouseMoved location:p modifierFlags:0 timestamp:[[NSDate date] timeIntervalSince1970] windowNumber:[[NSApp keyWindow] windowNumber] context:[NSGraphicsContext currentContext] eventNumber:0 clickCount:1 pressure:0];
        
        [NSMenu popUpContextMenu:theMenu withEvent:event forView:[STAConnectionTrackingView sharedView]];
    }
}

#pragma mark - NSMenuValidation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if ([menuItem action] == @selector(doNothingAction:)) {
        return NO;
    } else {
        return YES;
    }
    
}

#pragma mark - WebView Delegate

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags {
    //NSLog(@"%@", elementInformation[@"WebElementDOMNode"]);
}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    JSContext* context = sender.ag_jsContext;
    [context evaluateScript:@"Webview.startSelecting()"];
    //[context setExceptionHandler:^(JSContext *c, JSValue *v) {
    //    NSLog(@"Exception: %@", v);
    //}];
    
    
    //NSString* jqueryPath = [[[[STAgateAdditions sharedInstance] bundleURL] path] stringByAppendingString:@"/webview/lib/jquery.min.js"];
    
    //[context evaluateScript:@"var ele = document.createElement('script')"];
    //[context evaluateScript:[[@"ele.setAttribute('src','" stringByAppendingString:jqueryPath] stringByAppendingString:@"')"]];
    //[context evaluateScript:@"document.body.appendChild(ele)"];
    
    
    //NSString* webviewPath = [[[[STAgateAdditions sharedInstance] bundleURL] path] stringByAppendingString:@"/webview/target/Webview.js"];
    
    //[context evaluateScript:@"var ele = document.createElement('script')"];
    //[context evaluateScript:[[@"ele.setAttribute('src','" stringByAppendingString:webviewPath] stringByAppendingString:@"')"]];
    //[context evaluateScript:@"document.body.appendChild(ele)"];
    
    //JSValue* webviewLib = [context evaluateScript:@"document.createElement('script')"];
    //[jqueryLib[@"setAttribute"] callWithArguments:@[@"src", webviewPath]];
    
    //[context[@"document"][@"body"][@"appendChild"] callWithArguments:@[webviewLib]];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
    JSValue* selectedElement = [sender.ag_jsContext evaluateScript:@"Webview.getCurrentElementDetail()"];
    
    if (![selectedElement isNull]) {
        // show contextual menu
        self.selectedElementId = [[selectedElement[@"uid"] toString] stringByReplacingOccurrencesOfString:@"VRAC-" withString:@""];
        
        NSMutableArray* items = [NSMutableArray array];
        
        NSMenuItem* sectionTitleItem = [[NSMenuItem alloc] initWithTitle:@"Events" action:@selector(doNothingAction:) keyEquivalent:@""];
        [sectionTitleItem setTarget:self];
        [items addObject:sectionTitleItem];
        
        NSDictionary* dict = [selectedElement toDictionary];
        for (NSString* event in dict[@"events"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:event action:@selector(toggleOutputPort:) keyEquivalent:@""];
            [item setTarget:self];
            [item setIndentationLevel:1];
            
            QCPort* thePort = [self.customOutputPorts detect:^BOOL(QCPort* port) {
                return [port.key isEqualToString:[self.selectedElementId: @".", event, nil]];
            }];
            
            if (thePort) {
                [item setState:NSOnState];
            } else {
                [item setState:NSOffState];
            }
            
            [items addObject:item];
        }
        
        [items addObject:[NSMenuItem separatorItem]];
        
        NSMenuItem* sectionTitleItem2 = [[NSMenuItem alloc] initWithTitle:@"Attributes" action:@selector(doNothingAction:) keyEquivalent:@""];
        [items addObject:sectionTitleItem2];
        [sectionTitleItem2 setTarget:self];
        
        for (NSString* attribute in dict[@"attributes"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:attribute action:@selector(toggleOutputPort:) keyEquivalent:@""];
            [item setTarget:self];
            [item setIndentationLevel:1];
            
            QCPort* thePort = [self.customOutputPorts detect:^BOOL(QCPort* port) {
                return [port.key isEqualToString:[self.selectedElementId: @".", attribute, nil]];
            }];
            
            if (thePort) {
                [item setState:NSOnState];
            } else {
                [item setState:NSOffState];
            }
            
            [items addObject:item];
        }
        
        return items;
    } else {
        return defaultMenuItems;
    }
}

#pragma mark - Private Methods

- (void)menuItemSelected:(NSMenuItem*)item {
    NSString* portKey = [[self.selectedElementId stringByAppendingString:@"."] stringByAppendingString:item.title];
    [self createInputWithPortClass:[QCVirtualPort class] forKey:portKey attributes:nil];
    [[STAgateAdditions patchView] setNeedsDisplayForNode:self];
    for (QCPort* port in self.customInputPorts) {
        if ([port.key isEqualToString:portKey]) {
            [self.graph createConnectionFromPort:self.connectFromPort toPort:port];
        }
    }
}

- (void)toggleOutputPort: (NSMenuItem*) item {
    NSString* portKey = [self.selectedElementId:@".", item.title, nil];
    
    QCPort* thePort = [self.customOutputPorts detect:^BOOL(QCPort* port) {
        return [port.key isEqualToString:portKey];
    }];
    
    if (thePort) {
        [self deleteOutputPortForKey:portKey];
    } else {
        [self createOutputWithPortClass:[QCVirtualPort class] forKey:portKey attributes:nil];
    }
    
    [[STAgateAdditions patchView] setNeedsDisplay:YES];
}


- (void)doNothingAction:(id)sender {
    
}

@end
