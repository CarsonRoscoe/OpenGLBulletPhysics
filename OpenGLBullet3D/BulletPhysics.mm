//
//  BulletPhysics.m
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import "BulletPhysics.h"
#include "btBulletDynamicsCommon.h"

@interface BulletPhysics()
{
    btBroadphaseInterface *broadphase;
    btDefaultCollisionConfiguration *collisionConfiguration;
    btCollisionDispatcher *dispatcher;
    btSequentialImpulseConstraintSolver *solver;
    btDiscreteDynamicsWorld *dynamicsWorld;
    btCollisionShape *groundShape;
    btCollisionShape *fallShape;
    btDefaultMotionState *groundMotionState;
    btRigidBody *groundRigidBody;
    btDefaultMotionState *fallMotionState;
    btRigidBody *fallRigidBody;
}

@end

@implementation BulletPhysics

- (instancetype)init
{
    self = [super init];
    if (self) {
        broadphase = new btDbvtBroadphase();
        
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        
        solver = new btSequentialImpulseConstraintSolver;
        
        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        
        dynamicsWorld->setGravity(btVector3(0,-10,0));
        
        
        groundShape = new btStaticPlaneShape(btVector3(0,1,0),1);
        
        fallShape = new btSphereShape(1);
        
        
        groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,1,0)));
        btRigidBody::btRigidBodyConstructionInfo
        groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        dynamicsWorld->addRigidBody(groundRigidBody);
        
        // change this to start sphere in a different location
        fallMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,5,0)));
        btScalar mass = 1;
        btVector3 fallInertia(0,0,0);
        fallShape->calculateLocalInertia(mass,fallInertia);
        btRigidBody::btRigidBodyConstructionInfo fallRigidBodyCI(mass,fallMotionState,fallShape,fallInertia);
        fallRigidBody = new btRigidBody(fallRigidBodyCI);
        dynamicsWorld->addRigidBody(fallRigidBody);
        
        NSLog(@"Starting bullet physics...\n");
    }
    return self;
}

- (void)dealloc
{
    dynamicsWorld->removeRigidBody(fallRigidBody);
    delete fallRigidBody->getMotionState();
    delete fallRigidBody;
    
    dynamicsWorld->removeRigidBody(groundRigidBody);
    delete groundRigidBody->getMotionState();
    delete groundRigidBody;
    
    
    delete fallShape;
    
    delete groundShape;
    
    
    delete dynamicsWorld;
    delete solver;
    delete collisionConfiguration;
    delete dispatcher;
    delete broadphase;
    NSLog(@"Ending bullet physics...\n");
}

-(void)Update:(float)elapsedTime
{
    dynamicsWorld->stepSimulation(1/60.f,10);
    
    btTransform trans;
    fallRigidBody->getMotionState()->getWorldTransform(trans);
    
    NSLog(@"%f\t%f\n", elapsedTime*1000, trans.getOrigin().getY());
}


@end
