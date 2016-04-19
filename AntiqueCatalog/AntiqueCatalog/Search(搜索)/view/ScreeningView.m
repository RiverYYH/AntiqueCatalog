//
//  ScreeningView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/23.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ScreeningView.h"
#import "ScreenscrollView.h"
#import "CatalogCategorydata.h"
#import "UsingDateModel.h"
#define Screen_width 40
#define line_width   60

@interface ScreeningView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIView          *bgView;
@property (nonatomic,strong)UIScrollView    *scrollView;
@property (nonatomic,strong)UITableView     *ArtTableView;
@property (nonatomic,strong)UITableView     *AuctionTableView;

@property (nonatomic,strong)UIView          *menuView;
@property (nonatomic,strong)UIButton        *yishu;
@property (nonatomic,strong)UIButton        *paimai;
@property (nonatomic,strong)UIImageView     *line;

@property (nonatomic,strong)UIView          *bottomView;
@property (nonatomic,strong)UIButton        *chongzhi;
@property (nonatomic,strong)UIButton        *sure;

@property (nonatomic,strong)NSMutableArray  *titlebuttonarray;

@property (nonatomic,strong)UIScrollView    *auctionScrollView;
@property (nonatomic,strong)UIView          *authorView;
@property (nonatomic,strong)NSMutableArray  *authorbutton;

@property (nonatomic,strong)UIView          *cityView;
@property (nonatomic,strong)NSMutableArray  *citybutton;

@property (nonatomic,assign)CGFloat         height;
@property (nonatomic,strong)UIButton        *Lablebutton;

@property (nonatomic,assign)CGFloat         authorheight;
@property (nonatomic,assign)CGFloat         cityheight;

@property (nonatomic,strong) UIView  *   startTimeView;
@property (nonatomic,strong) UILabel *  startTimeLabel;
@property (nonatomic,strong) UIView  *   endTimeView;
@property (nonatomic,strong) UILabel *  endTimeLabel;
@property (nonatomic,strong) NSString * currSelectTime;//当前点击的是开始时间OR结束时间标记
@property (nonatomic,strong) UIView * timeChooseView;

@property (nonatomic,strong)UIView          *pickView;

@property (nonatomic,strong)NSMutableArray  *yeararray;
@property (nonatomic,strong)NSMutableArray  *montharray;

@property (nonatomic,copy)NSString          *year;
@property (nonatomic,copy)NSString          *month;
@property (strong,nonatomic) NSString * currStartTime;
@property (strong,nonatomic) NSString * currEndTime;

@end

@implementation ScreeningView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _titlebuttonarray = [[NSMutableArray alloc]init];
        _authorbutton = [[NSMutableArray alloc]init];
        _citybutton = [[NSMutableArray alloc]init];
        _yeararray = [[NSMutableArray alloc]init];
        _montharray = [[NSMutableArray alloc]init];
    }
    return self;

}

- (void)CreatUI{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    NSDate *newdata = [NSDate date];
    // 修改默认时区会影响时间的输出显示
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]]; // 只能够修改该程序的defaultTimeZone，不能修改系统的，更不能修改其他程序的。
    NSInteger year;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *weekdayComponents = [gregorian components:NSHourCalendarUnit fromDate:_date];
    //    NSInteger _weekday = [weekdayComponents hour];
    //    NSLog(@"_weekday::%ld",(long)_weekday);
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [gregorian components:unitFlags fromDate:newdata];
    year = [comps year];
    
    for (NSInteger i = 1991; i < year+1; i ++) {
        
        [_yeararray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        
    }
    for (NSInteger i = 1; i < 13; i ++) {
        [_montharray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    _year = [_yeararray objectAtIndex:0];
    _month = [_montharray objectAtIndex:0];
//    _startyear = [_yeararray objectAtIndex:0];
//    _startmonth = [_montharray objectAtIndex:0];
//    _endyear = [_yeararray objectAtIndex:_yeararray.count - 1];
//    _endmonth = [_montharray objectAtIndex:_montharray.count - 1];
    
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(Screen_width, 0, UI_SCREEN_WIDTH - Screen_width, UI_SCREEN_HEIGHT - 20)];
    _bgView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [self addSubview:_bgView];
    
    UILabel *titleLabel = [Allview Withstring:@"筛选" Withcolor:Deputy_Colour Withbgcolor:White_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - Screen_width, 40);
    
    [_bgView addSubview:titleLabel];
    

//初始化 菜单类别部分的 VIEW
    _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 12, UI_SCREEN_WIDTH - Screen_width, 40)];
    _menuView.backgroundColor = White_Color;
    [_bgView addSubview:_menuView];
