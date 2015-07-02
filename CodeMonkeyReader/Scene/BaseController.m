//
//  BaseController.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "BaseController.h"
#import <CSNotificationView.h>

#import "CodeMonkeyReader-Swift.h"

@interface BaseController ()

@property (strong, nonatomic) PinballLoadingView *loadingView;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIButton *)setNavgationItemWithImage:(UIImage *)image position:(NavgationItemPosition)position{
    UIButton *button;
    
    if (position == NavgationItemPositionLeft) {
        [self.navigationItem setLeftBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button setBackgroundImage:image forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }else{
        [self.navigationItem setRightBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                BFLog(@"= =");
            }];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }
    
    return button;
}

#pragma mark - UIStatus

- (void)startLoading{
    [self.loadingView showInWindow];
}

- (void)stopLoading{
    [self.loadingView stopAnimateAndDismiss];
}

- (void)showSuccessMessage:(NSString *)msg{
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleSuccess
                                     message:msg];
}


- (void)showFailureMessage:(NSString *)msg{
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleError
                                     message:msg];
}

- (void)showMessage:(NSString *)msg{
    [CSNotificationView showInViewController:self tintColor:[UIColor darkGrayColor]
                                       image:nil message:msg
                                    duration:1.0];
}

- (void)showServerErrorMessage{
    [self showMessage:@"服务器对我有意见~~(╯﹏╰)b"];
}

#pragma mark - getter

- (PinballLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[PinballLoadingView alloc] init];
        _loadingView.backColor = [UIColor cloudsColor];
    }
    return _loadingView;
}


@end
