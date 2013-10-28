//
//  UIObject.h
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define CIRCLE_NEW_POINT_DIST 2 //distance in pixels for discretization
#define CIRCLE_MAX_DIST 100 //distance to detect other pixels

#define POINT_X @"X"
#define POINT_Y @"Y"
#define POINT_T @"T" //TimeStamp
#define POINT_C @"C" //Color
#define POINT_I @"I" //ID

#import "TimePoint.h"
#import "Utilities.h"
#import "Objects.h"

@interface UIFreeHandLine : NSObject ;

@property (strong, nonatomic) NSMutableArray* Points;
@property (strong, nonatomic) NSString *ID;

-(void)AddPoint:(CGPoint)p;
-(BOOL)CanAdd:(CGPoint)p;
-(void)clear;
-(CGPoint)LastPoint;

-(void)Deserialize:(NSMutableDictionary*)dictionary;
-(NSMutableDictionary*)Serialize;

+(int) intFromColor:(UIColor*)color;
+(UIColor*) colorFromInt:(int)color;
@end