//------------------------------------------------
    
//初始化 内容部分的 SCROLLVIEW
    _scrollView = [[ScreenscrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuView.frame) +12, UI_SCREEN_WIDTH - 40, _bgView.frame.size.height - 144)];
    _scrollView.contentSize = CGSizeMake((UI_SCREEN_WIDTH - 40)*2, 0);
    _scrollView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_bgView addSubview:_scrollView];
//------------------------

//初始化 菜单类别部分的 按钮
    if([self.type isEqualToString:@"1"]){
        _yishu = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"艺术图录" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
        _yishu.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH - Screen_width), 40);
        _scrollView.scrollEnabled = NO;
    }else if ([self.type isEqualToString:@"0"]){
        _paimai = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"拍卖图录" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
        _paimai.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH - Screen_width), 40);
        [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH - Screen_width, 0) animated:NO];
        _scrollView.scrollEnabled = NO;
    }else{
        _yishu = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"艺术图录" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
        _yishu.selected = YES;
        _yishu.tag = 1;
        [_yishu addTarget:self action:@selector(menuclick:) forControlEvents:UIControlEventTouchUpInside];
        _yishu.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH - Screen_width)/2, 40);
        
        _paimai = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"拍卖图录" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
        [_paimai addTarget:self action:@selector(menuclick:) forControlEvents:UIControlEventTouchUpInside];
        _paimai.tag = 2;
        _paimai.frame = CGRectMake((UI_SCREEN_WIDTH - Screen_width)/2, 0, (UI_SCREEN_WIDTH - Screen_width)/2, 40);
        
        _line = [[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-Screen_width)/4 - line_width/2, 37, line_width, 3)];
        _line.backgroundColor = Blue_color;
        [_menuView addSubview:_line];
        _scrollView.scrollEnabled = YES;
    }
    
    [_menuView addSubview:_yishu];
    [_menuView addSubview:_paimai];
//------------------------------------------------

//初始化 底部重置 确定 按钮的背景VIEW
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.frame.size.height - 40, UI_SCREEN_WIDTH - Screen_width, 40)];
    _bottomView.backgroundColor = White_Color;
    [_bgView addSubview:_bottomView];
    
    _chongzhi = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"重置" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Nav_title_font WithBgcolor:[UIColor colorWithConvertString:@"#87d4f1"] WithcornerRadius:4 Withbold:YES];
    [_chongzhi addTarget:self action:@selector(bottomclick:) forControlEvents:UIControlEventTouchUpInside];
    _chongzhi.tag = 1;
    _chongzhi.frame = CGRectMake(UI_SCREEN_WIDTH - 40 -200 - 2, 0, 100, 40);
    
    _sure = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"确定" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Nav_title_font WithBgcolor:Blue_color WithcornerRadius:4 Withbold:YES];
    [_sure addTarget:self action:@selector(bottomclick:) forControlEvents:UIControlEventTouchUpInside];
    _sure.tag = 2;
    _sure.frame = CGRectMake(UI_SCREEN_WIDTH -40 - 100 , 0, 100, 40);
    
    [_bottomView addSubview:_chongzhi];
    [_bottomView addSubview:_sure];
//----------------------------------
    
    //艺术
    _ArtTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-40, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _ArtTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _ArtTableView.separatorColor = Clear_Color;
    _ArtTableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _ArtTableView.delegate = self;
    _ArtTableView.dataSource = self;
    [_scrollView addSubview:_ArtTableView];
    
