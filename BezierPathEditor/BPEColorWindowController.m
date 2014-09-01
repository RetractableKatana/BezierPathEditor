//
//  BPEColorWindowController.m
//  BezierPathEditor
//
//  Created by James Thompson on 9/1/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "BPEColorWindowController.h"

@interface BPEColorWindowController ()

@end

@implementation BPEColorWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self)
    {
        [[NSColorPanel sharedColorPanel] setTarget:self];
        [[NSColorPanel sharedColorPanel] setAction:@selector(colorChanged:)];
        
        [NSColorPanel sharedColorPanel].delegate = self;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.delegate = self;
}

- (void)colorChanged:(NSColorPanel *)sender
{
    [self.delegate didPickColor:sender.color];
}

#pragma NSWindowDelegate Methods

- (void)windowWillClose:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(didCloseColorPicker)])
    {
        [self.delegate didCloseColorPicker];
    }
}

@end
