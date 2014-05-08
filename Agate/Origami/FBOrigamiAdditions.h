//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//


@class NSMenu, NSMenuItem, QCPatch, QCPort;

@interface FBOrigamiAdditions : NSObject
{
    BOOL _linearPortConnections;
    void *_localizePointer;
    QCPort *_hoveredPort;
    QCPatch *_hoveredPatch;
    NSMenu *_origamiMenu;
    NSMenuItem *_retinaSupportMenuItem;
    NSMenuItem *_linearPortConnectionsMenuItem;
}

+ (id)origamiBundle;
+ (id)sharedAdditions;
+ (void)initialize;
+ (void)toggleLinearPortConnectionsEnabled;
+ (BOOL)isLinearPortConnectionsEnabled;
+ (void)toggleRetinaSupportEnabled;
+ (BOOL)isRetinaSupportEnabled;
@property(retain) NSMenuItem *linearPortConnectionsMenuItem; // @synthesize linearPortConnectionsMenuItem=_linearPortConnectionsMenuItem;
@property(retain) NSMenuItem *retinaSupportMenuItem; // @synthesize retinaSupportMenuItem=_retinaSupportMenuItem;
@property(nonatomic) BOOL linearPortConnections; // @synthesize linearPortConnections=_linearPortConnections;
@property(retain, nonatomic) NSMenu *origamiMenu; // @synthesize origamiMenu=_origamiMenu;
@property(nonatomic) QCPatch *hoveredPatch; // @synthesize hoveredPatch=_hoveredPatch;
@property(nonatomic) QCPort *hoveredPort; // @synthesize hoveredPort=_hoveredPort;
@property void *localizePointer; // @synthesize localizePointer=_localizePointer;
- (id)selectedPatches;
- (id)currentPatch;
- (id)patchView;
- (id)viewerController;
- (id)editorController;
- (struct CGPoint)mousePositionInView:(id)arg1;
- (id)patchUnderCursorInPatchView:(id)arg1;
- (void)insertPatch:(id)arg1 inPatchView:(id)arg2 inputPortKey:(id)arg3 outputPortKey:(id)arg4;
- (void)insertPatch:(id)arg1 inPatchView:(id)arg2;
- (void)transferValueOrConnectionsFromPort:(id)arg1 toPort:(id)arg2;
- (BOOL)functionIsLocalizePortInfo:(void *)arg1;
- (void)applyFunctionOnOutputPorts:(void *)arg1 context:(void *)arg2;
- (void)applyFunctionOnInputPorts:(void *)arg1 context:(void *)arg2;
- (void)setupPortNameDemangling;
- (void)toggleOrigamiPreferenceMenuItem:(id)arg1;
- (void)checkForUpdates:(id)arg1;
- (void)aboutOrigamiAlertDidEnd:(id)arg1 returnCode:(long long)arg2 contextInfo:(void *)arg3;
- (void)aboutOrigami:(id)arg1;
- (void)setupOrigamiMenu;
- (void)qcVersionAlertDidEnd:(id)arg1 returnCode:(long long)arg2 contextInfo:(void *)arg3;
- (void)checkQCVersion;
- (void)additionalSetupForNonEmployees;
- (void)initialSetup;
- (void)mavericksSwizzles;
- (id)_colorForNode:(id)arg1;
- (struct CGColor *)_overlayColorForNode:(id)arg1 view:(id)arg2;
- (void)setupDimDisabledConsumers;
- (void)drawConnection:(id)arg1 fromPoint:(struct CGPoint)arg2 toPoint:(struct CGPoint)arg3;
- (void)setupLinearPortConnections;
- (BOOL)execute:(id)arg1 time:(double)arg2 arguments:(id)arg3;
- (void)convertToLayerGroup:(id)arg1;
- (void)addConvertToLayerGroupMenuItem;
- (id)layerGroupXMLAttributesWithAttributes:(id)arg1;
- (id)layerGroupAttributesWithAttributes:(id)arg1;
- (void)renameToLayerGroup;
- (void)setupRenderInImageHacks;
- (void)_layoutUpdated:(id)arg1;
- (BOOL)control:(id)arg1 textView:(id)arg2 doCommandBySelector:(SEL)arg3;
- (void)setupTextFieldShortcuts;
- (BOOL)_addNode:(id)arg1 atPosition:(struct CGPoint)arg2;
- (void)setupDragAndDrop;
- (void)stopRendering;
- (void)startRendering:(BOOL)arg1;
- (void)setupRetina;
- (void)registerDefaultPreferences;
- (id)pluginsLocatedInSubfolders;
- (_Bool)_shouldLoadPluginFile:(id)arg1 ignoringTopLevelFiles:(_Bool)arg2;
- (void)loadPluginsInSubfolders;
- (id)modeIcons;
- (id)zoomIcons;
- (id)toolbarIcons;
- (void)configureToolbar:(id)arg1;
- (void)setPathBarVisible:(BOOL)arg1;
- (BOOL)pathBarVisible;
- (id)pathBarMenuItemTitle;
- (void)updatePathBarShown;
- (void)togglePathBarShown:(id)arg1;
- (void)addTogglePathBarMenuItem;
- (void)setStatusBarHeight:(double)arg1;
- (double)statusBarHeight;
- (void)setStatusBarHidden:(BOOL)arg1;
- (BOOL)statusBarHidden;
- (void)updateStatusBarShown;
- (id)statusMenuItemTitle;
- (void)toggleStatusBarShown:(id)arg1;
- (void)addToggleStatusBarMenuItem;
- (void)adjustViewerWindow:(id)arg1;
- (void)adjustEditorWindow:(id)arg1;
- (void)adjustWindows;
- (void)didBecomeMain:(id)arg1;
- (void)setupWindowMods;

@end

