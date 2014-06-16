//
//  STAPlaceholderPort.m
//  Agate
//
//  Created by zeta on 2014/6/16.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAPlaceholderPort.h"

@implementation STAPlaceholderPort

- (NSString *)uid {
    return [NSString stringWithFormat:@"#VRAC-%@", [self.key substringFromIndex:1]];
}

@end