//    _AuctionTableView = [[UITableView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-40, 0, UI_SCREEN_WIDTH-40, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
//    _AuctionTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _AuctionTableView.separatorColor = Clear_Color;
//    _AuctionTableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
//    _ArtTableView.delegate = self;
//    _ArtTableView.dataSource = self;
//    [_scrollView addSubview:_AuctionTableView];
    //拍卖
    _auctionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40, 0, UI_SCREEN_WIDTH - 40, _scrollView.frame.size.height - 10)];
    _auctionScrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height);
    _auctionScrollView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [_scrollView addSubview:_auctionScrollView];
    
/*
    _pickView = [[UIView alloc]init];
    _pickView.backgroundColor = White_Color;
    [_auctionScrollView addSubview:_pickView];
    
    _pickstart = [[UIPickerView alloc]init];
    _pickstart.frame = CGRectMake(10, 30, (UI_SCREEN_WIDTH - 80)/2, 216);
    _pickstart.delegate = self;
    _pickstart.dataSource = self;
    [_pickView addSubview:_pickstart];
    
    
    _pickend = [[UIPickerView alloc]init];
    _pickend.frame = CGRectMake((UI_SCREEN_WIDTH - 80)/2 + 30, 30, (UI_SCREEN_WIDTH - 80)/2, 216);
    _pickend.delegate = self;
    _pickend.dataSource = self;
    [_pickView addSubview:_pickend];
    
    UILabel *zhi = [Allview Withstring:@"至" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    zhi.frame = CGRectMake((UI_SCREEN_WIDTH - 80)/2 + 10, 133, 20, 10);
    [_pickView addSubview:zhi];
    
    UILabel *headtitle = [Allview Withstring:@"时间" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    headtitle.frame = CGRectMake(8, 0, 100, 30);
    [_pickView addSubview:headtitle];
*/
}

- (void)reloadtable{
    [_ArtTableView reloadData];
}

