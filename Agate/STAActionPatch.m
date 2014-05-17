//
//  STAActionPatch.m
//  Agate
//
//  Created by zeta on 2014/5/15.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAActionPatch.h"

@implementation STAActionPatch


+ (NSArray *)sourceTypes {
    return @[@"script"];
}

-(id)initWithIdentifier:(id)identifier
{
    [[self userInfo] setObject:@"Agate Action" forKey:@"name"];
    object_setClass(self, NSClassFromString(@"QCJavaScript"));
	[self setSource:@"function(__virtual result) main(__number number){\n}" ofType:@"script"];
    self = [self initWithIdentifier:identifier];
	return self;
}


@end
