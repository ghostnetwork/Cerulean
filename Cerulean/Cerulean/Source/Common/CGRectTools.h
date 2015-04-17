//
//  CGRectTools.h
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#ifndef ViewFrameToolsSpike_CGRectTools_h
#define ViewFrameToolsSpike_CGRectTools_h

#include <CoreGraphics/CGGeometry.h>

CG_INLINE CGRect
CGRectMakeClone(CGRect r)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
CGRectMakeWithX(CGRect r, CGFloat x)
{
    CGRect rect = CGRectMakeClone(r);
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect
CGRectMakeWithY(CGRect r, CGFloat y)
{
    CGRect rect = CGRectMakeClone(r);
    rect.origin.y = y;
    return rect;
}

CG_INLINE CGRect
CGRectMakeWithWidth(CGRect r, CGFloat width)
{
    CGRect rect = CGRectMakeClone(r);
    rect.size.width = width;
    return rect;
}

CG_INLINE CGRect
CGRectMakeWithHeight(CGRect r, CGFloat height)
{
    CGRect rect = CGRectMakeClone(r);
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
CGRectMakeSizeZero(CGRect r)
{
    CGRect rect = r;
    rect.size = CGSizeZero;
    return rect;
}

#endif
