//
//  BPEColorWindowController.h
//  BezierPathEditor
//
//  Created by James Thompson on 9/1/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BPEColorWindowControllerDelegate <NSObject>

- (void)didPickColor:(NSColor *)color;

@optional

- (void)didCloseColorPicker;

@end

@interface BPEColorWindowController : NSWindowController <NSWindowDelegate>

@property (weak) id<BPEColorWindowControllerDelegate>delegate;

@end
