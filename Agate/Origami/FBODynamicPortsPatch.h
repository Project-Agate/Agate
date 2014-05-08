//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "QCPatch.h"

@class NSMutableDictionary;

@interface FBODynamicPortsPatch : QCPatch
{
    NSMutableDictionary *_existingPorts;
}

- (void).cxx_destruct;
- (void)setValue:(id)arg1 forPortNamed:(id)arg2;
- (BOOL)removeOutputPortNamed:(id)arg1;
- (BOOL)removeInputPortNamed:(id)arg1;
- (id)addOutputPortNamed:(id)arg1 withValue:(id)arg2 ofType:(Class)arg3;
- (id)addInputPortNamed:(id)arg1 ofType:(Class)arg2;
- (id)initWithIdentifier:(id)arg1;
- (BOOL)_removePort:(unsigned long long)arg1 named:(id)arg2;
- (void)_restoreConnections:(id)arg1 toPort:(id)arg2;
- (id)_connectionsForPortName:(id)arg1;
- (id)_addPort:(unsigned long long)arg1 named:(id)arg2 withValue:(id)arg3 ofType:(Class)arg4;

@end

