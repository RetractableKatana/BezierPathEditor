//
//  Document.m
//  BezierPathEditor
//
//  Created by James Thompson on 8/30/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "BPEDocument.h"

#import "BPECanvasView.h"

static NSString * const BPEDocumentCoderKeyBezierPath = @"bezierPath";
static NSString * const BPEDocumentCoderKeyCurrentFillColor = @"currentFillColor";
static NSString * const BPEDocumentCoderKeyCurrentStrokeColor = @"currentStrokeColor";

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
    
    self.strokeWell.color = self.currentStrokeColor;
    self.fillWell.color = self.currentFillColor;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if (self.bezierPath == nil)
    {
        return nil;
    }
    
    NSMutableData *outBytes = [NSMutableData new];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:outBytes];
    
    if (self.currentStrokeColor)
    {
        [archiver encodeObject:self.currentStrokeColor forKey:BPEDocumentCoderKeyCurrentStrokeColor];
    }
    
    if (self.currentFillColor)
    {
        [archiver encodeObject:self.currentFillColor forKey:BPEDocumentCoderKeyCurrentFillColor];
    }
    
    if (self.bezierPath)
    {
        [archiver encodeObject:self.bezierPath forKey:BPEDocumentCoderKeyBezierPath];
    }
    
    [archiver finishEncoding];
    
    return outBytes;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    self.bezierPath = [decoder decodeObjectForKey:BPEDocumentCoderKeyBezierPath];
    self.currentStrokeColor = [decoder decodeObjectForKey:BPEDocumentCoderKeyCurrentStrokeColor];
    self.currentFillColor = [decoder decodeObjectForKey:BPEDocumentCoderKeyCurrentFillColor];
    
    [decoder finishDecoding];
    
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

@end
