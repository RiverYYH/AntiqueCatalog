//
//  PicturesWallViewController.h
//  藏民网
//
//  Created by Hong on 15/3/20.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface PicturesWallViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *topicName;
@end
