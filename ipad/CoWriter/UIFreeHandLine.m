//
//  UIObject.m
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIFreeHandLine.h"

@implementation UIFreeHandLine


-(id)init {
    self = [super init];
    if (self) {
        _Points = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)AddPoint:(CGPoint)p {
    TimePoint *tp = [[TimePoint alloc] init];
    tp.X = [NSNumber numberWithDouble:p.x];
    tp.Y = [NSNumber numberWithDouble:p.y];
    tp.C = [Objects Color];
    tp.T = [Utilities StringFromDate:[NSDate date]];
    tp.I = _ID;
    [_Points addObject:tp];
}

-(CGPoint)LastPoint {
    TimePoint *tp = (TimePoint*) _Points.lastObject;
    return CGPointMake(tp.X.floatValue, tp.Y.floatValue);
}

-(BOOL)CanAdd:(CGPoint)p {
    BOOL canAdd = NO;
    if (_Points.count == 0) {
        canAdd = YES;
    }
    else {
        TimePoint *last = (TimePoint*)[_Points lastObject];
        float dist = sqrtf(pow(last.X.doubleValue - p.x, 2) + pow(last.Y.doubleValue - p.y, 2));
        canAdd = dist > CIRCLE_NEW_POINT_DIST && dist < CIRCLE_MAX_DIST;
    }
    return canAdd;
}

-(void)clear {
    _ID = @"";
    [_Points removeAllObjects];
}

-(NSMutableArray *)Serialize {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (TimePoint *val in _Points) {
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        [d setValue:val.X forKey:POINT_X];
        [d setValue:val.Y forKey:POINT_Y];
        [d setValue:val.T forKey:POINT_T];
        [d setValue:[NSNumber numberWithInt:[UIFreeHandLine intFromColor:val.C]] forKey:POINT_C];
        [d setValue:val.I forKey:POINT_I];
        [arr addObject:d];
    }
    return arr;
}

-(void)Deserialize:(NSMutableArray *)arr {
    for (NSDictionary *d in arr) {
        TimePoint *tp = [[TimePoint alloc] init];
        tp.X = [d objectForKey:POINT_X];
        tp.Y = [d objectForKey:POINT_Y];
        tp.C = [UIFreeHandLine colorFromInt:((NSNumber*)[d objectForKey:POINT_C]).intValue];
        tp.T = [d objectForKey:POINT_T];
        tp.I = [d objectForKey:POINT_I];
        _ID = tp.I;
        [_Points addObject:tp];
    }
}

+(int) intFromColor:(UIColor*)color
{
    int numComponents = CGColorGetNumberOfComponents([color CGColor]);
    
    int red = 0,green = 0,blue = 0,alpha = 0;
    
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents([color CGColor]);
        red   = components[0]*255;
        green = components[1]*255;
        blue  = components[2]*255;
        alpha = components[3]*255;
    }
    if (numComponents == 2) {
        const CGFloat *components = CGColorGetComponents([color CGColor]);
        red = components[0]*255;
        green = components[0]*255;
        blue = components[0]*255;
        alpha = components[1]*255;
    }
    
    int hexColor = (alpha<<24 & 0xFF000000) + (red<<16 & 0x00FF0000) + (green<<8 & 0x0000FF00) + (blue & 0x000000FF);
    return hexColor;
}

+(UIColor*) colorFromInt:(int)color {
    return [UIColor colorWithRed:(color >> 16 & 0xFF) / 255.0 green:(color >> 8 & 0xFF) / 255.0 blue:(color & 0xFF) / 255.0 alpha:(color >> 24 & 0xFF) / 255.0];
}

@end
