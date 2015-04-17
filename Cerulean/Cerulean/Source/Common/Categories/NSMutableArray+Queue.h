//
//  NSMutableArray+Queue.h
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)
-(void)queuePush:(id)anObject;
-(id)queuePeek;
-(id)queuePop;
-(BOOL)isEmpty;
-(BOOL)isNotEmpty;
@end