- (void)reloadaution{
    
    //NSLog(@"%@",_city);
    
    if (_authorView == nil) {
        
        if (ARRAY_NOT_EMPTY(_author)) {
            _authorView = [[UIView alloc]init];
            _authorView.backgroundColor = White_Color;
            [_auctionScrollView addSubview:_authorView];
            
            UILabel *label = [Allview Withstring:@"拍卖行" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(8, 0, 100, 32);
            [_authorView addSubview:label];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40 - 32, 0, 32, 32)];
            [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
            btn.tag = 1;
            btn.selected = NO;
            [btn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
            [_authorView addSubview:btn];
            
            NSInteger iconCount = [_author count];
            NSInteger k = 0;
            CGPoint point_button[k];
            for (NSInteger i=0; i<(iconCount-1)/3+1; i++)
            {
                for (NSInteger j=0; j<3; j++)
                {
                    if (k < iconCount)
                    {
                        point_button[k] = CGPointMake(8+(UI_SCREEN_WIDTH - 72)/3/2+j*((UI_SCREEN_WIDTH - 72)/3+8),32+i*48 + 20);
                        
                        _Lablebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                        _Lablebutton.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-72)/3.0, 40);
                        _Lablebutton.center = point_button[k];
                        _Lablebutton.tag = k;
                        _Lablebutton.titleLabel.lineBreakMode = 0;
                        _Lablebutton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _Lablebutton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                        [_Lablebutton setTitle:[[_author objectAtIndex:k] objectForKey:@"uname"]  forState:UIControlStateNormal];
                        
                        
                        [_Lablebutton setTitleColor:Deputy_Colour forState:UIControlStateNormal];
                        [_Lablebutton setTitleColor:White_Color forState:UIControlStateSelected];
                        
                        [_Lablebutton setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                        [_Lablebutton addTarget:self action:@selector(authorClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        if (k > 5) {
                            _Lablebutton.hidden = YES;
                        }

                        [_authorView addSubview:_Lablebutton];
                        [_authorbutton addObject:_Lablebutton];
                        if (k == _author.count - 1) {
                            _authorView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, CGRectGetMaxY(_Lablebutton.frame)+8);
                            _height = CGRectGetMaxY(_authorView.frame) + 10;
                        }
                        k++;
                        
                        
                    }
                }
            }
            if (_author.count > 6) {
                _authorView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, 32+48*2);
                _height = CGRectGetMaxY(_authorView.frame) + 10;
            }

        }
        
        
    }
    
    if (_cityView == nil) {
        
        if (ARRAY_NOT_EMPTY(_city)) {
            _cityView = [[UIView alloc]init];
            _cityView.backgroundColor = White_Color;
            [_auctionScrollView addSubview:_cityView];
            
            UILabel *label = [Allview Withstring:@"地点" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(8, 0, 100, 32);
            [_cityView addSubview:label];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40 - 32, 0, 32, 32)];
            [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
            btn.tag = 2;
            btn.selected = NO;
            [btn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
            [_cityView addSubview:btn];
            
            NSInteger iconCount = [_city count];
            NSInteger k = 0;
            CGPoint point_button[k];
            
            for (NSInteger i=0; i<(iconCount-1)/3+1; i++)
            {
                for (NSInteger j=0; j<3; j++)
                {
                    if (k < iconCount)
                    {
                        point_button[k] = CGPointMake(8+(UI_SCREEN_WIDTH - 72)/3/2+j*((UI_SCREEN_WIDTH - 72)/3+8),32+i*48 + 20);
                        
                        _Lablebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                        _Lablebutton.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-72)/3.0, 40);
                        _Lablebutton.center = point_button[k];
                        _Lablebutton.tag = k;
                        _Lablebutton.titleLabel.lineBreakMode = 0;
                        _Lablebutton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _Lablebutton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                        [_Lablebutton setTitle:[[_city objectAtIndex:k] objectForKey:@"title"]  forState:UIControlStateNormal];
                        
                        
                        [_Lablebutton setTitleColor:Deputy_Colour forState:UIControlStateNormal];
                        [_Lablebutton setTitleColor:White_Color forState:UIControlStateSelected];
                        
                        [_Lablebutton setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                        [_Lablebutton addTarget:self action:@selector(cityClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [_cityView addSubview:_Lablebutton];
                        [_citybutton addObject:_Lablebutton];
                        
                        if (k > 5) {
                            _Lablebutton.hidden = YES;
                        }
                        
                        if (k == _city.count - 1) {
                            _cityView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) +10, UI_SCREEN_WIDTH - 40, CGRectGetMaxY(_Lablebutton.frame)+8);
                            _height = CGRectGetMaxY(_cityView.frame) + 10;
                        }
                        k++;
                        
                        
                    }
                }
            }
            
            if (_city.count > 6) {
                _cityView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) +10, UI_SCREEN_WIDTH - 40, 32+48*2);
                _height = CGRectGetMaxY(_cityView.frame) + 10;
                
            }
            
        }
 
    }
    
    if(self.startTimeView == nil){
        _startTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cityView.frame) + 10, UI_SCREEN_WIDTH - Screen_width, 40)];
        _startTimeView.backgroundColor = White_Color;
        UILabel * T_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        T_Label.text = @"开始时间";
        T_Label.font = [UIFont systemFontOfSize:15];
        T_Label.textAlignment = NSTextAlignmentCenter;
        T_Label.textColor = Deputy_Colour;
        [_startTimeView addSubview:T_Label];
        
        if(_startTimeLabel){
            [_startTimeLabel removeFromSuperview];
            _startTimeLabel = nil;
        }
        _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(T_Label.frame), 0, _startTimeView.bounds.size.width - T_Label.bounds.size.width, 40)];
        _startTimeLabel.font = [UIFont systemFontOfSize:15];
        _startTimeLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeLabel.textColor = Deputy_Colour;
        [_startTimeView addSubview:_startTimeLabel];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = _startTimeView.bounds;
        button.tag = 11;
        [button addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_startTimeView addSubview:button];
        
        [_auctionScrollView addSubview:_startTimeView];
    }
    
    if(self.endTimeView == nil){
        _endTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_startTimeView.frame) + 10, UI_SCREEN_WIDTH - Screen_width, 40)];
        _endTimeView.backgroundColor = White_Color;
        UILabel * T_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        T_Label.text = @"结束时间";
        T_Label.font = [UIFont systemFontOfSize:15];
        T_Label.textAlignment = NSTextAlignmentCenter;
        T_Label.textColor = Deputy_Colour;
        [_endTimeView addSubview:T_Label];
        
        
        if(_endTimeLabel){
            [_endTimeLabel removeFromSuperview];
            _endTimeLabel = nil;
        }
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(T_Label.frame), 0, _endTimeView.bounds.size.width - T_Label.bounds.size.width, 40)];
        _endTimeLabel.font = [UIFont systemFontOfSize:15];
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeLabel.textColor = Deputy_Colour;
        [_endTimeView addSubview:_endTimeLabel];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = _endTimeView.bounds;
        button.tag = 12;
        [button addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_endTimeView addSubview:button];
        
        [_auctionScrollView addSubview:_endTimeView];
    }
    
