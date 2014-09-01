//
//  Document.m
//  BezierPathEditor
//
//  Created by James Thompson on 8/30/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "BPEDocument.h"

#import "BPECanvasView.h"

@interface BPEDocument ()

@end

@implementation BPEDocument

#pragma mark - NSDocument Overrides

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.bezierPath = [NSBezierPath bezierPath];
        self.currentFillColor = [NSColor clearColor];
        self.currentStrokeColor = [NSColor blackColor];
        self.activeToolbarType = BPEDocumentToolbarTypeDraw;
    }
    
    return self;
}

- (NSString *)windowNibName
{
    return @"BPEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    self.colorController = [[BPEColorWindowController alloc] initWithWindow:[NSColorPanel sharedColorPanel]];
    self.colorController.delegate = self;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if (self.bezierPath == nil)
    {
        return nil;
    }
    
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:self.bezierPath];
    
    return archive;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.bezierPath = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)toolbarItemPressed:(NSToolbarItem *)item
{
    switch (item.tag)
    {
        case BPEDocumentToolbarTypeStrokeColor:
            break;
            
        case BPEDocumentToolbarTypeFillColor:
            break;
            
        case BPEDocumentToolbarTypeDraw:
            self.activeToolbarType = item.tag;
            break;
            
        case BPEDocumentToolbarTypeSelect:
            self.activeToolbarType = item.tag;
            break;

        case BPEDocumentToolbarTypeClearAll:
            self.bezierPath = [NSBezierPath bezierPath];
            [self.canvas setNeedsDisplay:YES];
            break;
            
        default:
            NSLog(@"Unknown toolbar type: %ld", item.tag);
            break;
    }
}

- (IBAction)colorWellPressed:(NSColorWell *)colorWell
{
    if (colorWell.tag == BPEDocumentToolbarTypeStrokeColor)
    {
        self.currentStrokeColor = [[NSColorPanel sharedColorPanel] color];
        [self.canvas setNeedsDisplay:YES];
    }
    else if (colorWell.tag == BPEDocumentToolbarTypeFillColor)
    {
        self.currentFillColor = [[NSColorPanel sharedColorPanel] color];
        [self.canvas setNeedsDisplay:YES];
    }
}

#pragma mark - BPEColorWindowControllerDelegate Methods

- (void)didPickColor:(NSColor *)color
{
    switch (self.activeToolbarType)
    {
        case BPEDocumentToolbarTypeStrokeColor:
            break;
        
        case BPEDocumentToolbarTypeFillColor:
            break;
            
        default:
            break;
    }
}

@end
