//
//  HomeController.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "BaseController.h"

@class CategoryViewModel;

@interface HomeController : BaseController

- (instancetype)initWithViewModel:(CategoryViewModel *)viewModel;

@end
