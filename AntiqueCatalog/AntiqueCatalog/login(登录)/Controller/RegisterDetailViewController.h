//
//  RegisterDetailViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "LPActionSheetView.h"
#import <MobileCoreServices/MobileCoreServices.h>

typedef enum _ZhuCeType
{
    Phone=0,
    DiSanFang
    
} zhuceType;
@interface RegisterDetailViewController : BaseViewController<LPActionSheetViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    zhuceType _zhuceType;
    NSDictionary *_dic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPhone:(NSString *)phone andRegCode:(NSString *)regCode andDic:(NSDictionary *)dic andType:(zhuceType)type;

@end