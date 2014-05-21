//
//  STAConstantPatch.h
//  Agate
//
//  Created by zeta on 2014/5/21.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <SkankySDK/SkankySDK.h>
#import "STASerializableProtocol.h"

@interface STAConstantPatch : QCPatch <STASerializableProtocol> {
    QCNumberPort* inputValue;
    QCNumberPort* outputValue;
}

@end
