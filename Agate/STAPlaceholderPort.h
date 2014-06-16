//
//  STAPlaceholderPort.h
//  Agate
//
//  Created by zeta on 2014/6/16.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <SkankySDK/SkankySDK.h>
#import "STASerializableProtocol.h"

@interface STAPlaceholderPort : QCVirtualPort <STASerializableProtocol>

@property (nonatomic, strong) NSString* elementId;

@end
