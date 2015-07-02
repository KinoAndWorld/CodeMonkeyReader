//
//  ArticleListController.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import "ArticleListController.h"
#import "ArticleContentController.h"

#import "ReaderCategory.h"
#import "ArticleListViewModel.h"

//view
#import "ArticleListView.h"


@interface ArticleListController ()

@property (strong, nonatomic) ArticleListView *listView;

@end

@implementation ArticleListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_viewModel) {
         _viewModel = [[ArticleListViewModel alloc] init];
    }
    
    RACSignal *signal = [_viewModel fetchArticlesByMasterCategory];
    [signal subscribeNext:^(id x) {
        [_listView.tableView reloadData];
    } error:^(NSError *error) {
        BFLog(@"err =  %@",error);
    }];
    
    [self createUIAndLayout];
}

- (void)createUIAndLayout{
    RAC(self, title) = RACObserve(self.viewModel, masterCategory.name);
    
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    RACSignal *selectSignal = [self.listView
                               rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)];
    [selectSignal subscribeNext:^(RACTuple *x) {
        BFLog(@"eee%@  and  %@    %@", x.first, x.second, x.third);
        NSIndexPath *idp = x.second;
        
        ArticleContentController *dest = [[ArticleContentController alloc] init];
        dest.viewModel = [_viewModel articleContentViewModelAtIndex:idp.row];
        [self.navigationController pushViewController:dest animated:YES];
    }];
}

#pragma mark - Proporties

- (ArticleListView *)listView{
    if (!_listView) {
        _listView = [[ArticleListView alloc] initWithViewModel:_viewModel];
    }
    return _listView;
}

@end
