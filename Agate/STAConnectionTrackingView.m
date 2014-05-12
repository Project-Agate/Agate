//
//  STAConnectionTrackingView.m
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAConnectionTrackingView.h"

@implementation STAConnectionTrackingView

+ (id)sharedView {
    static STAConnectionTrackingView *_sharedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedView = [[STAConnectionTrackingView alloc] init];
    });
    return _sharedView;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSView *)hitTest:(NSPoint)aPoint {
    for (NSView* view in self.superview.subviews) {
        if ([view isKindOfClass:[NSScrollView class]]) {
            return [view hitTest:aPoint];
        }
    }
    return nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Create the shadow below and to the right of the shape.
    NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset:NSMakeSize(0, 0)];
    [theShadow setShadowBlurRadius:5.0];
    
    // Use a partially transparent color for shapes that overlap.
    [theShadow setShadowColor:[[NSColor redColor]
                               colorWithAlphaComponent:0.4]];
    
    [theShadow set];
    
    [[NSColor redColor] set];
    
    NSBezierPath* startCircle = [NSBezierPath bezierPathWithOvalInRect:CGRectOffset((CGRect){self.start, {4, 4}}, -2, -2)];
    
    NSBezierPath* endCircle = [NSBezierPath bezierPathWithOvalInRect:CGRectOffset((CGRect){self.end, {4, 4}}, -2, -2)];
    

    if (self.plot) {
        [startCircle fill];
        [endCircle fill];
    }

    NSBezierPath * path = [NSBezierPath bezierPath];
    
    [path setLineWidth: 2];
    [path setLineCapStyle:NSRoundLineCapStyle];
    
    [path  moveToPoint: self.start];
    [path lineToPoint:self.end];
    
    if (self.plot) {
        [path stroke];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
