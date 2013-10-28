//
//  Utilities.m
//  PadInput
//
//  Created by CRAFT on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(int) signOf:(int) n { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }

+(CGFloat)distanceFrom:(CGPoint)p1 to:(CGPoint)p2 {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

+(NSString *)MD5:(NSString *)text {
    const char *cStr = [text UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

+(NSString *)SHA1:(NSString *)text {
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+(NSString *)GenerateRandomID {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0; i < 8; i++) {
        [str appendFormat:@"%02d", arc4random()];
    }
    return [Utilities MD5:str];
}

+(NSString *)StringFromDate:(NSDate *)date {
    NSDateFormatter *nsf = [[NSDateFormatter alloc] init];
    [nsf setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [nsf stringFromDate:date];
}

+(NSString *)StringFromDateDashed:(NSDate *)date {
    NSDateFormatter *nsf = [[NSDateFormatter alloc] init];
    [nsf setDateFormat:@"yyyy-MM-dd-HH-mm"];
    return [nsf stringFromDate:date];
}

+(NSDate*)DateFromString:(NSString*)string {
    NSDateFormatter *nsf = [[NSDateFormatter alloc] init];
    [nsf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [nsf dateFromString:string];
}

+(NSString *)StringFromDateWithoutSeconds:(NSDate *)date {
    NSDateFormatter *nsf = [[NSDateFormatter alloc] init];
    [nsf setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [nsf stringFromDate:date];
}

+(NSString*)StringFromTime:(NSDate *)time {
    NSDateFormatter *nsf = [[NSDateFormatter alloc] init];
    [nsf setDateFormat:@"HH:mm"];
    return [nsf stringFromDate:time];
}

+(NSString *)StringFromDuration:(double)dur {
    int duration = (int)round(dur);
    if (duration / 60 == 0) {
        return [NSString stringWithFormat:@"%dm", duration];
    }
    else if (duration % 60 == 0) {
        return [NSString stringWithFormat:@"%dh", duration / 60];
    }
    else {
        return [NSString stringWithFormat:@"%dh %dm", duration / 60, duration % 60];
    }
}

@end
