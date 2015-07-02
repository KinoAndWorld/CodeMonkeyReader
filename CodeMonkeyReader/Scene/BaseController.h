//
//  BaseController.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BFKit/BFKit.h>

typedef enum {
    NavgationItemPositionLeft,
    NavgationItemPositionRight
}NavgationItemPosition;

@interface BaseController : UIViewController

- (UIButton *)setNavgationItemWithImage:(UIImage *)image position:(NavgationItemPosition)position;

- (void)startLoading;
- (void)stopLoading;

- (void)showSuccessMessage:(NSString *)msg;
- (void)showFailureMessage:(NSString *)msg;
- (void)showMessage:(NSString *)msg;

- (void)showServerErrorMessage;

@end
