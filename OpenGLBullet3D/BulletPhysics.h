//
//  BulletPhysics.h
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BulletPhysics: NSObject {
@public
    float ballPosition[3];
    float floorPosition[3];
}

- (instancetype)initForPartOne;
- (instancetype)initForPartTwo:(float)angle offsetX:(float)offsetX offsetY:(float)offsetY;
-(void)Update:(float)elapsedTime;

@end
