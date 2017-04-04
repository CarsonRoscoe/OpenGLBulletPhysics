//
//  BulletPhysics.m
//  BulletTest
//
//  Created by Borna Noureddin on 2015-03-20.
//  Copyright (c) 2015 BCIT. All rights reserved.
//

#import "BulletPhysics.h"
#include "btBulletDynamicsCommon.h"
#include <GLKit/GLKit.h>

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
    btCollisionShape *partTwoGroundShape;
    btDefaultMotionState *partTwoGroundMotionState;
    btRigidBody *partTwoGroundRigidBody;
    
    btCollisionShape *leftWallGroundShape;
    btDefaultMotionState *leftWallGroundMotionState;
    btRigidBody *leftWallGroundRigidBody;
    btCollisionShape *rightWallGroundShape;
    btDefaultMotionState *rightWallGroundMotionState;
    btRigidBody *rightWallGroundRigidBody;
    int part;
    float lastRotation;
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
        
        fallShape = new btSphereShape(0.9);
        
        groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,-5,0)));
        btRigidBody::btRigidBodyConstructionInfo
        groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        groundRigidBody->setRestitution(1);
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
    }
    return self;
}

- (instancetype)initForPartTwo:(float)angle offsetX:(float)offsetX offsetY:(float)offsetY
{
    self = [super init];
    part = 2;
    if (self) {
        //Setup world
        broadphase = new btDbvtBroadphase();
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        solver = new btSequentialImpulseConstraintSolver;
        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        dynamicsWorld->setGravity(btVector3(0,-9.81,0));
        
        //Ramp
        btVector3 boxHalfExtends;
        boxHalfExtends.setX(2);
        boxHalfExtends.setY(2);
        boxHalfExtends.setZ(0.5);
        groundShape = new btBoxShape(boxHalfExtends);
        btQuaternion groundQuat = btQuaternion(0,0,0,1);
        groundQuat.setEulerZYX(GLKMathDegreesToRadians(angle), 0, 0);
        groundMotionState = new btDefaultMotionState(btTransform(groundQuat,btVector3(-1.5 + offsetX,-4.0 + offsetY,0)));
        btRigidBody::btRigidBodyConstructionInfo groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        groundRigidBody->setRestitution(0.1);
        dynamicsWorld->addRigidBody(groundRigidBody);
        
        //Box floor
        btVector3 groundHalfExtends;
        groundHalfExtends.setX(2.5);
        groundHalfExtends.setY(0.5);
        groundHalfExtends.setZ(0.5);
        partTwoGroundShape = new btBoxShape(groundHalfExtends);
        partTwoGroundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(2.0, -4.5, 0)));
        btRigidBody::btRigidBodyConstructionInfo partTwoGroundRigidBodyCI(0,partTwoGroundMotionState,partTwoGroundShape,btVector3(0,0,0));
        partTwoGroundRigidBodyCI.m_friction = 0.4;
        partTwoGroundRigidBody = new btRigidBody(partTwoGroundRigidBodyCI);
        partTwoGroundRigidBody->setRestitution(0);
        dynamicsWorld->addRigidBody(partTwoGroundRigidBody);
        
        //Box walls
        btVector3 wallHalfExtends;
        wallHalfExtends.setX(0.5);
        wallHalfExtends.setY(2.0);
        wallHalfExtends.setZ(0.5);
        leftWallGroundShape = new btBoxShape(wallHalfExtends);
        rightWallGroundShape = new btBoxShape(wallHalfExtends);
        leftWallGroundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(-0.5, -4.0, 0)));
        rightWallGroundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(4, -4.0, 0)));
        btRigidBody::btRigidBodyConstructionInfo leftWallGroundRigidBodyCI(0,leftWallGroundMotionState,leftWallGroundShape,btVector3(0,0,0));
        btRigidBody::btRigidBodyConstructionInfo rightWallGroundRigidBodyCI(0,rightWallGroundMotionState,rightWallGroundShape,btVector3(0,0,0));
        leftWallGroundRigidBody = new btRigidBody(leftWallGroundRigidBodyCI);
        rightWallGroundRigidBody = new btRigidBody(rightWallGroundRigidBodyCI);
        leftWallGroundRigidBody->setRestitution(0);
        rightWallGroundRigidBody->setRestitution(0);
        dynamicsWorld->addRigidBody(leftWallGroundRigidBody);
        dynamicsWorld->addRigidBody(rightWallGroundRigidBody);
        
        //Ball
        fallShape = new btSphereShape(0.5);
        fallMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(-1,5,0)));
        btScalar mass = 1;
        btVector3 fallInertia(0,0,0);
        fallShape->calculateLocalInertia(mass,fallInertia);
        btRigidBody::btRigidBodyConstructionInfo fallRigidBodyCI(mass,fallMotionState,fallShape,fallInertia);
        fallRigidBodyCI.m_friction = 0.4;
        fallRigidBody = new btRigidBody(fallRigidBodyCI);
        fallRigidBody->setRestitution(0.1);
        dynamicsWorld->addRigidBody(fallRigidBody);
    }
    return self;
}

