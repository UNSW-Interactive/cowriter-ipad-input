//
//  NetworkObject.m
//  Groundit
//
//  Created by CRAFT on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkObject.h"

@implementation NetworkObject

@synthesize NetworkCode;
@synthesize ExchangeObjects;

-(id)init {
    self = [super init];
    if (self) {
        ExchangeObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSData*)Serialization {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:NetworkCode forKey:NETWORK_CODE];
    [dic setObject:ExchangeObjects forKey:EXCHANGE_OBJECTS];
    return [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
}

-(void)Deserialize:(NSData *)data {
    NSMutableDictionary* RecordData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [self setNetworkCode:[RecordData objectForKey:NETWORK_CODE]];
    [self setExchangeObjects:[RecordData objectForKey:EXCHANGE_OBJECTS]];
}

@end
