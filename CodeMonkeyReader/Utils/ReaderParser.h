//
//  ReaderParser.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <Foundation/Foundation.h>

static NSString *const kName = @"wkName";
static NSString *const kOriginUrl = @"wkOriginUrl";
static NSString *const kUrl = @"wkUrl";

@interface ReaderParser : NSObject

+ (NSMutableDictionary *)parseSourceDataToArray:(NSData *)htmlData;

@end
