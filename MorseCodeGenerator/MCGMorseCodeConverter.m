//
//  MCGMorseCodeConverter.m
//  MorseCodeGenerator
//
//  Created by Kenny Tang on 8/9/13.
//  Copyright (c) 2013 com.corgitoergosum.net. All rights reserved.
//

#import "MCGMorseCodeConverter.h"

@interface MCGMorseCodeConverter()

@property (nonatomic, strong) NSDictionary * morseCodeDict;

@end

@implementation MCGMorseCodeConverter

- (id)init {
    self = [super init];
    if (self != nil){
        [self initConversionTable];
    }
    return self;
}

#pragma mark - public
- (NSArray*)convertStringToMorseCodes:(NSString*)inputString {
    NSMutableArray * convertedMorseCodesArray = [@[] mutableCopy];
    
    for (int index = 0; index < inputString.length; index++){
        NSString * charString = [[inputString lowercaseString] substringWithRange:NSMakeRange(index, 1)];
        NSArray * charMorseCodes = self.morseCodeDict[charString];
        
        [charMorseCodes enumerateObjectsUsingBlock:^(NSNumber * morseCodeCharNum, NSUInteger idx, BOOL *stop) {
            [convertedMorseCodesArray addObject:morseCodeCharNum];
        }];
        
        if (index < (inputString.length-1)){
            [convertedMorseCodesArray addObject:@(MCGMorseCodeSingleSpace)];
        }
    }
    
    return convertedMorseCodesArray;
}

#pragma mark - private
- (void) initConversionTable {
    
    // source: http://morsecode.scphillips.com/morse.html http://home.windstream.net/johnshan/cw_ss_list_punc.html
    
    NSMutableDictionary * morseCodeDict = [[NSMutableDictionary alloc] init];
    morseCodeDict[@" "] = @[@(MCGMorseCodeThreeSpaces)];
    morseCodeDict[@"a"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"b"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"c"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"d"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"e"] = @[@(MCGMorseCodeDit)];
    morseCodeDict[@"f"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"g"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"h"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"i"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"j"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"k"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"l"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"m"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"n"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"o"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"p"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"q"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"r"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"s"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"t"] = @[@(MCGMorseCodeDah)];
    morseCodeDict[@"u"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"v"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"w"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"x"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"y"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"z"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    
    morseCodeDict[@"1"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"2"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"3"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@"4"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"5"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"6"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"7"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"8"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"9"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"0"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    
    morseCodeDict[@"."] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@","] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah)];
    morseCodeDict[@":"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@";"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"?"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit)];
    morseCodeDict[@"'"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"-"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"/"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"("] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@")"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"\""] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"@"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"="] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDit), @(MCGMorseCodeDah)];
    morseCodeDict[@"!"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"["] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"]"] = @[@(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    morseCodeDict[@"+"] = @[@(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit), @(MCGMorseCodeDah), @(MCGMorseCodeDit)];
    
    self.morseCodeDict = morseCodeDict;
}


@end
