//
//  Objects.m
//  PadInput
//
//  Created by Flaviu on 2012/09/03.
//
//

#import "Objects.h"

static Objects* list;

@implementation Objects

+(NSMutableArray*)List {
    if (!list) {
        [self ReInitialize];
    }
    return [list Objects];
}

+(void)ReInitialize {
    list = [[Objects alloc] init];
    list.GridON = YES;
}


+(NSString *)DeviceID {
     return [[UIDevice currentDevice] uniqueIdentifier];
}

+(NSString *)DeviceName {
    return [[UIDevice currentDevice] name];
}


+(void)AddObject:(UIFreeHandLine *)obj {
    [list.Objects addObject:obj];
}

-(id)init {
    if (self = [super init]) {
        self.Objects = [[NSMutableArray alloc] init];
    }
    return self;
}

+(UIColor*)Color {
    return list.Color;
}

+(void)SetColor:(UIColor *)color {
    list.Color = color;
}

+(BOOL)GridON {
    return list.GridON;
}

+(void)SetGrid:(BOOL)gridON {
    list.GridON = gridON;
}

+(int)State {
    return list.State;
}

+(void)SetState:(int)state {
    list.State = state;
}

+(UIFreeHandLine *)CurrentFHL {
    return list.CurrentFHL;
}

+(void)setCurrentFHL:(UIFreeHandLine *)fhl {
    list.CurrentFHL = fhl;
}



@end
