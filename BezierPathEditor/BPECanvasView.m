//
//  CanvasView.m
//  BezierPathEditor
//
//  Created by James Thompson on 8/31/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "BPECanvasView.h"


@interface BPECanvasView ()

@property NSPoint lastPoint;
@property NSRect selectionRect;

@end

@implementation BPECanvasView

#pragma mark - NSView Overrides

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _lastPoint = NSZeroPoint;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionDrawRect:dirtyRect];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawDrawRect:dirtyRect];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionMoseDown:theEvent];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawMouseDown:theEvent];
    }

}

- (void)mouseMoved:(NSEvent *)theEvent
{
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionMouseMoved:theEvent];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawMouseMoved:theEvent];
    }
}

#pragma mark - Selection Mode Methods

- (void)selectionMoseDown:(NSEvent *)theEvent
{
    
}

- (void)selectionMouseMoved:(NSEvent *)theEvent
{
    
}

- (void)selectionDrawRect:(NSRect)dirtyRect
{
    [NSBezierPath bezierPathWithRect:self.selectionRect];
}

#pragma mark - Draw Mode Methods

- (void)drawMouseDown:(NSEvent *)theEvent
{
    NSBezierPath *bp = self.document.bezierPath;
    
    if (bp == nil)
    {
        return;
    }
    
    self.lastPoint = theEvent.locationInWindow;
    
    if (bp.isEmpty)
    {
        [bp moveToPoint:theEvent.locationInWindow];
    }
    else
    {
        [bp lineToPoint:theEvent.locationInWindow];
    }
    
    [self setNeedsDisplay:YES];
}

- (void)drawMouseMoved:(NSEvent *)theEvent
{
    
}

- (void)drawDrawRect:(NSRect)dirtyRect
{
    [self.document.currentStrokeColor setStroke];
    [self.document.currentFillColor setFill];
    
    [self.document.bezierPath stroke];
    [self.document.bezierPath fill];
}

@end
