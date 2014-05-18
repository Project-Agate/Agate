//
//  WebView+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/18.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "WebView+Addition.h"

@implementation WebView (Addition)

- (JSContext *)ag_jsContext {
    JSGlobalContextRef ref = [[self mainFrame] globalContext];
    return [JSContext contextWithJSGlobalContextRef:ref];
}

@end
