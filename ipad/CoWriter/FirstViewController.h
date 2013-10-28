//
//  FirstViewController.h
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define REFRESH_INTERVAL 0.2 //seconds

#define LOWER_CORNER_X_OFFSET 200
#define LOWER_CORNER_Y_OFFSET 100

#import <UIKit/UIKit.h>
#import "UIDrawableView.h"
#import "NetworkClient.h"
#import "Objects.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol FirstViewControllerDelegate;

@interface FirstViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, NetworkClientDelegate, UIDrawableViewDelegate> {
    
    UIAlertView *deleteAll;
    
    NetworkClient *sync;
    NetworkClient *sendObject;
    NetworkClient *sendClearSignal;
    
    NSTimer *syncTimer;
    
    BOOL ShouldUpdate;
}

@property (weak, nonatomic) IBOutlet UIDrawableView *dvView;
@property (weak, nonatomic) IBOutlet UIButton *btClear;
@property (weak, nonatomic) IBOutlet UIButton *btColor;
- (IBAction)BtClearClick:(id)sender;


@property (weak, nonatomic) id<FirstViewControllerDelegate>delegate;

@end

@protocol FirstViewControllerDelegate <NSObject>
-(void)FirstViewControllerSearchAvailable:(FirstViewController*)fvc;
@end

