//
//  STAConstantPatch.m
//  Agate
//
//  Created by zeta on 2014/5/21.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAConstantPatch.h"
#import "STAgateAdditions.h"

@interface STAConstantPatch ()

@property (nonatomic, strong) NSString* uid;

@end

@implementation STAConstantPatch

- (NSString *)uid {
    if (!_uid) {
        _uid = [[STAgateAdditions sharedInstance] generateUID];
    }
    return _uid;
}

- (NSArray *)agateSignals {
    id constant = @{
                    @"type": @"constant",
                    @"uid": self.uid,
                    @"valueType": @"Number",
                    @"value": inputValue.value
                };
    return @[constant];
}

@end
