//
//  STAgatePrincipal.h
//  Agate
//
//  Created by zeta on 2014/5/6.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAgatePrincipal : NSObject <GFPlugInRegistration>
+ (void)registerNodesWithManager:(GFNodeManager *)manager;
@end
