//
//  CanvasView.h
//  BezierPathEditor
//
//  Created by James Thompson on 8/31/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BPEDocument.h"

@interface BPECanvasView : NSView

@property (weak) IBOutlet BPEDocument *document;

@end
