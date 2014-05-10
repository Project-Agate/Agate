//
//  STAWidgetPatch.m
//  Agate
//
//  Created by zeta on 2014/5/6.
//  Copyright (c) 2014年 shotdoor. All rights reserved.
//

#import "STAWidgetPatch.h"
#import "Origami/FBOrigamiAdditions.h"


@implementation STAWidgetPatch

+(BOOL)isSafe
{
	return NO;
}

+(BOOL)allowsSubpatchesWithIdentifier:(id)identifier
{
	return NO;
}

+(int)executionModeWithIdentifier:(id)identifier
{
	return 0;
}

+(int)timeModeWithIdentifier:(id)identifier
{
	return 0;
}

-(id)initWithIdentifier:(id)identifier
{
	if(self = [super initWithIdentifier:identifier])
	{
		[[self userInfo] setObject:@"Agate Widget" forKey:@"name"];
	}
	return self;
}

-(BOOL)setup:(QCOpenGLContext*)context
{
	return YES;
}

-(void)cleanup:(QCOpenGLContext*)context
{
}

-(void)enable:(QCOpenGLContext*)context
{
}

-(void)disable:(QCOpenGLContext*)context
{
}

-(BOOL)execute:(QCOpenGLContext*)context time:(double)time arguments:(NSDictionary*)arguments
{
    if (self.webView) {
        [self.webView becomeFirstResponder];
    }
	return YES;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
}


- (void)stateUpdated {
    if (!self.userInfo[@".old-position"] && self.userInfo[@"position"]) {
        // newly added
        id shared = [NSClassFromString(@"FBOrigamiAdditions") performSelector:@selector(sharedAdditions)];
        QCPatchView* view = [shared performSelector:@selector(patchView)];
        
        NSPoint point;
        [self.userInfo[@"position"] getValue:&point];
        
        NSLog(@"%.f %.f", point.x, point.y);
        //NSTextField* field = [[NSTextField alloc] initWithFrame:NSMakeRect(size.x, size.y, 100, 20)];
        //[gv addSubview:field];

    } else if (self.userInfo[@"position"]) {
        if (self.webView) {
            //NSPoint point;
            //[self.userInfo[@"position"] getValue:&point];
            //self.webView.frame = NSMakeRect(point.x, point.y, 100, 100);
        }
    }
    //NSLog(@"userinfo: %@", self.userInfo);
}



@end
