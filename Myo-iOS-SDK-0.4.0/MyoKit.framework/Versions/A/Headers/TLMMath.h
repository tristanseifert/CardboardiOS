//
//  TLMMath.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>

/**
 Represents a 3 dimensional vector.
 */
struct _TLMVector3
{
    float x, y, z;
};
typedef struct _TLMVector3 TLMVector3;

/**
 Convenience constructor for a TLMVector3.
 */
TLMVector3 TLMVector3Make(float x, float y, float z);

/**
 Returns the length of \a vector (the square root of the sum of the components).
 */
float TLMVector3Length(TLMVector3 vector);

/**
 Returns true if \a vectorLeft equals \a vectorRight, otherwise false.
 */
BOOL TLMVector3Equal(TLMVector3 vectorLeft, TLMVector3 vectorRight);

/**
 Represents a quaternion.
 */
struct _TLMQuaternion
{
    float x, y, z, w;
};
typedef struct _TLMQuaternion TLMQuaternion;

/**
 Constant for the identity quaternion.
 */
extern const TLMQuaternion TLMQuaternionIdentity;

/**
 Convenience constructor for a TLMQuaternion.
 */
TLMQuaternion TLMQuaternionMake(float x, float y, float z, float w);

/**
 Returns the length of \a quaternion (the square of the sum of the components).
 */
float TLMQuaternionLength(TLMQuaternion quaternion);

/**
 Returns true if \a quaternionLeft equals \a quaternionRight, otherwise false.
 */
BOOL TLMQuaternionEqual(TLMQuaternion quaternionLeft, TLMQuaternion quaternionRight);

/**
 Returns the normalized form of \a quaternion, whose length equals 1.
 */
TLMQuaternion TLMQuaternionNormalize(TLMQuaternion quaternion);

/**
 Returns the product of multiplying \a quaternionLeft by \a quaternionRight. Quaternion multiplication is 
 noncommutative, so order matters.
 */
TLMQuaternion TLMQuaternionMultiply(TLMQuaternion quaternionLeft, TLMQuaternion quaternionRight);

/**
 Returns the inverse of \a quaternion.
 */
TLMQuaternion TLMQuaternionInvert(TLMQuaternion quaternion);
