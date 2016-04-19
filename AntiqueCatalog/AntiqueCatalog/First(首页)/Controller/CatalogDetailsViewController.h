//
//  CatalogDetailsViewController.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "BaseViewController.h"
#import "AntiqueCatalogData.h"
@protocol CatalogDetailsViewControllerDelegate
-(void)addDataTowDownList:(NSDictionary*)dataDict;
-(void)addFOFQueues:(NSArray*)listDict withFileName:(NSString*)name withId:(NSString*)fileId;

@end

@interface CatalogDetailsViewController : BaseViewController

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,strong) AntiqueCatalogData * catalogData;
@property (nonatomic,assign)id<CatalogDetailsViewControllerDelegate> delegate;

@end
