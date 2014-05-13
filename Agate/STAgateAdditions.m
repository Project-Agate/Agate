//
//  STAgateAdditions.m
//  Agate
//
//  Created by zeta on 2014/5/13.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAgateAdditions.h"
#import "FBOrigamiAdditions.h"

@implementation STAgateAdditions

+ (QCPatchView *)patchView {
    id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
    QCPatchView* view = [shared performSelector:@selector(patchView)];
    return view;
}

@end
