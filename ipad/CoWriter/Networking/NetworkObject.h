//
//  NetworkObject.h
//  Groundit
//
//  Created by CRAFT on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define NETWORK_CODE @"NetworkCode"
#define EXCHANGE_OBJECTS @"ExchangeObjects"



#define REQUEST_STATE 100

#define SEND_SHAPE 101

#define CLEAR_MY_SHAPES 102


#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

// The network code
@property (strong, nonatomic) NSNumber* NetworkCode;

// The array of exchange objects
@property (strong, nonatomic) NSMutableArray *ExchangeObjects;

-(NSData*)Serialization;
-(void)Deserialize:(NSData*)data;


@end
