//
//  DownListViewCell.h
//  AntiqueCatalog
//
//  Created by cssweb on 16/4/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AntiqueCatalogData.h"

@interface DownListViewCell : UITableViewCell
@property (nonatomic,strong)AntiqueCatalogData *antiquecatalogdata;
@property (nonatomic,strong) UILabel * downProsseLabel;
@property (nonatomic,strong) UILabel * downStatelabel;
@property (nonatomic,strong) UIButton * downBtn;
@property (nonatomic,strong) UIButton * deletBtn;
@end
