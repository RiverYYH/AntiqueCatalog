//
//  InsertLocationViewController.h
//  RiseClub
//
//  Created by liuxiaoqing on 14-9-26.
//  Copyright (c) 2014年 huweihong. All rights reserved.
//

#import "BaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "LocationTableViewCell.h"
#import <AMapSearchKit/AMapCommonObj.h>
#import <CoreLocation/CoreLocation.h>

@protocol insertLocationDelegate <NSObject>

-(void)showLocation:(NSDictionary *)dic andIndex:(NSInteger)index andImagePath:(NSString *)filePath andImage:(UIImage *)image;

@end
@interface InsertLocationViewController : BaseViewController<CLLocationManagerDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate,UISearchBarDelegate>
{
	CLLocationManager *locManager;
    MAMapView *_mapView;
    AMapSearchAPI *search;
    UITableView *_tableView;
    UISearchBar *_searchBar;
    
}
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)id<insertLocationDelegate>delegate;
@property(nonatomic,copy)NSString *currentLocation;
@property(nonatomic,copy)NSString *selectAddress;
@property(nonatomic,copy)NSString *selectName;
@property(nonatomic)NSInteger selectIndex;

@property (nonatomic,assign) BOOL isPost;
@end
