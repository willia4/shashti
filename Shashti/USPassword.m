//
//  USPassword.m
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import "USPassword.h"

@interface USPassword (USPassword_Private)
-(void)addEntropy;
@end

@implementation USPassword

+(NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *r = [super keyPathsForValuesAffectingValueForKey:key];
    
    if([key isEqualToString:@"stringValue"])
    {
        r = [r setByAddingObject:@"addSpacesBetweenWords"];
    }
    
    return r;
}

-(id)initWithNumberOfWords:(NSUInteger)numberOfWords andAdditionalEntropy:(BOOL)a withTrueRandomness:(BOOL)trueRandomness error:(NSError**)error;
{
    if((self = [super init]))
    {
        additionalEntropy = a;
        
        words = [NSMutableArray arrayWithCapacity:numberOfWords];
        
        for(NSUInteger i = 0; i < numberOfWords; i++)
        {
            NSString *word = nil;
            if(trueRandomness)
                word = [USWordList randomWordByDice:error];
            else
                word = [USWordList randomWord];
            
            if(*error)
                return self;
            
            [words addObject:word];
        }
        
        if(additionalEntropy)
            [self addEntropy];
    }
    
    return self;
}

-(void)addEntropy
{
    NSUInteger wordIndex = [USRandom generateRandomNumberWithMin:0 andMax:(words.count - 1)];
    
    NSMutableString *currentWord = [NSMutableString stringWithString:[words objectAtIndex:wordIndex]];
    NSUInteger charIndex = [USRandom generateRandomNumberWithMin:0 andMax:(currentWord.length - 1)];
    
    unichar availableChars[] =  {   '~', '!', '#',  '$',  '%', '^',
                                    '&', '*', '(',  ')',  '-', '=',
                                    '+', '[', ']',  '\\', '{', '}',
                                    ':', ';', '\"', '\'', '<', '>',
                                    '?', '/', '0',  '1',  '2', '3',
                                    '4', '5', '6',  '7',  '8', '9'};
    
    NSUInteger entropyIndex = [USRandom generateRandomNumberWithMin:0 andMax:(36 -1)];
    NSString *entropyCharacter = [NSString stringWithCharacters:&availableChars[entropyIndex] length:1];
    
    [currentWord insertString:entropyCharacter atIndex:charIndex];
    
    [words replaceObjectAtIndex:wordIndex withObject:[NSString stringWithString:currentWord]];
}

-(NSArray*)words
{
    return [NSArray arrayWithArray:words];
}

-(BOOL)additionalEntroy
{
    return additionalEntropy;
}

-(NSString*)description
{
    return self.stringValue;
}

-(NSString*)stringValue
{
    if(self.addSpacesBetweenWords)
        return [words componentsJoinedByString:@" "];
    else
        return [words componentsJoinedByString:@""];
}
@end
