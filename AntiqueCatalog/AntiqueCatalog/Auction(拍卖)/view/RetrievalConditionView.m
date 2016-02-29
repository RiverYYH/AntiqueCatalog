//
//  RetrievalConditionView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "RetrievalConditionView.h"

@interface RetrievalConditionView ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray *state;
@property (nonatomic,strong)NSMutableArray *year;
@property (nonatomic,strong)NSMutableArray *month;
@property (nonatomic,assign)CGPoint        point;
@property (nonatomic,strong)NSMutableArray *scrollViewarray;

@property (nonatomic,strong)UIButton       *statebtn;
@property (nonatomic,strong)UIButton       *authorbtn;
@property (nonatomic,strong)UIButton       *citybtn;
@property (nonatomic,strong)UIButton       *yearbtn;
@property (nonatomic,strong)UIButton       *monthbtn;

@end

@implementation RetrievalConditionView

+(instancetype)initWithauthor:(NSMutableArray *)authorArray andWithcity:(NSMutableArray *)cityArray{
    
    RetrievalConditionView *rcView = [[RetrievalConditionView alloc]initWithauthor:authorArray andWithcity:cityArray];
    return rcView;
    
}
-(instancetype)initWithauthor:(NSMutableArray *)authorArray andWithcity:(NSMutableArray *)cityArray{
    self = [super init];
    if (self) {
        _authorArray = authorArray;
        _cityArray = cityArray;
        _state = [[NSMutableArray alloc]init];
        _year = [[NSMutableArray alloc]init];
        _month = [[NSMutableArray alloc]init];
        _scrollViewarray = [[NSMutableArray alloc]init];
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI{
    
    _state = [NSMutableArray arrayWithObjects:@"全部",@"预展中",@"拍卖结束", nil];
    
    [_authorArray insertObject:@"全部" atIndex:0];
    [_cityArray insertObject:@"全部" atIndex:0];
    
    [_year addObject:@"全部"];
    [_month addObject:@"全部"];
    for (NSInteger a = 2015; a > 1990; a--) {
        [_year addObject:[NSString stringWithFormat:@"%ld",(long)a]];
    }
    for (NSInteger b = 12; b > 0; b--) {
        [_month addObject:[NSString stringWithFormat:@"%ld",(long)b]];
    }
    
    
    
    self.backgroundColor = [UIColor colorWithConvertString:@"#e4e4e4"];
    
    for (NSInteger i = 0; i < 5; i++) {
        _point = CGPointMake(0, 0);
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.frame = CGRectMake(0, i*(40+1), UI_SCREEN_WIDTH, 40);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor colorWithConvertString:@"#f5f5f5"];
        scrollView.scrollEnabled = YES;
        scrollView.tag = i;
        [self addSubview:scrollView];
        [_scrollViewarray addObject:scrollView];
        
        if (i == 0) {
            [_state enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:[_state objectAtIndex:idx] Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:Background_Color] WithcornerRadius:0 Withbold:YES];
                CGSize btnsize = [Allview string:[_state objectAtIndex:idx] Withfont:Catalog_Cell_info_Font WithCGSize:3000 Withview:button Withinteger:1];
                button.frame = CGRectMake(_point.x, 0, btnsize.width + 20, 40);
                button.tag = idx;
                UIScrollView *state = (UIScrollView *)_scrollViewarray[i];
                [state addSubview:button];
                [button addTarget:self action:@selector(stateClick:) forControlEvents:UIControlEventTouchUpInside];
                _point = CGPointMake(CGRectGetMaxX(button.frame), 0);
                if (idx == 0) {
                    button.selected = YES;
                    _statebtn = button;
                }
                if (idx == _state.count-1) {
                    state.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 0);
                }
            }];
        }
        if (i == 1) {
            [_authorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *titlestring;
                if (idx == 0) {
                    titlestring = _authorArray[idx];
                }else{
                    Authordata *authordata = _authorArray[idx];
                    titlestring = authordata.uname;
                }
                UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:titlestring Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:Background_Color] WithcornerRadius:0 Withbold:YES];
                CGSize btnsize = [Allview string:titlestring Withfont:Catalog_Cell_info_Font WithCGSize:3000 Withview:button Withinteger:1];
                button.frame = CGRectMake(_point.x, 0, btnsize.width + 20, 40);
                button.tag = idx;
                
                UIScrollView *author = (UIScrollView *)_scrollViewarray[i];
                [author addSubview:button];
                [button addTarget:self action:@selector(authorClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                _point = CGPointMake(CGRectGetMaxX(button.frame), 0);
                if (idx == 0) {
                    button.selected = YES;
                    _authorbtn = button;
                }
                if (idx == _authorArray.count-1) {
                    author.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 0);
                }
                
            }];
        }
        
        if (i == 2) {
            [_cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *titlestring;
                if (idx == 0) {
                    titlestring = _cityArray[idx];
                }else{
                    citydata *cityData = _cityArray[idx];
                    titlestring = cityData.title;
                }
                UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:titlestring Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:Background_Color] WithcornerRadius:0 Withbold:YES];
                CGSize btnsize = [Allview string:titlestring Withfont:Catalog_Cell_info_Font WithCGSize:3000 Withview:button Withinteger:1];
                button.frame = CGRectMake(_point.x, 0, btnsize.width + 20, 40);
                button.tag = idx;
                UIScrollView *city = (UIScrollView *)_scrollViewarray[i];
                [city addSubview:button];
                [button addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
                _point = CGPointMake(CGRectGetMaxX(button.frame), 0);
                if (idx == 0) {
                    button.selected = YES;
                    _citybtn = button;
                }
                if (idx == _cityArray.count-1) {
                    city.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 0);
                }
            }];
        }
        
        if (i == 3) {
            [_year enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:[_year objectAtIndex:idx] Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:Background_Color] WithcornerRadius:0 Withbold:YES];
                CGSize btnsize = [Allview string:[_year objectAtIndex:idx] Withfont:Catalog_Cell_info_Font WithCGSize:3000 Withview:button Withinteger:1];
                button.frame = CGRectMake(_point.x, 0, btnsize.width + 20, 40);
                button.tag = idx;
                UIScrollView *year = (UIScrollView *)_scrollViewarray[i];
                [year addSubview:button];
                [button addTarget:self action:@selector(yearClick:) forControlEvents:UIControlEventTouchUpInside];
                _point = CGPointMake(CGRectGetMaxX(button.frame), 0);
                if (idx == 0) {
                    button.selected = YES;
                    _yearbtn = button;
                }
                if (idx == _year.count - 1) {
                    scrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 0);
                }
                scrollView.hidden = YES;
            }];
        }

        
        if (i == 4) {
            [_month enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *titlestring;
                if (idx == 0) {
                    titlestring = _month[idx];
                }else{
                    titlestring = [NSString stringWithFormat:@"%@月",_month[idx]];
                }

                UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:titlestring Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:Background_Color] WithcornerRadius:0 Withbold:YES];
                CGSize btnsize = [Allview string:titlestring Withfont:Catalog_Cell_info_Font WithCGSize:3000 Withview:button Withinteger:1];
                button.frame = CGRectMake(_point.x, 0, btnsize.width + 20, 40);
                button.tag = idx;
                UIScrollView *month = (UIScrollView *)_scrollViewarray[i];
                [month addSubview:button];
                [button addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
                _point = CGPointMake(CGRectGetMaxX(button.frame), 0);
                if (idx == 0) {
                    button.selected = YES;
                    _monthbtn = button;
                }
                if (idx == _month.count-1) {
                    month.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 0);
                }
                scrollView.hidden = YES;
            }];
        }

    }
    
}

