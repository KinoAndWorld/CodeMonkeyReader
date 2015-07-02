//
//  ArticleListView.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import <UIKit/UIKit.h>

@class ArticleListViewModel;

@interface ArticleListView : UIView

@property (strong, nonatomic,readonly) UITableView *tableView;

- (instancetype)initWithViewModel:(ArticleListViewModel *)viewmodel;

@end