/*
    _pickView.frame = CGRectMake(0, _height + 10, UI_SCREEN_WIDTH - 40, 256);
    
    if (CGRectGetMaxY(_pickView.frame) > UI_SCREEN_HEIGHT - 164) {
        _auctionScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_pickView.frame) + 10);
    }
*/
}
-(void)timeButtonClick:(UIButton*)sender{
    self.timeChooseView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH - Screen_width, UI_SCREEN_HEIGHT - 20)];
    _timeChooseView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [self CreateTimeChooseView];
    [self addSubview:_timeChooseView];
    
    if(sender.tag == 11){
        self.currSelectTime = @"startTime";
    }else if (sender.tag == 12){
        self.currSelectTime = @"endTime";
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.timeChooseView.frame;
        rect.origin.x = 40;
        self.timeChooseView.frame =rect;
    }];
}
- (void)menuclick:(UIButton *)button{
    
    if (button.tag == 1 && _yishu.selected == NO) {
        _yishu.selected = YES;
        _paimai.selected = NO;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            _line.frame = CGRectMake((UI_SCREEN_WIDTH-Screen_width)/4 - line_width/2, 37, line_width, 3);
        }];
        
        
    }else if (button.tag == 2 && _paimai.selected == NO){
        _yishu.selected = NO;
        _paimai.selected = YES;
        [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH - Screen_width, 0) animated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            _line.frame = CGRectMake((UI_SCREEN_WIDTH-Screen_width)/4*3 - line_width/2, 37, line_width, 3);
        }];
        
    }
    
}

- (void)bottomclick:(UIButton *)btn
{
    if (btn.tag == 1) {
        
        if (_yishu.selected) {
            [_titlebuttonarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                button.selected = NO;
                
            }];
        }else{
            [_authorbutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                button.selected = NO;
                [button setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                //[btn setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                
            }];
            [_citybutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                button.selected = NO;
                [button setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                //[btn setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
                
            }];
            self.startTimeLabel.text = @"";
            self.currStartTime = nil;
            self.endTimeLabel.text = @"";
            self.currEndTime = nil;
        }
        [btn setTitleColor:White_Color forState:UIControlStateNormal];
        [btn setTitleColor:White_Color forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor colorWithConvertString:@"#87d4f1"]];
    }else{
        
        if (_yishu.selected) {
            
            NSMutableArray *mutarray = [[NSMutableArray alloc]init];
            
            [_titlebuttonarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                if (button.selected == YES) {
                    [mutarray addObject:[_titleArray objectAtIndex:button.tag]];
                }
                
            }];
            
            __block NSString *categorystr;
            [mutarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CatalogCategorydata *catalogcategory = _titleArray[idx];
                if (idx == 0) {
                    categorystr = [NSString stringWithFormat:@"%@",catalogcategory.ID];
                }else{
                    categorystr = [NSString stringWithFormat:@"%@,%@",categorystr,catalogcategory.ID];
                }
                
            }];
