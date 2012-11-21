//
//  USRandom.h
//  Shashti
//
//  Created by James Williams on 9/23/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "CWLSynthesizeSingleton.h"

@interface USRandom : NSObject
{
    NSMutableArray *diceBuffer;
}

CWL_DECLARE_SINGLETON_FOR_CLASS(USRandom)

+(NSUInteger)rollDice:(u_int32_t)sides;
+(NSUInteger)rollInternetD6:(NSError**)error;

+(NSUInteger)generateRandomNumberWithMin:(NSUInteger)min andMax:(NSUInteger)max;
+(NSArray*)generateRandomNumbersWithCount:(NSUInteger)count andMin:(NSUInteger)min andMax:(NSUInteger)max;

@end

