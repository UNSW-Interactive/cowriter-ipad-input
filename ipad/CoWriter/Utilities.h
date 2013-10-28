//
//  Utilities.h
//  PadInput
//
//  Created by CRAFT on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utilities : NSObject
+(int)signOf:(int)n;
+(CGFloat)distanceFrom:(CGPoint)p1 to:(CGPoint)p2;
+(NSString*)MD5:(NSString*)text;
+(NSString*)SHA1:(NSString*)text;
+(NSString*)GenerateRandomID;

+(NSString*)StringFromDate:(NSDate*)date;
+(NSString*)StringFromDateDashed:(NSDate*)date;
+(NSString*)StringFromDateWithoutSeconds:(NSDate *)date;
+(NSString*)StringFromDuration:(double)dur;
+(NSString*)StringFromTime:(NSDate*)time;
+(NSDate*)DateFromString:(NSString*)string;
@end
