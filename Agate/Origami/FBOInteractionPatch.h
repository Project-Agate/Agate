//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "QCPatch.h"

#import "QCInteractionPatch.h"

@class FBOInteractionController, NSEvent, NSMutableDictionary, QCBooleanPort, QCInteractionPort;

@interface FBOInteractionPatch : QCPatch <QCInteractionPatch>
{
    QCBooleanPort *inputEnableInteraction;
    QCInteractionPort *outputInteraction;
    QCBooleanPort *outputDown;
    QCBooleanPort *outputUp;
    QCBooleanPort *outputTap;
    QCBooleanPort *outputDrag;
    QCPatch *_cachedRenderingPatch;
    QCPatch *_sprite;
    QCPatch *_iterator;
    FBOInteractionController *_controller;
    NSEvent *_currentEvent;
    NSMutableDictionary *_outputDowns;
    NSMutableDictionary *_outputUps;
    NSMutableDictionary *_outputTaps;
    NSMutableDictionary *_outputDrags;
    NSMutableDictionary *_touchDowns;
}

+ (int)timeModeWithIdentifier:(id)arg1;
+ (int)executionModeWithIdentifier:(id)arg1;
+ (BOOL)allowsSubpatchesWithIdentifier:(id)arg1;
@property(retain, nonatomic) NSMutableDictionary *touchDowns; // @synthesize touchDowns=_touchDowns;
@property(retain, nonatomic) NSMutableDictionary *outputDrags; // @synthesize outputDrags=_outputDrags;
@property(retain, nonatomic) NSMutableDictionary *outputTaps; // @synthesize outputTaps=_outputTaps;
@property(retain, nonatomic) NSMutableDictionary *outputUps; // @synthesize outputUps=_outputUps;
@property(retain, nonatomic) NSMutableDictionary *outputDowns; // @synthesize outputDowns=_outputDowns;
@property(retain, nonatomic) NSEvent *currentEvent; // @synthesize currentEvent=_currentEvent;
@property(nonatomic) __weak FBOInteractionController *controller; // @synthesize controller=_controller;
- (void).cxx_destruct;
- (void)setRenderingPatch:(id)arg1 iteration:(unsigned long long)arg2;
- (BOOL)interactionEnabled;
- (struct CGPoint)scalePointForRetina:(struct CGPoint)arg1 inQCView:(id)arg2;
- (struct CGPoint)pointForEvent:(id)arg1;
- (BOOL)execute:(id)arg1 time:(double)arg2 arguments:(id)arg3;
- (BOOL)setup:(id)arg1;
- (id)initWithIdentifier:(id)arg1;

@end