- (void)stateClick:(UIButton *)button{
    
    if (_statebtn != button) {
        switch (button.tag) {
            case 0:
            {
                UIScrollView *scrollViewyear = (UIScrollView *)_scrollViewarray[3];
                scrollViewyear.hidden = YES;
                UIScrollView *scrollViewmonth = (UIScrollView *)_scrollViewarray[4];
                scrollViewmonth.hidden = YES;
            }
   
            case 1:
            {
                UIScrollView *scrollViewyear = (UIScrollView *)_scrollViewarray[3];
                scrollViewyear.hidden = YES;
                UIScrollView *scrollViewmonth = (UIScrollView *)_scrollViewarray[4];
                scrollViewmonth.hidden = YES;
                
                
            }
                break;
            case 2:
            {
                UIScrollView *scrollViewyear = (UIScrollView *)_scrollViewarray[3];
                scrollViewyear.hidden = NO;
                UIScrollView *scrollViewmonth = (UIScrollView *)_scrollViewarray[4];
                
                if (_yearbtn.tag == 0) {
                    scrollViewmonth.hidden = YES;
                }else{
                    scrollViewmonth.hidden = NO;
                }
            }
                break;

                
            default:
                break;
        }
        _statebtn.selected = NO;
        button.selected = YES;
        _statebtn = button;
        if (_delegate &&[_delegate respondsToSelector:@selector(hanstate:)]) {
            [_delegate hanstate:button.tag];
        }
    }
    
}

- (void)authorClick:(UIButton *)button{
    
    if (_authorbtn != button) {
        _authorbtn.selected = NO;
        button.selected = YES;
        _authorbtn = button;
        
        if (_delegate &&[_delegate respondsToSelector:@selector(hanauthor:)]) {
            [_delegate hanauthor:_authorArray[button.tag]];
        }
    }
    
}

- (void)cityClick:(UIButton *)button{
    if (_citybtn != button) {
        _citybtn.selected = NO;
        button.selected = YES;
        _citybtn = button;
        
        if (_delegate &&[_delegate respondsToSelector:@selector(hancity:)]) {
            [_delegate hancity:_cityArray[button.tag]];
        }
    }
}

- (void)yearClick:(UIButton *)button{
    if (_yearbtn != button) {
        _yearbtn.selected = NO;
        button.selected = YES;
        _yearbtn = button;
        
        UIScrollView *scrollViewmonth = (UIScrollView *)_scrollViewarray[4];
        if (button.tag == 0) {
            scrollViewmonth.hidden = YES;
        }else{
            scrollViewmonth.hidden = NO;
        }
        if (_delegate &&[_delegate respondsToSelector:@selector(hanyear:andint:)]) {
            [_delegate hanyear:_year[button.tag] andint:_yearbtn.tag];
        }
    }
    
}

- (void)monthClick:(UIButton *)button{
    if (_monthbtn != button) {
        _monthbtn.selected = NO;
        button.selected = YES;
        _monthbtn = button;
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(hanmonth:andint:)]) {
        [_delegate hanmonth:_month[button.tag] andint:_monthbtn.tag];
    }
}

@end
