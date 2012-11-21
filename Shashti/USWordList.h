//
//  USWordList.h
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "USRandom.h"

@interface USWordList : NSObject
{
    NSDictionary *keyedWords;
    NSArray *wordList;
    
    NSUInteger wordCount;
}

-(void)loadWords;
-(NSString*)randomWord;
-(NSString*)randomWordByDice:(NSError**)error;

+(NSString*)randomWord;
+(NSString*)randomWordByDice:(NSError**)error;
CWL_DECLARE_SINGLETON_FOR_CLASS(USWordList)
@end