//            NSLog(@"%@",categorystr);
            NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:categorystr,@"category", nil];
            
            if (_delegate && [_delegate respondsToSelector:@selector(sure:andWithint:)]) {
                [_delegate sure:mutdic andWithint:1];
            }
            [UIView animateWithDuration:0.5 animations:^{
                
                self.frame = CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20);
                
            } completion:^(BOOL finished) {
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            }];
            
        }else{
            
            NSMutableArray *mutarray = [[NSMutableArray alloc]init];
            
            [_authorbutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                if (button.selected == YES) {
                    [mutarray addObject:[_author objectAtIndex:button.tag]];
                }
                
            }];
            
            __block NSString *authorstr;
            [mutarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = mutarray[idx];
                if (idx == 0) {
                    authorstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
                }else{
                    authorstr = [NSString stringWithFormat:@"%@,%@",authorstr,[dic objectForKey:@"uid"]];
                }
                
            }];
            
            NSMutableArray *mutarray1 = [[NSMutableArray alloc]init];
            
            [_citybutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIButton *button = obj;
                if (button.selected == YES) {
                    [mutarray1 addObject:[_city objectAtIndex:button.tag]];
                }
                
            }];
            
            __block NSString *citystr;
            [mutarray1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = mutarray1[idx];
                if (idx == 0) {
                    citystr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"area_id"]];
                }else{
                    citystr = [NSString stringWithFormat:@"%@,%@",authorstr,[dic objectForKey:@"area_id"]];
                }
                
            }];
            
            
            NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]init];
            NSString *theTime;
            
            if ([_month integerValue] < 10) {
                theTime = [UserModel toformateTime:[NSString stringWithFormat:@"%@-0%@-01 00:00:00",_year,_month]];
            }else{
                theTime = [UserModel toformateTime:[NSString stringWithFormat:@"%@-%@-01 00:00:00",_year,_month]];
            }
            
            //[mutdic setValue:theTime forKey:@"theTime"];
            
            if (authorstr.length > 0) {
                [mutdic setValue:authorstr forKey:@"uid"];
            }
            
            if (citystr.length > 0) {
                [mutdic setValue:citystr forKey:@"city"];
            }
            if (self.currStartTime) {
                mutdic[@"stime"] = [UsingDateModel countNSString_time1970WithTime:self.currStartTime];
            }
            
            if(self.currEndTime){
                mutdic[@"ntime"] =[UsingDateModel countNSString_time1970WithTime:self.currEndTime];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(sure:andWithint:)]) {
                [_delegate sure:mutdic andWithint:2];
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.frame = CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20);
                
            } completion:^(BOOL finished) {
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            }];
            
        }
        
        
        
    }
}

- (void)authorClicked:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
        
    }else{
        btn.selected = YES;
        [btn setBackgroundColor:Blue_color];
    }
}

- (void)cityClicked:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithConvertString:Background_Color]];
        
    }else{
        btn.selected = YES;
        [btn setBackgroundColor:Blue_color];
    }
}

