//
//  STAgateAdditions.m
//  Agate
//
//  Created by zeta on 2014/5/13.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAgateAdditions.h"
#import "FBOrigamiAdditions.h"

@implementation STAgateAdditions

+ (instancetype)sharedInstance {
    static STAgateAdditions *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (QCPatchView *)patchView {
    id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
    QCPatchView* view = [shared performSelector:@selector(patchView)];
    return view;
}

- (void)addAgateMenu {
    NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"Agate" action:nil keyEquivalent:@""];
    
    NSMenu* subMenu = [[NSMenu alloc] initWithTitle:@"Agate"];
    [subMenu addItemWithTitle:@"Compile" action:@selector(compile:) keyEquivalent:@""];
    
    [item setSubmenu:subMenu];
    
    [[NSApp mainMenu] insertItem:item atIndex:[[NSApp mainMenu] indexOfItemWithTitle:@"Help"]];
}

- (void)compile: (id) sender {
    
}


@end
