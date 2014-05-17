//
//  QCPatch+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/14.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCPatch+Addition.h"
#import "STAWidgetPatch.h"
#import "NSObject+Addition.h"

@implementation QCPatch (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ag_swizzleInstanceMethod:@selector(deleteConnectionForKey:)];
    });
}

- (void)ag_deleteConnectionForKey:(NSString *)key {
    GFConnection* conn = [self connectionForKey:key];
    GFNode* node = conn.destinationPort.node;
    GFPort* port = conn.destinationPort;
    
    [self ag_deleteConnectionForKey:key];
    
    if ([node isKindOfClass:[STAWidgetPatch class]]) {
        [node deleteInputPortForKey:port.key];
    }
}

@end
