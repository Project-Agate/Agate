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
#import "STAEventPort.h"
#import "STAAttributePort.h"
#import "QCPort+Addition.h"

@interface STAWidgetPatch ()

@property (nonatomic, strong) NSString* selectedElementId;
@property (nonatomic, strong) NSDictionary* selectedElementDetail;
@property (nonatomic, strong) QCPort* connectFromPort;
@property (nonatomic, strong) NSString* uid;

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
        patch.htmlPath = [filePath stringByStandardizingPath];
        
        WebView* webView = [[WebView alloc] initWithFrame:NSZeroRect];
        
        [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[filePath stringByStandardizingPath]]]];
        //NSURL* demo = [[[[STAgateAdditions sharedInstance] bundleURL] URLByAppendingPathComponent:@"webview"] URLByAppendingPathComponent:@"demo.html"];
        
        //[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:demo]];
        
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

- (void)nodeWillRemoveFromGraph {
    [self.webView removeFromSuperview];
}

#pragma mark - STASerializableProtocol

- (NSString *)uid {
    if (!_uid) {
        _uid = [[STAgateAdditions sharedInstance] generateUID];
    }
    return _uid;
}

- (NSArray *)agateSignals {
    NSMutableArray* signals = [NSMutableArray array];
    
    for (STAAttributePort* port in self.inputPorts) {
        QCPort* originalPort = [port ag_nonProxyOriginalPort];
        
        if (!originalPort) continue;
        NSAssert([[originalPort node] conformsToProtocol:@protocol(STASerializableProtocol)], @"The original port of %@ should be serializable", self);
        
        id attribute = @{
                         @"type": @"wAttribute",
                         @"uid": port.uid,
                         @"elementRef": [@"#VRAC-": port.elementId, nil],
                         @"signalRef": [(id<STASerializableProtocol>)[originalPort node] uid],
                         @"name": port.name
                       };
        [signals addObject:attribute];
    }
    
    NSArray* eventPorts = [self.outputPorts select:^BOOL(id object) {
        return ([object class] == [STAEventPort class]);
    }];
    
    NSArray* r_attributePorts = [self.outputPorts select:^BOOL(id object) {
        return ([object class] == [STAAttributePort class]);
    }];
    
    for (STAEventPort* port in eventPorts) {
        id event = @{
                     @"type": @"event",
                     @"uid": port.uid,
                     @"elementRef": [@"#VRAC-": port.elementId, nil],
                     @"eventType": port.eventType,
                     };
        [signals addObject:event];
    }
    
    for (STAAttributePort* port in r_attributePorts) {
        id attribute = @{
                        @"type": @"rAttribute",
                        @"uid": port.uid,
                        @"elementRef": [@"#VRAC-": port.elementId, nil],
                        @"name": port.name,
                    };
        [signals addObject:attribute];
    }
    
    NSMutableArray* ports = [NSMutableArray array];
    
    if (self.inputPorts) [ports addObjectsFromArray:self.inputPorts];
    if (self.outputPorts) [ports addObjectsFromArray:self.outputPorts];
    
    for (QCPort* port in ports) {
        id element = @{
                       @"uid": [@"#VRAC-": [(id)port elementId], nil],
                       @"widgetRef": self.uid,
                       @"selector": [@"#VRAC-": [(id)port elementId], nil],
                    };
        [signals addObject:element];
    }
    
    return signals;
}

- (id)widgetDictionary {
    NSDictionary* widget = @{
                             @"uid": self.uid,
                             @"htmlPath": self.htmlPath
                             };
    return widget;
}

#pragma mark - Custom Notification Handler

- (void)connectionStarted: (id) sender {
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
    [context setExceptionHandler:^(JSContext *c, JSValue *v) {
        NSLog(@"Exception: %@", v);
    }];
    
    // Injecting JQuery
    NSString* jqueryPath = [[[[STAgateAdditions sharedInstance] bundleURL] path] stringByAppendingString:@"/webview/lib/jquery.min.js"];
    
    [context evaluateScript:@"var ele = document.createElement('script')"];
    [context evaluateScript:[[@"ele.setAttribute('src','" stringByAppendingString:jqueryPath] stringByAppendingString:@"')"]];
    
    
    // Injecting Webview.js
    NSString* webviewPath = [[[[STAgateAdditions sharedInstance] bundleURL] path] stringByAppendingString:@"/webview/target/Webview.js"];
    
    [context evaluateScript:@"var ele2 = document.createElement('script')"];
    [context evaluateScript:[[@"ele2.setAttribute('src','" stringByAppendingString:webviewPath] stringByAppendingString:@"')"]];
    
    [context evaluateScript:@"ele.onload = function(){document.body.appendChild(ele2)}"];
    
    [context evaluateScript:@"document.body.appendChild(ele)"];
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
        
        self.selectedElementDetail = dict;
        
        for (NSString* event in dict[@"events"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:event action:@selector(toggleOutputPort:) keyEquivalent:@""];
            [item setTarget:self];
            [item setIndentationLevel:1];
            
            QCPort* thePort = [self.customOutputPorts detect:^BOOL(QCPort* port) {
                return [port.key isEqualToString:[self.selectedElementId: @"->", event, nil]];
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
    STAAttributePort* createdPort = [self createInputWithPortClass:[STAAttributePort class] forKey:portKey attributes:nil];
    createdPort.elementId = self.selectedElementId;
    createdPort.name = item.title;
    
    [[STAgateAdditions patchView] setNeedsDisplayForNode:self];
    for (QCPort* port in self.customInputPorts) {
        if ([port.key isEqualToString:portKey]) {
            [self.graph createConnectionFromPort:self.connectFromPort toPort:port];
        }
    }
}

- (void)toggleOutputPort: (NSMenuItem*) item {
    NSString* portKey = [self.selectedElementId:@"->", item.title, nil];
    
    QCPort* thePort = [self.customOutputPorts detect:^BOOL(QCPort* port) {
        return [port.key isEqualToString:portKey];
    }];
    
    if (thePort) {
        [self deleteOutputPortForKey:portKey];
    } else {
        if ([self.selectedElementDetail[@"events"] containsObject:item.title]) {
            STAEventPort* createdPort =[self createOutputWithPortClass:[STAEventPort class] forKey:portKey attributes:nil];
            createdPort.elementId = self.selectedElementId;
            createdPort.eventType = item.title;
        } else {
            STAAttributePort* createdPort = [self createOutputWithPortClass:[STAAttributePort class] forKey:portKey attributes:nil];
            createdPort.elementId = self.selectedElementId;
            createdPort.name = item.title;
        }
    }
    
    [[STAgateAdditions patchView] setNeedsDisplay:YES];
}


- (void)doNothingAction:(id)sender {
    
}

@end
