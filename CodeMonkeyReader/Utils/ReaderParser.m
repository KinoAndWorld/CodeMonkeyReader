//
//  ReaderParser.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "ReaderParser.h"
#import <hpple/TFHpple.h>

//#import "ReaderArtcle.h"
//#import "ReaderCategory.h"

@implementation ReaderParser

+ (NSMutableDictionary *)parseSourceDataToArray:(NSData *)htmlData{
    TFHpple *xPathParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSMutableDictionary *categoryDic = [NSMutableDictionary dictionary];
    NSMutableArray *lastPlaceArray;
    NSArray *categoryItems = [xPathParser searchWithXPathQuery:@"//article[@class='markdown-body entry-content']/p"];
    for (TFHppleElement *elem in categoryItems) {
        NSString *tagTitle = elem.firstChild.attributes[@"name"];
//        if ([tagTitle isEqualToString:@"user-content-IOS"]) {
//            tagTitle = @"user-content-iOS";
//        }
//        if ([tagTitle isEqualToString:@"user-content-SWIFT"]) {
//            tagTitle = @"user-content-Swift";
//        }
        if (tagTitle) {
            lastPlaceArray = [NSMutableArray array];
            [categoryDic setObject:lastPlaceArray forKey:tagTitle];
        }else{
            NSArray *child = elem.children;
            for (TFHppleElement *childNode in child) {
                
                if (!childNode.text || [childNode.text isEqualToString:@"原地址"] ||
                    [childNode.text isEqualToString:@"http://weekly.manong.io/"]) {
                    continue;
                }
                
                if ([childNode.tagName isEqualToString:@"a"]) {
                    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                    //转码
                    NSString *wkOriginUrl = childNode.attributes[@"href"];
                    NSString *wkName = [childNode.text stringByRemovingPercentEncoding];
                    if (wkName && wkOriginUrl) {
                        NSArray *urlArr = [wkOriginUrl componentsSeparatedByString:@"url="];
                        [data setObject:wkOriginUrl forKeyedSubscript:kUrl];
                        NSLog(@"wkName----%@",wkName);
                        [data setObject:wkName forKey:kName];
                        if (urlArr.count == 2) {
                            NSString *url = [urlArr[1] stringByRemovingPercentEncoding];
                            [data setObject:url forKey:kOriginUrl];
                        }else{
                            [data setObject:urlArr[0] forKey:kOriginUrl];
                        }
                        [lastPlaceArray addObject:data];
                    }
                }
            }
        }
    }
    
    return categoryDic;
}



@end
