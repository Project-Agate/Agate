//
//  GFGraphView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "GFGraphView+Addition.h"
#import "STAConnectionTrackingView.h"
#import "NSObject+Addition.h"

@implementation GFGraphView (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ag_swizzleInstanceMethod:@selector(mouseMoved:)];
        [self ag_swizzleInstanceMethod:@selector(trackConnection:fromPort:atPoint:)];
    });
}

- (void)ag_mouseMoved:(NSEvent *)theEvent {
    [self ag_mouseMoved:theEvent];
    [super mouseMoved:theEvent];
}

- (BOOL)ag_trackConnection:(id)fp8 fromPort:(id)fp12 atPoint:(NSPoint)fp16 {
    BOOL v = [self ag_trackConnection:fp8 fromPort:fp12 atPoint:fp16];
    STAConnectionTrackingView* view = [STAConnectionTrackingView sharedView];
    view.plot = NO;
    [view setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"agConnectionEnd" object:nil];
    return v;
}
@end
