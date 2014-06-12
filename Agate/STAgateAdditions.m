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
#import "STAgatePrincipal.h"
#import "QCProgrammablePatch+Addition.h"
#import "QCPatch+Addition.h"
#import <AFNetworking/AFNetworking.h>

NSString* const kAgateServerEndpoint = @"http://localhost:3000";

@interface STAgateAdditions ()

@property (nonatomic, strong) NSMutableSet* generatedUIDs;

@end

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

- (id)init {
    self = [super init];
    if (self) {
        self.generatedUIDs = [NSMutableSet set];
    }
    return self;
}

- (QCPatch *)currentPatch {
    id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
    return [shared performSelector:@selector(currentPatch)];
}

- (NSURL *)bundleURL {
    return [[NSBundle bundleForClass:[STAgatePrincipal class]] resourceURL];
}

- (NSString *)generateUID {
    NSString* candidate = [self randomStringWithLength:16];
    while ([self.generatedUIDs containsObject:candidate]) {
        candidate = [self randomStringWithLength:16];
    }
    [self.generatedUIDs addObject:candidate];
    
    return candidate;
}

-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (void)addAgateMenu {
    NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:@"Agate" action:nil keyEquivalent:@""];
    
    NSMenu* subMenu = [[NSMenu alloc] initWithTitle:@"Agate"];
    [subMenu addItemWithTitle:@"Compile" action:@selector(compile:) keyEquivalent:@""];
    [[subMenu itemAtIndex:0] setTarget:self];
    
    [item setSubmenu:subMenu];
    
    [[NSApp mainMenu] insertItem:item atIndex:[[NSApp mainMenu] indexOfItemWithTitle:@"Help"]];
}

- (NSDictionary*) subProgramByCompilingMacroPatch: (QCPatch*) macroPatch {
    NSAssert([macroPatch isMacroPatch], @"Patch should be a macro patch");
    
    NSMutableDictionary* program = [NSMutableDictionary dictionary];
    program[@"widgets"] = [NSMutableDictionary dictionary];
    program[@"signals"] = [NSMutableDictionary dictionary];
    
    for (QCPatch* patch in macroPatch.nodes) {
        if (patch.isMacroPatch) {
            NSDictionary* subProgram = [self subProgramByCompilingMacroPatch:patch];
            [program[@"widgets"] addEntriesFromDictionary:subProgram[@"widgets"]];
            [program[@"signals"] addEntriesFromDictionary:subProgram[@"signals"]];
        } else {
            NSArray* signals = [(id<STASerializableProtocol>)patch agateSignals];
            for (id sig in signals) {
                program[@"signals"][sig[@"uid"]] = sig;
            }
            
            if ([patch isKindOfClass:[STAWidgetPatch class]]) {
                id widget = [(STAWidgetPatch*)patch widgetDictionary];
                program[@"widgets"][widget[@"uid"]] = widget;
            }
        }
    }
    return program;
}

- (void)compile: (id) sender {
    QCPatch* cp = [[STAgateAdditions sharedInstance] currentPatch];
    
    while (cp.parentPatch != nil) {
        cp = cp.parentPatch;
    }
    
    NSDictionary* program = [self subProgramByCompilingMacroPatch:cp];

    [self postToServer:program];
}

- (void)postToServer:(id) program {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = program;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[kAgateServerEndpoint stringByAppendingPathComponent:@"compile"] parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData* responseObject) {
        NSString* path = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [[NSWorkspace sharedWorkspace] openURL:[[NSURL URLWithString:kAgateServerEndpoint] URLByAppendingPathComponent:path]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setInformativeText:[error localizedDescription]];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        [alert release];
        
        NSLog(@"Error: %@", error);
    }];
}


@end
