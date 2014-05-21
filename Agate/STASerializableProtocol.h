//
//  STASerializableProtocol.h
//  Agate
//
//  Created by zeta on 2014/5/15.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STASerializableProtocol <NSObject>

@optional

- (NSString*) uid;
- (NSArray*) agateSignals;

@end
