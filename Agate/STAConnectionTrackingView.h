//
//  STAConnectionTrackingView.h
//  Agate
//
//  Created by zeta on 2014/5/12.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STAConnectionTrackingView : NSView

+ (id)sharedView;

@property (nonatomic) BOOL plot;
@property (nonatomic) NSPoint start;
@property (nonatomic) NSPoint end;

@end
