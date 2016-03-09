//
//  PostWeiBoViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ExpressionView.h"
#import "InsertLocationViewController.h"
#import "LPActionSheetView.h"
//#import "LianXiRenViewController.h"
#import "UzysAssetsPickerController.h"
#import "SCNavigationController.h"
#import "ScanPhotoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PostTopicListViewController.h"

//@interface PostWeiBoViewController : BaseViewController<UITextViewDelegate,ExpressionViewDelegate,UIScrollViewDelegate,insertLocationDelegate,LPActionSheetViewDelegate,UzysAssetsPickerControllerDelegate,SCNavigationControllerDelegate,sendPhotoArrDelegate,CLLocationManagerDelegate,PostTopicListViewControllerDelegate,LianXiRenViewControllerDelegate>
@interface PostWeiBoViewController : BaseViewController<UITextViewDelegate,ExpressionViewDelegate,UIScrollViewDelegate,insertLocationDelegate,LPActionSheetViewDelegate,UzysAssetsPickerControllerDelegate,SCNavigationControllerDelegate,sendPhotoArrDelegate,CLLocationManagerDelegate,PostTopicListViewControllerDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPlaceText:(NSString *)placeText;
@property (nonatomic, copy) NSString *topicName;//从创建专辑页面进来的
@property (nonatomic, copy) NSString *tag;//区分是点击了文字还是图片或者照相进入界面
@property (nonatomic, strong) NSMutableArray *plazaArray;
@end
