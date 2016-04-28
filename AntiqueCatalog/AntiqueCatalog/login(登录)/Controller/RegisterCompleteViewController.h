//
//  RegisterCompleteViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterCollectionViewCell.h"

@interface RegisterCompleteViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RegisterCollectionViewCellDelegate>

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andToken:(NSDictionary *)token;

@end
