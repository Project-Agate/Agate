//
//  STAgateAdditions.m
//  Agate
//
//  Created by zeta on 2014/5/13.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAgateAdditions.h"
#import "FBOrigamiAdditions.h"
#import "NSObject+Addition.h"
#import "STAWidgetPatch.h"

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

- (QCPatch *)currentPatch {
    id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
    return [shared performSelector:@selector(currentPatch)];
}

- (void)addAgateMenu {
    NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"Agate" action:nil keyEquivalent:@""];
    
    NSMenu* subMenu = [[NSMenu alloc] initWithTitle:@"Agate"];
    [subMenu addItemWithTitle:@"Compile" action:@selector(compile:) keyEquivalent:@""];
    [[subMenu itemAtIndex:0] setTarget:self];
    
    [item setSubmenu:subMenu];
    
    [[NSApp mainMenu] insertItem:item atIndex:[[NSApp mainMenu] indexOfItemWithTitle:@"Help"]];
}

- (void)compile: (id) sender {
    QCPatch* cp = [[STAgateAdditions sharedInstance] currentPatch];
    for (QCPatch* patch in cp.nodes) {
        if ([patch isKindOfClass:[STAWidgetPatch class]]) {
            
        } else if ([patch isKindOfClass:NSClassFromString(@"QCJavaScript")]) {
        
        } else {
            //Prompt user that compile cannot proceed
        }
    }
}


@end
