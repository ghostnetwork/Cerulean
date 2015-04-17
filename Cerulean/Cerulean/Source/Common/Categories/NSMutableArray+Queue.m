//
//  NSMutableArray+Queue.m
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

-(BOOL)isEmpty {return self.count == 0;}
-(BOOL)isNotEmpty {return self.count > 0;}
-(void)queuePush:(id)anObject {[self addObject:anObject];}

-(id)queuePeek
{
    if ([self isEmpty]) {return nil;}
    return [self firstObject];
}

-(id)queuePop
{
    id queueObject = [self queuePeek];
    if (queueObject) {[self removeObjectAtIndex:0];}
    return queueObject;
}

@end