- (void)moreClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 1:
        {
            if (_author.count > 5) {
                if (btn.selected) {
                    btn.selected = NO;
                    [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                    
                    [_authorbutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx > 5) {
                            UIButton *btn = obj;
                            btn.hidden = YES;
                        }
                        
                    }];
                    _authorView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, 32+ 48*2);
                    
                }else{
                    btn.selected = YES;
                    [btn setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
                    [_authorbutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIButton *btn = obj;
                        btn.hidden = NO;
                    }];
                    
                    _authorView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, 32+ 48*((_author.count-1)/3+1));
                }
                if (_city.count > 0) {
                    _cityView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) + 10, UI_SCREEN_WIDTH - 40, _cityView.frame.size.height);
                    //_pickView.frame = CGRectMake(0, CGRectGetMaxY(_cityView.frame) + 10, UI_SCREEN_WIDTH - 40, 256);
                }else{
                   // _pickView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) + 10, UI_SCREEN_WIDTH - 40, 256);
                    
                }
                /*
                if (CGRectGetMaxY(_pickView.frame) > UI_SCREEN_HEIGHT - 164) {
                    _auctionScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_pickView.frame) + 10);
                }
                 */

            }
            
        }
            break;
        case 2:
        {
            if (_city.count > 5) {
                
                if (btn.selected) {
                    btn.selected = NO;
                    [btn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                    [_citybutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx > 5) {
                            UIButton *btn = obj;
                            btn.hidden = YES;
                        }
                        
                    }];
                    _cityView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) + 10, UI_SCREEN_WIDTH - 40, 32+ 48*2);
                    
                }else{
                    btn.selected = YES;
                    [btn setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
                    [_citybutton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIButton *btn = obj;
                        btn.hidden = NO;
                    }];
                    
                    _cityView.frame = CGRectMake(0, CGRectGetMaxY(_authorView.frame) + 10, UI_SCREEN_WIDTH - 40, 32+ 48*((_city.count-1)/3+1));
                    
                    
                }
                /*
                _pickView.frame = CGRectMake(0, CGRectGetMaxY(_cityView.frame) + 10, UI_SCREEN_WIDTH - 40, 256);
                if (CGRectGetMaxY(_pickView.frame) > UI_SCREEN_HEIGHT - 164) {
                    _auctionScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_pickView.frame) + 10);
                }
                */
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
           CGPoint panpoint = [recognizer translationInView:self];
            if (panpoint.x>0) {
                
                if(self.timeChooseView){

                }else{
                    [UIView animateWithDuration:0.0 animations:^{
                        
                        self.frame = CGRectMake(panpoint.x, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20);
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint panpoint = [recognizer translationInView:self];
            if (panpoint.x>0){
                if(self.timeChooseView){
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        self.timeChooseView.frame = CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH-40, UI_SCREEN_HEIGHT - 20);
                        
                    } completion:^(BOOL finished) {
                        [self.timeChooseView removeFromSuperview];
                        self.timeChooseView = nil;
                    }];
                }else{
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        self.frame = CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20);
                        
                    } completion:^(BOOL finished) {
                        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                    }];
                }
            }
            
            
            
        }
            break;
            
        default:
            break;
    }
   
}

-(void)CreateTimeChooseView{
    UIButton * leftButton;
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton setTitleColor:White_Color forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(timeViewleftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeChooseView addSubview:leftButton];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH - Screen_width, 40)];
    titleView.backgroundColor = White_Color;
    UILabel * T_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    T_Label.text = @"开始时间";
    T_Label.font = [UIFont systemFontOfSize:15];
    T_Label.textAlignment = NSTextAlignmentCenter;
    T_Label.textColor = Deputy_Colour;
    [titleView addSubview:T_Label];
    [_timeChooseView addSubview:titleView];
    
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame)+10, UI_SCREEN_WIDTH - 40, 256)];
    _pickView.backgroundColor = [UIColor whiteColor];
    [_timeChooseView addSubview:_pickView];
    
    UIPickerView * picktime = [[UIPickerView alloc]init];
    picktime.frame = CGRectMake(10, 0, (UI_SCREEN_WIDTH - 50), 216);
    picktime.delegate = self;
    picktime.dataSource = self;
    [_pickView addSubview:picktime];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, CGRectGetMaxY(_pickView.frame), UI_SCREEN_WIDTH - 40, 40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:Blue_color forState:UIControlStateNormal];
    [button setBackgroundColor:White_Color];
    [button addTarget:self action:@selector(timeChooseViewOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeChooseView addSubview:button];
}

