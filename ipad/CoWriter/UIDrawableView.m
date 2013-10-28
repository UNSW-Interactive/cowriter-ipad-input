//
//  UIDrawableView.m
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class FirstViewController;

#import "UIDrawableView.h"

@implementation UIDrawableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(c, kCGInterpolationHigh);
    float dash[] = {20, 20};
    
    
    CGContextSetLineWidth(c, 2);
    CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
    
    float writableHeight = self.frame.size.height - 2 * OUTSIDE_MARGIN;
    
    CGContextSetLineDash(c, 0, dash, 2);
    CGContextMoveToPoint(c, 0, OUTSIDE_MARGIN + 0 * writableHeight / 3);
    CGContextAddLineToPoint(c, self.frame.size.width, OUTSIDE_MARGIN + 0 * writableHeight / 3);
    CGContextStrokePath(c);
    
    CGContextSetLineDash(c, 0, NULL, 0);
    CGContextMoveToPoint(c, 0, OUTSIDE_MARGIN + 1 * writableHeight / 3);
    CGContextAddLineToPoint(c, self.frame.size.width, OUTSIDE_MARGIN + 1 * writableHeight / 3);
    CGContextStrokePath(c);
    
    CGContextSetLineDash(c, 0, NULL, 0);
    CGContextMoveToPoint(c, 0, OUTSIDE_MARGIN + 2 * writableHeight / 3);
    CGContextAddLineToPoint(c, self.frame.size.width, OUTSIDE_MARGIN + 2 * writableHeight / 3);
    CGContextStrokePath(c);
    
    CGContextSetLineDash(c, 0, dash, 2);
    CGContextMoveToPoint(c, 0, OUTSIDE_MARGIN + 3 * writableHeight / 3);
    CGContextAddLineToPoint(c, self.frame.size.width, OUTSIDE_MARGIN + 3 * writableHeight / 3);
    CGContextStrokePath(c);
    
    CGContextSetLineWidth(c, 4);
    CGContextSetLineDash(c, 0, NULL, 0);
    for (id obj in [Objects List]) {
        UIFreeHandLine *fhl = (UIFreeHandLine*)obj;
        if (fhl.Points.count == 0) continue;
        if ([Objects CurrentFHL].Points.count > 0) {
            TimePoint *local = (TimePoint*)[[Objects CurrentFHL].Points objectAtIndex:0];
            TimePoint *remote = (TimePoint*)[fhl.Points objectAtIndex:0];
            if ([local.I isEqualToString:remote.I]) {// same shape from server
                continue;   
            }
        }
        CGContextSetStrokeColorWithColor(c, ((TimePoint*)[fhl.Points objectAtIndex:0]).C.CGColor);
        CGContextMoveToPoint(c, ((TimePoint*)[fhl.Points objectAtIndex:0]).X.doubleValue, ((TimePoint*)[fhl.Points objectAtIndex:0]).Y.doubleValue);
        for (int i = 1; i < fhl.Points.count; i++) {
            TimePoint *val = (TimePoint*) [fhl.Points objectAtIndex:i];
            CGContextAddLineToPoint(c, val.X.doubleValue, val.Y.doubleValue);
        }
        CGContextStrokePath(c);
    }
    
    // draw current shape (unfinished)
    UIFreeHandLine *fhl = [Objects CurrentFHL];
    if (fhl.Points.count == 0) return;
    CGContextSetStrokeColorWithColor(c, ((TimePoint*)[fhl.Points objectAtIndex:0]).C.CGColor);
    CGContextMoveToPoint(c, ((TimePoint*)[fhl.Points objectAtIndex:0]).X.doubleValue, ((TimePoint*)[fhl.Points objectAtIndex:0]).Y.doubleValue);
    for (int i = 1; i < fhl.Points.count; i++) {
        TimePoint *val = (TimePoint*) [fhl.Points objectAtIndex:i];
        CGContextAddLineToPoint(c, val.X.doubleValue, val.Y.doubleValue);
    }
    CGContextStrokePath(c);
    
}


-(NSMutableArray *)Serialize {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id obj in [Objects List]) {
        UIFreeHandLine *o = (UIFreeHandLine*)obj;
        [arr addObject:[o Serialize]];
    }
    return arr;
}

-(void)Deserialize:(NSMutableArray *)stream WithDelegate:(id)delegate {
    [[Objects List] removeAllObjects];
    for (int i = 0; i < stream.count; i++) {
        NSMutableDictionary* dic = (NSMutableDictionary*) [stream objectAtIndex:i];
        UIFreeHandLine *obj = [[UIFreeHandLine alloc] init];
        [obj Deserialize:dic];
        if (obj.Points.count > 0) {
            if (![obj.ID isEqualToString:[Objects CurrentFHL].ID]) {
                [[Objects List] addObject:obj];
            }
        }
    }
    [self setNeedsDisplay];
}

@end
