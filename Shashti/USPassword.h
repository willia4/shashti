//
//  USPassword.h
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USRandom.h"
#import "USWordList.h"

@interface USPassword : NSObject
{
    NSMutableArray *words;
    
    BOOL additionalEntropy;
}
@property (readonly) NSArray *words;
@property (readonly) NSString *stringValue;

@property (readonly) BOOL additionalEntroy;

-(id)initWithNumberOfWords:(NSUInteger)numberOfWords andAdditionalEntropy:(BOOL)a withTrueRandomness:(BOOL)trueRandomness error:(NSError**)error;
@end
