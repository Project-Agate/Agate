//
//  STAgatePrincipal.m
//  Agate
//
//  Created by zeta on 2014/5/6.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAgatePrincipal.h"
#import "STAWidgetPatch.h"
#import "STAgateAdditions.h"

@implementation STAgatePrincipal

+ (void)registerNodesWithManager:(GFNodeManager *)manager {
    [manager registerNodeWithClass:[STAWidgetPatch class]];
    [[STAgateAdditions sharedInstance] addAgateMenu];
}

@end
