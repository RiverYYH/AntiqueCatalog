//
//  TopicSettingViewController.h
//  藏民网
//
//  Created by Hong on 15/3/25.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "LPActionSheetView.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface TopicSettingViewController : BaseViewController<UITextViewDelegate,LPActionSheetViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (id)initWithTopicId:(NSString *)topicId;
@end
