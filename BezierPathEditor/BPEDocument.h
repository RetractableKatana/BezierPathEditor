//
//  Document.h
//  BezierPathEditor
//
//  Created by James Thompson on 8/30/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BPECanvasView;

typedef NS_ENUM(NSInteger, BPEDocumentToolbarType)
{
    BPEDocumentToolbarTypeNone = -1,
    BPEDocumentToolbarTypeStrokeColor,
    BPEDocumentToolbarTypeFillColor,
    BPEDocumentToolbarTypeDraw,
    BPEDocumentToolbarTypeSelect,
    BPEDocumentToolbarTypeClearAll
};

@interface BPEDocument : NSDocument <NSToolbarDelegate>

@property IBOutlet BPECanvasView *canvas;
@property IBOutlet NSColorWell *strokeWell;
@property IBOutlet NSColorWell *fillWell;

@property NSColor *currentStrokeColor;
@property NSColor *currentFillColor;
@property NSBezierPath *bezierPath;

@property BPEDocumentToolbarType activeToolbarType;

- (IBAction)toolbarItemPressed:(NSToolbarItem *)item;
- (IBAction)colorWellPressed:(NSColorWell *)colorWell;

@end
