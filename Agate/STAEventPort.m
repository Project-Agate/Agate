//
//  STAEventPort.m
//  Agate
//
//  Created by zeta on 2014/5/19.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAEventPort.h"
#import "STAgateAdditions.h"

@interface STAEventPort ()

@property (nonatomic, strong, readwrite) NSString* uid;

@end

@implementation STAEventPort

- (NSString *)uid {
    if (!_uid) {
        _uid = [[STAgateAdditions sharedInstance] generateUID];
    }
    return _uid;
}

@end
