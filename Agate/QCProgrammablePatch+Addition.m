//
//  QCProgrammablePatch+Addition.m
//  Agate
//
//  Created by zeta on 2014/5/19.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "QCProgrammablePatch+Addition.h"
#import "STAgateAdditions.h"
#import "STAWidgetPatch.h"
#import "STAConstantPatch.h"
#import "QCPort+Addition.h"

@implementation QCProgrammablePatch (Addition)

static char kAssociatedObjectKey;

+ (void)load {
    
}

-(id)ag_initWithIdentifier:(id)identifier
{
    [[self userInfo] setObject:@"Agate Action" forKey:@"name"];
	
    self = [self ag_initWithIdentifier:identifier];
	[self setSource:@"function(__virtual result) main(__number number){\n}" ofType:@"script"];
    return self;
}

#pragma mark - STASerializableProtocol

- (NSString *)uid {
    if (!objc_getAssociatedObject(self, &kAssociatedObjectKey)) {
        objc_setAssociatedObject(self, &kAssociatedObjectKey, [[STAgateAdditions sharedInstance] generateUID], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

- (NSArray *)agateSignals {
    NSMutableArray* signals = [NSMutableArray array];
    
    // Generating parameters
    NSMutableArray* parameters = [NSMutableArray array];
    for (QCPort* port in self.inputPorts) {
        QCPort* originalPort = [port ag_nonProxyOriginalPort];
        
        if (originalPort) {
            if ([[originalPort node] isKindOfClass:[QCProgrammablePatch class]] || [[originalPort node] isKindOfClass:[STAConstantPatch class]]) {
                id param = @{@"name": [port key], @"valueRef": [(id<STASerializableProtocol>)[originalPort node] uid]};
                [parameters addObject:param];
            } else if ([[originalPort node] isKindOfClass:[STAWidgetPatch class]]) {
                if ([originalPort conformsToProtocol:@protocol(STASerializableProtocol)]) {
                    id param = @{@"name": [port key], @"valueRef": [(id<STASerializableProtocol>) originalPort uid]};
                    [parameters addObject:param];
                } else {
                    abort();
                }
            }
        } else {
            NSString* constant_uid = [[STAgateAdditions sharedInstance] generateUID];
            if ([port isKindOfClass:[QCNumberPort class]]) {
                id constant = @{
                                @"type": @"constant",
                                @"uid": constant_uid,
                                @"valueType": @"Number",
                                @"value": [port value]
                            };
                [signals addObject:constant];
            } else if ([port isKindOfClass:[QCStringPort class]]) {
                id signal = @{
                                @"type": @"constant",
                                @"uid": constant_uid,
                                @"valueType": @"String",
                                @"value": [port value]
                            };
                [signals addObject:signal];
            }
            
            id param = @{@"name": [port key], @"valueRef": constant_uid};
            [parameters addObject:param];
        }
    }

    NSDictionary* action = @{
                             @"type": @"action",
                             @"uid": [self uid],
                             @"name": self.userInfo[@"name"] ? self.userInfo[@"name"] : @"Action",
                             @"parameters": parameters,
                             @"body": [self scriptBody],
                           };
    
    [signals addObject:action];
    return signals;
}

#pragma mark - Private Methods

- (NSString*) scriptBody {
    NSString* script = [self sourceOfType:@"script"];
    NSInteger leftBracket = -1;
    NSInteger rightBracket = -1;
    
    for (NSInteger i = 0; i < script.length; i++) {
        if ([script characterAtIndex:i] == [@"{" characterAtIndex:0]) {
            leftBracket = i;
            break;
        }
    }
    
    for (NSInteger i = script.length - 1; i >=0; i--) {
        if ([script characterAtIndex:i] == [@"}" characterAtIndex:0]) {
            rightBracket = i;
            break;
        }
    }
    return [script substringWithRange:NSMakeRange(leftBracket + 1, rightBracket - leftBracket - 1)];
}

@end
