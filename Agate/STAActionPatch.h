//
//  STAActionPatch.h
//  Agate
//
//  Created by zeta on 2014/5/15.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <SkankySDK/SkankySDK.h>

@interface STAActionPatch : QCProgrammablePatch {
    id _inputList;
    id _outputList;
    id _testDrive;
    id _newMode;
    id _jsContext;
    id _global;
    id _function;
}

@end
