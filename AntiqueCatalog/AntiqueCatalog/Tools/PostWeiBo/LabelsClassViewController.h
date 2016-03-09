//
//  LabelsClassViewController.h
//  藏民网
//
//  Created by JingXiaoLiang on 15/5/10.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface LabelsClassViewController : BaseViewController

@property (nonatomic,retain)NSMutableDictionary *ZiDingYiDIC;
@property (nonatomic,retain)UIButton *ZiDingYiButton1;
@property (nonatomic,retain)UIButton *ZiDingYiButton2;
@property (nonatomic,retain)UIButton *ZiDingYiButton3;
@property (nonatomic,retain)UIButton *ZiDingYiButton4;
@property (nonatomic,retain)UIButton *ZiDingYiButton5;
@property (nonatomic,strong)NSMutableArray *selectArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withselectArray:(NSMutableArray *)selectArray;

@end
