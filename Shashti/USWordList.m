//
//  USWordList.m
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import "USWordList.h"

@implementation USWordList

+(NSString*)randomWord
{
    return [[USWordList sharedUSWordList] randomWord];
}

+(NSString*)randomWordByDice:(NSError**)error
{
    return [[USWordList sharedUSWordList] randomWordByDice:error];
}

-(id)init
{
    if((self = [super init]))
    {
        keyedWords = nil;
        wordList = nil;
    }
    return self;
}

-(void)loadWords
{
    if(keyedWords && wordList)
        return;
    
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"diceware.wordlist" withExtension:@"asc"];
    NSString *file = [NSString stringWithContentsOfURL:filePath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    NSArray *lines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    
    wordCount = lines.count;
    NSMutableDictionary *keyed = [NSMutableDictionary dictionaryWithCapacity:wordCount];
    NSMutableArray *words = [NSMutableArray arrayWithCapacity:wordCount];
    
    for(NSString *line in lines)
    {
        @autoreleasepool {
            NSScanner *scanner = [NSScanner scannerWithString:line];
            NSString *key = NULL;
            NSString *word = NULL;
            
            [scanner scanUpToString:@"\t" intoString:&key];
            [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
            [scanner scanUpToString:@"\n" intoString:&word];
            
            [keyed setValue:word forKey:key];
            [words addObject:word];
        }
    }
    
    keyedWords = [NSDictionary dictionaryWithDictionary:keyed];
    wordList = [NSArray arrayWithArray:words];
}

-(NSString*)randomWord
{
    [self loadWords];
    
    NSUInteger roll1 = [USRandom rollDice:6];
    NSUInteger roll2 = [USRandom rollDice:6];
    NSUInteger roll3 = [USRandom rollDice:6];
    NSUInteger roll4 = [USRandom rollDice:6];
    NSUInteger roll5 = [USRandom rollDice:6];
        
    NSString *key = [NSString stringWithFormat:@"%lu%lu%lu%lu%lu", roll1, roll2, roll3, roll4, roll5];
    
    return [keyedWords objectForKey:key];
}

-(NSString*)randomWordByDice:(NSError**)error
{
    [self loadWords];
    
//    NSUInteger roll1 = [USRandom rollDice:6];
//    NSUInteger roll2 = [USRandom rollDice:6];
//    NSUInteger roll3 = [USRandom rollDice:6];
//    NSUInteger roll4 = [USRandom rollDice:6];
//    NSUInteger roll5 = [USRandom rollDice:6];

    NSUInteger roll1 = [USRandom rollInternetD6:error];
    NSUInteger roll2 = [USRandom rollInternetD6:error];
    NSUInteger roll3 = [USRandom rollInternetD6:error];
    NSUInteger roll4 = [USRandom rollInternetD6:error];
    NSUInteger roll5 = [USRandom rollInternetD6:error];
    
    NSString *key = [NSString stringWithFormat:@"%lu%lu%lu%lu%lu", roll1, roll2, roll3, roll4, roll5];
    
    return [keyedWords objectForKey:key];
}

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(USWordList)
@end
