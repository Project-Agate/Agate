//
//  STAgateAdditions.h
//  Agate
//
//  Created by zeta on 2014/5/13.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//
@class QCPatchView;

#import <Foundation/Foundation.h>

@interface STAgateAdditions : NSObject
+ (id)sharedInstance;
+ (QCPatchView*) patchView;

- (QCPatch*) currentPatch;
- (void)addAgateMenu;
- (NSURL*) bundleURL;
- (NSString*) generateUID;

@end
