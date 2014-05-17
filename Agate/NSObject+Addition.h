//
//  NSObject+Addition.h
//  Agate
//
//  Created by zeta on 2014/5/15.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Dump)

+ (void)ag_swizzleInstanceMethod:(SEL)methodSel;

@end
