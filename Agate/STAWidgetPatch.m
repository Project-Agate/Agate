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


@implementation STAWidgetPatch {
    QCPort* connectFromPort;
    NSString* selectedElementId;
}

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

- (void)connectionStarted: (id) sender {
    JSGlobalContextRef ref = [[self.webView mainFrame] globalContext];
    JSContext* context = [JSContext contextWithJSGlobalContextRef:ref];
    [context evaluateScript:@"Webview.startSelecting()"];
    connectFromPort = [sender userInfo][@"fromPort"];
}

- (void)connectionEnded: (id) sender {
    JSGlobalContextRef ref = [[self.webView mainFrame] globalContext];
    JSContext* context = [JSContext contextWithJSGlobalContextRef:ref];
    JSValue* selectedElement = [context evaluateScript:@"Webview.getCurrentElementDetail()"];
    if (![selectedElement isNull]) {
        // show contextual menu
        selectedElementId = [selectedElement[@"uid"] toString];
        
        NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Select Binding"];
        
        NSMenuItem* sectionTitleItem = [[NSMenuItem alloc] initWithTitle:@"Events" action:nil keyEquivalent:@""];
        [theMenu addItem:sectionTitleItem];
        
        NSDictionary* dict = [selectedElement toDictionary];
        for (NSString* event in dict[@"events"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:event action:@selector(menuItemSelected:) keyEquivalent:@""];
            [item setTarget:self];
            [item setIndentationLevel:1];
            [theMenu addItem:item];
        }
        
        [theMenu insertItem:[NSMenuItem separatorItem] atIndex:theMenu.itemArray.count];
        NSMenuItem* sectionTitleItem2 = [[NSMenuItem alloc] initWithTitle:@"Attributes" action:nil keyEquivalent:@""];
        [theMenu addItem:sectionTitleItem2];
        
        for (NSString* attribute in dict[@"attributes"]) {
            NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:attribute action:@selector(menuItemSelected:) keyEquivalent:@""];
            [item setTarget:self];
            [item setIndentationLevel:1];
            [theMenu addItem:item];
        }
        
        NSPoint p = [[NSApp keyWindow] mouseLocationOutsideOfEventStream];
        NSEvent* event = [NSEvent mouseEventWithType:NSMouseMoved location:p modifierFlags:0 timestamp:[[NSDate date] timeIntervalSince1970] windowNumber:[[NSApp keyWindow] windowNumber] context:[NSGraphicsContext currentContext] eventNumber:0 clickCount:1 pressure:0];
        
        [NSMenu popUpContextMenu:theMenu withEvent:event forView:[STAConnectionTrackingView sharedView]];
    }
    [context evaluateScript:@"Webview.clearSelection()"];
    [context evaluateScript:@"Webview.stopSelecting()"];
}

- (void)menuItemSelected:(NSMenuItem*)item {
    NSString* portKey = [[selectedElementId stringByAppendingString:@"."] stringByAppendingString:item.title];
    [self createInputWithPortClass:[QCVirtualPort class] forKey:portKey attributes:nil];
    [[STAgateAdditions patchView] setNeedsDisplayForNode:self];
    for (QCPort* port in self.customInputPorts) {
        if ([port.key isEqualToString:portKey]) {
            [self.graph createConnectionFromPort:connectFromPort toPort:port];
        }
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



@end
