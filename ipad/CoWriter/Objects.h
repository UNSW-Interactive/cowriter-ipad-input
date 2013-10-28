//
//  Objects.h
//  PadInput
//
//  Created by Flaviu on 2012/09/03.
//
//
@class UIFreeHandLine;

#define STATE_INPUT 0
#define STATE_INPUT_WAITING 1
#define STATE_VERIFY 2

#import <Foundation/Foundation.h>
#import "UIDrawableView.h"

@interface Objects : NSObject

@property (strong, nonatomic) NSMutableArray *Objects;
@property (strong, nonatomic) UIFreeHandLine *CurrentFHL;


@property (strong, nonatomic) UIColor *Color;
@property (nonatomic) BOOL GridON;
@property (nonatomic) int State;

+(NSString*)DeviceID;
+(NSString*)DeviceName;
+(NSMutableArray*)List;
+(UIColor*)Color;
+(void)SetColor:(UIColor*)color;
+(BOOL)GridON;
+(void)SetGrid:(BOOL)gridON;
+(int)State;
+(void)SetState:(int)state;

+(void)AddObject:(UIFreeHandLine*)obj;
+(UIFreeHandLine*)CurrentFHL;
+(void)setCurrentFHL:(UIFreeHandLine*)fhl;

@end
