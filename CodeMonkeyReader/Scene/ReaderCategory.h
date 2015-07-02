//
//  ReaderCategory.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <Realm/Realm.h>

#import "ReaderArtcle.h"

@interface ReaderCategory : RLMObject

@property NSString *name;
@property NSDate *updateDate;
@property RLMArray<ReaderArtcle> *artcles;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ReaderCategory>
RLM_ARRAY_TYPE(ReaderCategory)