- (instancetype)initForPartOneNoMotion {
    ballPosition[0] = 0;
    ballPosition[1] = 5;
    ballPosition[2] = 0;
    floorPosition[0] = 0;
    floorPosition[1] = -5;
    floorPosition[2] = 0;
    ballRotation = 0;
    return self;
}

- (instancetype)initForPartTwoNoMotion:(float)angle offsetX:(float)offsetX offsetY:(float)offsetY {
    ballPosition[0] = -1;
    ballPosition[1] = 5;
    ballPosition[2] = 0;
    floorPosition[0] = -1.5 + offsetX;
    floorPosition[1] = -4.0 + offsetY;
    floorPosition[2] = 0;
    ballRotation = 0;
    return self;
}

- (void)dealloc
{
    if (dynamicsWorld != NULL) {
        dynamicsWorld->removeRigidBody(fallRigidBody);
        delete fallRigidBody->getMotionState();
        delete fallRigidBody;
        
        dynamicsWorld->removeRigidBody(groundRigidBody);
        delete groundRigidBody->getMotionState();
        delete groundRigidBody;
        
        if (part == 2) {
            dynamicsWorld->removeRigidBody(partTwoGroundRigidBody);
            delete partTwoGroundRigidBody->getMotionState();
            delete partTwoGroundRigidBody;
            delete partTwoGroundShape;
            
            dynamicsWorld->removeRigidBody(leftWallGroundRigidBody);
            delete leftWallGroundRigidBody->getMotionState();
            delete leftWallGroundRigidBody;
            delete leftWallGroundShape;
            
            dynamicsWorld->removeRigidBody(rightWallGroundRigidBody);
            delete rightWallGroundRigidBody->getMotionState();
            delete rightWallGroundRigidBody;
            delete rightWallGroundShape;
        }
        
        delete fallShape;
        
        delete groundShape;
        
        
        delete dynamicsWorld;
        delete solver;
        delete collisionConfiguration;
        delete dispatcher;
        delete broadphase;
    }
}

-(void)Update:(float)elapsedTime
{
    if (dynamicsWorld != NULL) {
        dynamicsWorld->stepSimulation(1/60.f,10);
        
        btTransform trans;
        fallRigidBody->getMotionState()->getWorldTransform(trans);
        ballPosition[0] = trans.getOrigin().getX();
        ballPosition[1] = trans.getOrigin().getY();
        ballPosition[2] = trans.getOrigin().getZ();
        
        if (part == 2) {
            btVector3 velocity = fallRigidBody->getLinearVelocity();
            ballRotation -= velocity.x() / 30.0;
        }
        
        groundRigidBody->getMotionState()->getWorldTransform(trans);
        floorPosition[0] = trans.getOrigin().getX();
        floorPosition[1] = trans.getOrigin().getY();
        floorPosition[2] = trans.getOrigin().getZ();
    }
}


@end
