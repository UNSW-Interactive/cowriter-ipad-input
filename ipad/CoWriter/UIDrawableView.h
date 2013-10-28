//
//  UIDrawableView.h
//  PadInput
//
//  Created by CRAFT on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define FONT_SIZE 9.5

#define GRID_BOXES_X 10
#define GRID_BOXES_Y 8

#define OUTSIDE_MARGIN 40 //pixels

#import <UIKit/UIKit.h>
#import "Objects.h"

#import "UIFreeHandLine.h"

@protocol UIDrawableViewDelegate;

@interface UIDrawableView : UIView

//@property (nonatomic) NSMutableArray *Objects;
@property (nonatomic) BOOL IsLocked;

@property (weak, nonatomic) id<UIDrawableViewDelegate> delegate;

-(NSMutableArray*)Serialize;
-(void)Deserialize:(NSMutableArray*)stream WithDelegate:(id)delegate;

@end

@protocol UIDrawableViewDelegate <NSObject>
@optional
-(void)UIDrawableView:(UIDrawableView*)uiDrawableView SetNewColor:(UIColor*)color;
-(void)UIDrawableView:(UIDrawableView*)uiDrawableView SetNewPage:(int)page;
-(void)UIDrawableViewSearchAvailable:(UIDrawableView *)uiDrawableView;
@end