//
//  QCPort+Addition.m
//  Agate
//
//  Created by zeta on 2014/6/11.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCPort+Addition.h"

@implementation QCPort (Addition)

- (QCPort *)ag_nonProxyOriginalPort {
    if (self.connectedPort) {
        if ([self.connectedPort isKindOfClass:[QCProxyPort class]]) {
            QCProxyPort* lastProxyPort = self.connectedPort;
            while ([lastProxyPort.originalPort isKindOfClass:[QCProxyPort class]]) {
                lastProxyPort = (QCProxyPort*)lastProxyPort.originalPort;
            }
            return (QCPort*)lastProxyPort.originalPort;
        } else {
            return self.connectedPort;
        }
    } else {
        return [self.proxyPort ag_nonProxyOriginalPort];
    }
}

@end
