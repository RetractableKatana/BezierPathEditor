//
//  CanvasView.m
//  BezierPathEditor
//
//  Created by James Thompson on 8/31/14.
//  Copyright (c) 2014 IntelligentSprite. All rights reserved.
//

#import "BPECanvasView.h"

@interface BPECanvasView ()

@property NSPoint startPoint;
@property NSPoint currentPoint;

@end

@implementation BPECanvasView

#pragma mark - NSView Overrides

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _startPoint = NSZeroPoint;
        _currentPoint = NSZeroPoint;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        // In select mode, also draw the shape.
        [self drawDrawRect:dirtyRect];
        [self selectionDrawRect:dirtyRect];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawDrawRect:dirtyRect];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    self.startPoint = theEvent.locationInWindow;
    
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionMoseDown:theEvent];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawMouseDown:theEvent];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    self.currentPoint = theEvent.locationInWindow;
    
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionMouseMoved:theEvent];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawMouseMoved:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (self.document.activeToolbarType == BPEDocumentToolbarTypeSelect)
    {
        [self selectionMouseUp:theEvent];
    }
    else if (self.document.activeToolbarType == BPEDocumentToolbarTypeDraw)
    {
        [self drawMouseUp:theEvent];
    }
    
    // This should remain at the bottom of this method to provide the mouseUp methods one last chance to capture the
    // start and currentPoint.
    self.startPoint = self.currentPoint = NSZeroPoint;
}

#pragma mark - Selection Mode Methods

- (void)selectionMoseDown:(NSEvent *)theEvent
{
}

- (void)selectionMouseMoved:(NSEvent *)theEvent
{
    [self setNeedsDisplay:YES];
}

- (void)selectionMouseUp:(NSEvent *)theEvent
{
    [self setNeedsDisplay:YES];
}

- (void)selectionDrawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5] setFill];
    [[NSColor blackColor] setStroke];
    
    NSRect selectionRect = NSMakeRect(self.startPoint.x,
                                      self.startPoint.y,
                                      self.currentPoint.x - self.startPoint.x,
                                      self.currentPoint.y - self.startPoint.y);
    
    NSBezierPath *bp = [NSBezierPath bezierPathWithRect:selectionRect];
    
    [bp stroke];
    [bp fill];
}

#pragma mark - Draw Mode Methods

- (void)drawMouseDown:(NSEvent *)theEvent
{
    NSBezierPath *bp = self.document.bezierPath;
    
    if (bp == nil)
    {
        return;
    }
    
    if (bp.isEmpty)
    {
        // First point.
        [bp moveToPoint:theEvent.locationInWindow];
    }
    else
    {
        [bp curveToPoint:theEvent.locationInWindow
           controlPoint1:bp.currentPoint
           controlPoint2:theEvent.locationInWindow];
    }
    
    [self setNeedsDisplay:YES];
}

- (void)drawMouseMoved:(NSEvent *)theEvent
{
    NSBezierPath *bp = self.document.bezierPath;
    
    if (bp == nil)
    {
        return;
    }
    
    [self findLastCurve:^(NSPointArray points, NSBezierPathElement element, NSInteger curveIndex) {
        
        if (element == NSCurveToBezierPathElement)
        {
            NSPoint cp2 = self.currentPoint;
            
            points[1] = cp2;
            
            [bp setAssociatedPoints:points atIndex:curveIndex];
            
            [self setNeedsDisplay:YES];
        }
    }];
}

- (void)drawMouseUp:(NSEvent *)theEvent
{
    
}

- (void)drawDrawRect:(NSRect)dirtyRect
{
    [self.document.currentStrokeColor setStroke];
    [self.document.currentFillColor setFill];
    
    [self.document.bezierPath stroke];
    [self.document.bezierPath fill];
}

#pragma mark - Utility Methods

- (void)enumerateCurvesUsingBlock:(void (^)(NSPointArray points, NSBezierPathElement element, NSInteger curveIndex, BOOL *stop))block
{
    NSBezierPath *bp = self.document.bezierPath;

    NSInteger lastIndex = [bp elementCount] - 1;
    BOOL stop = NO;
    
    for (NSInteger i = 0; (i < lastIndex && stop == NO); i++)
    {
        // Find last point
        NSPoint lastPoints[3] = {NSZeroPoint, NSZeroPoint, NSZeroPoint};
        
        NSInteger elemIndex = [bp elementCount] - 1;
        
        NSBezierPathElement lastCurve = [bp elementAtIndex:elemIndex
                                          associatedPoints:lastPoints];
        
        block(lastPoints, lastCurve, elemIndex, &stop);
    }
}

- (void)findLastCurve:(void (^)(NSPointArray points, NSBezierPathElement element, NSInteger curveIndex))completion
{
    if (completion == nil)
    {
        return;
    }
    
    NSBezierPath *bp = self.document.bezierPath;
    
    // Find last point
    NSPoint lastPoints[3] = {NSZeroPoint, NSZeroPoint, NSZeroPoint};
    
    NSInteger elemIndex = [bp elementCount] - 1;
    
    NSBezierPathElement lastCurve = [bp elementAtIndex:elemIndex
                                      associatedPoints:lastPoints];

    completion(lastPoints, lastCurve, elemIndex);
}

@end
