//
//  CCActionFollow+CurrentOffset.m
//  Poing
//
//  Created by Jhon Montanez on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCActionFollow+CurrentOffset.h"

@implementation CCActionFollow (CurrentOffset)

- (CGPoint)currentOffset {
    if(_boundarySet)
    {
        // whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
        if(_boundaryFullyCovered)
            return [(CCNode *)_target position];
        
        CGPoint tempPos = ccpSub( _halfScreenSize, _followedNode.position);
        return ccp(clampf(tempPos.x, _leftBoundary, _rightBoundary), clampf(tempPos.y, _bottomBoundary, _topBoundary));
    }
    else
        return ccpSub( _halfScreenSize, _followedNode.position );
}

@end