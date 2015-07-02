//
//  ReaderArtcle.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <Realm/Realm.h>

@class ReaderCategory;

@interface ReaderArtcle : RLMObject

@property NSString *title;
@property NSString *link;
@property NSString *originLink;

@property ReaderCategory *category;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ReaderArtcle>
RLM_ARRAY_TYPE(ReaderArtcle)
