//
//  STAAttributePort.h
//  Agate
//
//  Created by zeta on 2014/5/19.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <SkankySDK/SkankySDK.h>
#import "STASerializableProtocol.h"

@interface STAAttributePort : QCVirtualPort <STASerializableProtocol>

@property (nonatomic, strong) NSString* elementId;
@property (nonatomic, strong) NSString* name;

@end
