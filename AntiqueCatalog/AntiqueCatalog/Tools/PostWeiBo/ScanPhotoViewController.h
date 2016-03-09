//
//  ScanPhotoViewController.h
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/8/23.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import "BaseViewController.h"
#import "LPActionSheetView.h"

@protocol sendPhotoArrDelegate <NSObject>

-(void)sendPhotoArr:(NSArray *)array;

@end

@interface ScanPhotoViewController : BaseViewController<UIScrollViewDelegate,UINavigationBarDelegate,UIActionSheetDelegate,LPActionSheetViewDelegate>{
	int currentIndex,imgCount;
	UIScrollView *_scrollView;
}
@property(nonatomic,assign)id<sendPhotoArrDelegate>delegate;
@property (nonatomic,retain) NSMutableArray *imgArr;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL isPhoto;

@end
