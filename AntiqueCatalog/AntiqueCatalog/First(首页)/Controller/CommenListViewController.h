//
//  CommenListViewController.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "BaseViewController.h"
#import "AntiqueCatalogData.h"
#import "catalogdetailsdata.h"

@interface CommenListViewController : BaseViewController

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,strong) catalogdetailsdata * catalogData;

@end
