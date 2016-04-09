//
//  CatalogDetailsViewController.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "BaseViewController.h"
#import "AntiqueCatalogData.h"

@interface CatalogDetailsViewController : BaseViewController

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,strong) AntiqueCatalogData * catalogData;
@end
