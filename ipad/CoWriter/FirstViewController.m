
//
//  FirstViewController.m
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize dvView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    ShouldUpdate = YES;
    
    [dvView setDelegate:self];
    dvView.multipleTouchEnabled = YES;
    syncTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(SynchronizeWithServer) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [self setDvView:nil];
    [self setBtClear:nil];
    [self setBtColor:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    ShouldUpdate = NO;
    UITouch *touch = nil;
    BOOL found = NO;
    NSArray *allTouches = [touches allObjects];
    for (UITouch *ut in allTouches) {
        if (ut.view == dvView) {
            CGPoint p = [ut locationInView:dvView];
            if (p.x < dvView.frame.size.width - LOWER_CORNER_X_OFFSET || p.y < dvView.frame.size.height - LOWER_CORNER_Y_OFFSET) {
                touch = ut;
                found = YES;
                break;
            }
        }
    }
    if (touch == nil || found == NO) return;
    UIFreeHandLine *fhl = [[UIFreeHandLine alloc] init];
    fhl.ID = [Utilities GenerateRandomID];
    [Objects setCurrentFHL:fhl];
    [dvView setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = nil;
    NSArray *allTouches = [touches allObjects];
    BOOL accepted = NO;
    for (UITouch *ut in allTouches) {
        if (ut.view == dvView) {
            CGPoint p = [ut locationInView:dvView];
            if (allTouches.count <= 1 || p.x < dvView.frame.size.width - LOWER_CORNER_X_OFFSET || p.y < dvView.frame.size.height - LOWER_CORNER_Y_OFFSET) {
                touch = ut;
                accepted = YES;
                break;
            }
        }
    }
    if (touch == nil || accepted == NO) return;
    CGPoint p = [touch locationInView:dvView];
    if ([[Objects CurrentFHL] CanAdd:p]) {
        [[Objects CurrentFHL] AddPoint:p];
        [dvView setNeedsDisplay];
        [self SendDrawingToServer:[Objects CurrentFHL]];
    }    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = nil;
    NSArray *allTouches = [touches allObjects];
    BOOL accepted = NO;
    for (UITouch *ut in allTouches) {
        if (ut.view == dvView) {
            CGPoint p = [ut locationInView:dvView];
            if (allTouches.count <= 1 || p.x < dvView.frame.size.width - LOWER_CORNER_X_OFFSET || p.y < dvView.frame.size.height - LOWER_CORNER_Y_OFFSET) {
                touch = ut;
                accepted = YES;
                break;
            }
        }
    }
    if (touch == nil || accepted == NO) return;
    CGPoint p = [touch locationInView:dvView];
    if ([Objects CurrentFHL].Points.count != 0) {
        if ([[Objects CurrentFHL] CanAdd:p]) {
            [[Objects CurrentFHL] AddPoint:p];
            [self SendDrawingToServer:[Objects CurrentFHL]];
            [[Objects CurrentFHL] clear];
            [dvView setNeedsDisplay];
        }
    }
}

-(BOOL) isSameColor:(UIColor*)col1 andColor:(UIColor*)col2 {
    CGFloat c1a, c1r, c1g, c1b;
    CGFloat c2a, c2r, c2g, c2b;
    [col1 getRed:&c1r green:&c1g blue:&c1b alpha:&c1a];
    [col2 getRed:&c2r green:&c2g blue:&c2b alpha:&c2a];
    
    BOOL bb = [self isFloatEqual:c1r and:c2r] && [self isFloatEqual:c1g and:c2g] && [self isFloatEqual:c1b and:c2b] && [self isFloatEqual:c1a and:c2a];
    return bb;
}

-(BOOL) isFloatEqual:(CGFloat) f1 and:(CGFloat) f2 {
    return fabs(f1 - f2) < 0.0001;
}


- (NSString*) fileNamePDF {
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [NSString stringWithFormat:@"%@.pdf", [nsdf stringFromDate:[NSDate date]]];
}

- (NSString*) fileNamePNG {
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [NSString stringWithFormat:@"%@.png", [nsdf stringFromDate:[NSDate date]]];
}

-(NSString*) path {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"The email was successfully sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Email NOT Sent" message:@"There was a problem sending the email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void) setDVViewNeedsDisplay {
    [dvView setNeedsDisplay];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == deleteAll) {
        if (buttonIndex == 1) {
            [self ClearObjectsFromServer];
            [[Objects List] removeAllObjects];
            [dvView setNeedsDisplay];
        }
    }
}

-(void) SynchronizeWithServer {
//    if (ShouldUpdate) {
        sync = [[NetworkClient alloc] InitWithDelegate:self];
        [sync ConnectWithNetworkCode:REQUEST_STATE AndExchangeObject:[UIDevice currentDevice].uniqueIdentifier];
//    }
}

-(void) SendDrawingToServer:(UIFreeHandLine*)fhl {
    sendObject = [[NetworkClient alloc] InitWithDelegate:self];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[UIDevice currentDevice].uniqueIdentifier];
    [arr addObject:[[Objects CurrentFHL] Serialize]];
    [sendObject ConnectWithNetworkCode:SEND_SHAPE AndExchangeObjects:arr];
}

-(void) ClearObjectsFromServer {
    [[Objects CurrentFHL] clear];
    sendClearSignal = [[NetworkClient alloc] InitWithDelegate:self];
    [sendClearSignal ConnectWithNetworkCode:CLEAR_MY_SHAPES AndExchangeObject:[UIDevice currentDevice].uniqueIdentifier];
}


-(void)NetworkConnection:(NetworkClient *)connection EndedWithSuccess:(NetworkObject *)norsp {
    if (connection == sync) {
//        int newState = ((NSNumber*)[norsp.ExchangeObjects objectAtIndex:0]).intValue;
//        if ([Objects State] == STATE_VERIFY && newState == STATE_INPUT) {
//            [self BtClearClick:nil];
//        }
//        [Objects SetState:newState];
//        if ([Objects State] != STATE_VERIFY) {
            [Objects SetColor:[UIFreeHandLine colorFromInt:((NSNumber*)[norsp.ExchangeObjects objectAtIndex:0]).intValue]];
            [_btColor setBackgroundColor:[Objects Color]];
//        }
//        else {
        NSArray *arr = [norsp.ExchangeObjects objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(1, norsp.ExchangeObjects.count - 1)]];
            [dvView Deserialize:arr WithDelegate:self];
//        }
    }
    else if (connection == sendObject) {
        ShouldUpdate = YES;
    }
    else if (connection == sendClearSignal) {
        ShouldUpdate = YES;
    }
    dvView.userInteractionEnabled = [Objects State] == STATE_INPUT;
    [dvView setNeedsDisplay];
}

-(void)NetworkConnection:(NetworkClient *)connection EndedWithError:(NSError *)error {}

- (IBAction)BtClearClick:(id)sender {
    ShouldUpdate = NO;
    [dvView setNeedsDisplay];
    [self ClearObjectsFromServer];
    _btClear.enabled = NO;
    [self performSelector:@selector(ClearReEnable) withObject:nil afterDelay:3];
}

-(void) ClearReEnable {
    _btClear.enabled = YES;
}
@end