-(void)timeChooseViewOKButtonClick:(UIButton*)sender{
    if([self.currSelectTime isEqualToString:@"startTime"]){
        self.currStartTime = [NSString stringWithFormat:@"%@-%@-1 00:00:00",_year,_month];
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@年%@月",_year,_month];
    }else if ([self.currSelectTime isEqualToString:@"endTime"]){
        self.currEndTime = [NSString stringWithFormat:@"%@-%@-15 23:59:59",_year,_month];
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@年%@月",_year,_month];
    }
    NSLog(@"---self.currStartTime===%@",_currStartTime);
    NSLog(@"---self.currEndTime===%@",_currEndTime);
    [self timeViewleftButtonClick:nil];
}

-(void)timeViewleftButtonClick:(UIButton*)sender{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.timeChooseView.frame = CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH-40, UI_SCREEN_HEIGHT - 20);
        
    } completion:^(BOOL finished) {
        [self.timeChooseView removeFromSuperview];
        self.timeChooseView = nil;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        
        if (_scrollView.contentOffset.x == 0.f) {
            _yishu.selected = YES;
            _paimai.selected = NO;
            
            _line.frame = CGRectMake((UI_SCREEN_WIDTH-Screen_width)/4 - line_width/2, 37, line_width, 3);
            
        }else if (_scrollView.contentOffset.x == UI_SCREEN_WIDTH - Screen_width) {
            _yishu.selected = NO;
            _paimai.selected = YES;
            _line.frame = CGRectMake((UI_SCREEN_WIDTH-Screen_width)/4*3 - line_width/2, 37, line_width, 3);
        }
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _ArtTableView) {
        return 1;
    }else{
        
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _ArtTableView) {
        return _titleArray.count;
    }else{
        
        return 1;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ArtTableView) {
        
        static NSString *identifier = @"cellart";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ARRAY_NOT_EMPTY(_titleArray)) {
            
            CatalogCategorydata *catalogcategory = _titleArray[indexPath.row];
            UIImageView *lineimage = [[UIImageView alloc]init];
            lineimage.backgroundColor = [UIColor colorWithConvertString:Background_Color];
            lineimage.frame = CGRectMake(0, 39, UI_SCREEN_WIDTH - 40, 1);
            
            UIButton *titleButton = [[UIButton alloc]init];
            [titleButton setTitle:catalogcategory.title  forState:UIControlStateNormal];
            [titleButton setTitleColor:Deputy_Colour forState:UIControlStateNormal];
            [titleButton setTitleColor:Blue_color forState:UIControlStateSelected];
            titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            titleButton.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, 40);
            titleButton.titleLabel.font = [UIFont systemFontOfSize: Nav_title_font];
            [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0,50,0,0)];
            [titleButton addTarget:self action:@selector(titlebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            titleButton.tag = indexPath.row;
            
            if (_titlebuttonarray.count < _titleArray.count) {
                [_titlebuttonarray addObject:titleButton];
                [titleButton addSubview:lineimage];
                [cell addSubview:titleButton];
            }
    
        }
        return cell;
        
    }else{
        
        static NSString *identifier = @"cellart";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ARRAY_NOT_EMPTY(_titleArray)) {
            
        }
        return cell;

    }
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ArtTableView) {
        return 40.f;
    }else{
        return 1.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return _yeararray.count;
        }
            break;
        case 1:
        {
            return _montharray.count;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSString *yearstring = [_yeararray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@年",yearstring];
        }
            
            break;
        case 1:
        {
            NSString *yearstring = [_montharray objectAtIndex:row];
            return [NSString stringWithFormat:@"%@月",yearstring];
        }
            
            
            break;
            
        default:
            return  @"";
            break;
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
        switch (component) {
            case 0:
            {
                _year = [_yeararray objectAtIndex:row];
            }
                break;
            case 1:
            {
                _month = [_montharray objectAtIndex:row];
            }
                break;
                
            default:
                break;
        }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.font = [UIFont boldSystemFontOfSize:10];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)titlebuttonclick:(UIButton *)btn{
    
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
    
}


@end
