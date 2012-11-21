//
//  USRandom.m
//  Shashti
//
//  Created by James Williams on 9/23/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import "USRandom.h"

@interface USRandom (USRandom_Private)
-(void)refillDiceBuffer:(NSError**)error;
@end

CG_INLINE NSUInteger RNGBetweenZeroAndLimit(u_int32_t limit)
{
    return (NSUInteger)arc4random_uniform(limit + 1);
}

@implementation USRandom

+(NSUInteger)rollDice:(u_int32_t)sides
{
    return RNGBetweenZeroAndLimit(sides - 1) + 1;
}

-(NSUInteger)rollInternetD6:(NSError**)error
{
    if(!diceBuffer.count)
        [self refillDiceBuffer:error];
    
    if(*error)
        return 0;
    
    NSNumber *v = [diceBuffer objectAtIndex:0];
    [diceBuffer removeObjectAtIndex:0];
    
    return [v unsignedIntegerValue];
}

+(NSUInteger)rollInternetD6:(NSError**)error
{
    return [[USRandom sharedUSRandom] rollInternetD6:error];
}

+(NSUInteger)generateRandomNumberWithMin:(NSUInteger)min andMax:(NSUInteger)max
{
    NSUInteger offset = min;
    min -= offset;
    max -= offset;
    
    return RNGBetweenZeroAndLimit((u_int32_t)max) + offset;
}


+(NSArray*)generateRandomNumbersWithCount:(NSUInteger)count andMin:(NSUInteger)min andMax:(NSUInteger)max
{
    NSMutableArray *r = [NSMutableArray arrayWithCapacity:count];
    
    for(NSUInteger i = 0; i < count; i++)
    {
        [r addObject:[NSNumber numberWithUnsignedInteger:[USRandom generateRandomNumberWithMin:min andMax:max]]];
    }
    
    return [NSArray arrayWithArray:r];
}

-(void)refillDiceBuffer:(NSError**)error
{
    [NSThread sleepForTimeInterval:.5];
    
    NSURL *url = [NSURL URLWithString:@"http://www.random.org/integers/?num=500&min=1&max=6&col=1&base=10&format=plain&rnd=new"];
        
    NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
    
    if(!data)
    {
        return;
    }
    
    *error = NULL;
    
    NSArray *lines = [data componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    
    NSUInteger foundIntegers = 0;
    
    for(NSString *line in lines)
    {
        @autoreleasepool {
            if(line.length)
            {
                NSScanner *scanner = [NSScanner scannerWithString:line];
                NSInteger v = 0;
                if([scanner scanInteger:&v])
                {
                    foundIntegers++;
                    [diceBuffer addObject:[NSNumber numberWithUnsignedInteger:(NSUInteger)v]];
                }
            }
        }
    }
    
    if(foundIntegers < 500)
    {
        *error = [NSError errorWithDomain:@"com.ungroundedsoftware.shashti"
                                     code:500
                                 userInfo:@{
                NSLocalizedDescriptionKey: @"The web service did not return the expected number of random numbers.",
                NSLocalizedRecoverySuggestionErrorKey: @"Check your Internet connection and your RANDOM.ORG quota at http://random.org/quota/"}];
    }
    
}

-(id)init
{
    if((self = [super init]))
    {
        diceBuffer = [NSMutableArray arrayWithCapacity:1000];
    }
    return self;
}

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(USRandom)
@end
