//
//  SCCaptureCameraController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCaptureSessionManager.h"
#import "ZYQAssetPickerController.h"
#import "UzysAssetsPickerController.h"


@interface SCCaptureCameraController : UIViewController<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UzysAssetsPickerControllerDelegate>

@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;
@property (nonatomic, assign) BOOL isPost2;


@end
