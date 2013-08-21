//
//  MCGMorseCodeConverter.h
//  MorseCodeGenerator
//
//  Created by Kenny Tang on 8/9/13.
//  Copyright (c) 2013 com.corgitoergosum.net. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum MCGMorseCodeData : NSUInteger {
    
    MCGMorseCodeSingleSpace, // 1 pause
    MCGMorseCodeDit, // 1 beep
    MCGMorseCodeDah, // 3 beeps
    MCGMorseCodeThreeSpaces // 3 pauses
} MCGMorseCodeData;

static NSString * const kMorseCodeDitString = @".";
static NSString * const kMorseCodeDahString = @"-";
static NSString * const kMorseCodeDahSpaceString = @" ";
static NSString * const kMorseCodeDahThreeSpacesString = @"   ";

@interface MCGMorseCodeConverter : NSObject

- (NSArray*)convertStringToMorseCodes:(NSString*)inputString;

@end
