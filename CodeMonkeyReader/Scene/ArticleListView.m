//
//  ArticleListView.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import "ArticleListView.h"

#import "ArticleListViewModel.h"

#import "ArticleCell.h"
#import <FlatUIKit/UIColor+FlatUI.h>

@interface ArticleListView()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) ArticleListViewModel *viewmodel;

@end

@implementation ArticleListView

- (instancetype)initWithViewModel:(ArticleListViewModel *)viewmodel{
    if (self = [super init]) {
        _viewmodel = viewmodel;
        [self createUIAndLayout];
    }
    return self;
}

- (void)createUIAndLayout{
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}

#pragma maek - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewmodel.articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"ArticleCell";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    [cell configureFlatCellWithColor:[UIColor turquoiseColor] selectedColor:[UIColor greenSeaColor] roundingCorners:UIRectCornerAllCorners];
    
    ReaderArtcle *article = _viewmodel.articles[indexPath.row];
    
    [cell configureCellWithModel:article];
    cell.contentView.backgroundColor = [UIColor randomColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Propotries

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



@end
