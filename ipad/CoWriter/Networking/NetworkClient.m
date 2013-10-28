//
//  NetworkConnection.m
//  Groundit
//
//  Created by CRAFT on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient
@synthesize delegate;

-(id)init {
    self = [super init];
    if (self) {
        noreq = [[NetworkObject alloc] init];
        noreq.ExchangeObjects = [[NSMutableArray alloc] init];
        norsp = [[NetworkObject alloc] init];
        norsp.ExchangeObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)InitWithDelegate:(id<NetworkClientDelegate>)theDelegate {
    NetworkClient *nc = [[NetworkClient alloc] init];
    [nc setDelegate:theDelegate];
    return nc;
}

-(void)ConnectWithNetworkCode:(int)networkCode {
    [noreq setNetworkCode:[NSNumber numberWithInt:networkCode]];
    [self connect];
}

-(void)ConnectWithNetworkCode:(int)networkCode AndExchangeObjects:(NSMutableArray *)exchangeObjects {
    
    [noreq setNetworkCode:[NSNumber numberWithInt:networkCode]];
    [noreq setExchangeObjects:exchangeObjects];
    [self connect];
}

-(void)ConnectWithNetworkCode:(int)networkCode AndExchangeObject:(id)exchangeObject {
    [noreq setNetworkCode:[NSNumber numberWithInt:networkCode]];
    [noreq.ExchangeObjects addObject:exchangeObject];
    [self connect];
}

-(void)ConnectWithNetworkObject:(NetworkObject *)networkObject {
    noreq = networkObject;
    [self connect];
}

-(void)connect {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/", @"192.168.11.151", 40123]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/", @"128.178.13.187", 40123]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:100];
    [request setHTTPBody:[noreq Serialization]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data != nil) {
            [norsp Deserialize:data];
            if ([delegate respondsToSelector:@selector(NetworkConnection:EndedWithSuccess:)]) {
                [delegate NetworkConnection:self EndedWithSuccess:norsp];
            }
         }
        else {
            if (error != nil) {
                if ([delegate respondsToSelector:@selector(NetworkConnection:endedWithError:)]) {
                    [delegate NetworkConnection:self EndedWithError:error];
                }
            }
        }
    }];    
}

@end


