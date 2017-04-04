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
    int part;
}

@end

@implementation BulletPhysics

- (instancetype)initForPartOne
{
    self = [super init];
    part = 1;
    if (self) {
        broadphase = new btDbvtBroadphase();
        
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        
        solver = new btSequentialImpulseConstraintSolver;
        
        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        
        dynamicsWorld->setGravity(btVector3(0,-9.81,0));
        
        groundShape = new btStaticPlaneShape(btVector3(0,1,0),1);
        
        fallShape = new btSphereShape(1);
        
        
        groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,-5,0)));
        btRigidBody::btRigidBodyConstructionInfo
        groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        groundRigidBody->setRestitution(0.9);
        dynamicsWorld->addRigidBody(groundRigidBody);
        
        // change this to start sphere in a different location
        fallMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,5,0)));
        btScalar mass = 1;
        btVector3 fallInertia(0,0,0);
        fallShape->calculateLocalInertia(mass,fallInertia);
        btRigidBody::btRigidBodyConstructionInfo fallRigidBodyCI(mass,fallMotionState,fallShape,fallInertia);
        fallRigidBody = new btRigidBody(fallRigidBodyCI);
        fallRigidBody->setRestitution(0.9);
        dynamicsWorld->addRigidBody(fallRigidBody);
        
        NSLog(@"Starting bullet physics...\n");
    }
    return self;
}

- (instancetype)initForPartTwo:(float)angle
{
    self = [super init];
    part = 2;
    if (self) {
        broadphase = new btDbvtBroadphase();
        
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        
        solver = new btSequentialImpulseConstraintSolver;
        
        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        
        dynamicsWorld->setGravity(btVector3(0,-9.81,0));
        
        btVector3 boxHalfExtends;
        boxHalfExtends.setX(1);
        boxHalfExtends.setY(1);
        boxHalfExtends.setZ(1);
        
        groundShape = new btBoxShape(boxHalfExtends);
        
        fallShape = new btSphereShape(0.5);
        
        btQuaternion groundQuat = btQuaternion(0,0,0,1);
        groundQuat.setEuler(0, 0, angle);
        groundMotionState = new btDefaultMotionState(btTransform(groundQuat,btVector3(-4,0,0)));
        btRigidBody::btRigidBodyConstructionInfo
        groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        groundRigidBody->setRestitution(0.2);
        dynamicsWorld->addRigidBody(groundRigidBody);
        
        fallMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(-3,5,0)));
        btScalar mass = 1;
        btVector3 fallInertia(0,0,0);
        fallShape->calculateLocalInertia(mass,fallInertia);
        btRigidBody::btRigidBodyConstructionInfo fallRigidBodyCI(mass,fallMotionState,fallShape,fallInertia);
        fallRigidBody = new btRigidBody(fallRigidBodyCI);
        fallRigidBody->setRestitution(0.2);
        
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
    ballPosition[0] = trans.getOrigin().getX();
    ballPosition[1] = trans.getOrigin().getY();
    ballPosition[2] = trans.getOrigin().getZ();
    groundRigidBody->getMotionState()->getWorldTransform(trans);
    floorPosition[0] = trans.getOrigin().getX();
    floorPosition[1] = trans.getOrigin().getY();
    floorPosition[2] = trans.getOrigin().getZ();

    NSLog(@"%f %f %f", ballPosition[0], ballPosition[1], ballPosition[2]);
}


@end
