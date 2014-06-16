//
//  STARenerToPort.m
//  Agate
//
//  Created by zeta on 2014/6/16.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STARenerToPort.h"

@implementation STARenerToPort

- (id)initWithNode:(id)fp8 arguments:(NSDictionary *)args {
    self = [super initWithNode:fp8 arguments:args];
    if (self) {
       self.renderToRef = @"document";
    }
    return self;
}
@end
