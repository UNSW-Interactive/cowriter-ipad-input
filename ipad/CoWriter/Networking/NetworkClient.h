//
//  NetworkConnection.h
//  Groundit
//
//  Created by CRAFT on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkObject.h"

@protocol NetworkClientDelegate;

@interface NetworkClient : NSObject {
    NetworkObject *noreq;
    NetworkObject *norsp;
}

// A delegate is a callback with some info, but the callback destination needs to be set beforehand!!!
@property (weak, nonatomic) id<NetworkClientDelegate>delegate;

-(id)InitWithDelegate:(id<NetworkClientDelegate>)theDelegate;
-(void)ConnectWithNetworkCode:(int)networkCode;
-(void)ConnectWithNetworkCode:(int)networkCode AndExchangeObject:(id)exchangeObject;
-(void)ConnectWithNetworkCode:(int)networkCode AndExchangeObjects:(NSMutableArray*)exchangeObjects;
-(void)ConnectWithNetworkObject:(NetworkObject*)networkObject;

@end

@protocol NetworkClientDelegate <NSObject>

@optional
-(void)NetworkConnection:(NetworkClient*)connection EndedWithSuccess:(NetworkObject*)norsp;
-(void)NetworkConnection:(NetworkClient*)connection EndedWithError:(NSError*)error;

@end