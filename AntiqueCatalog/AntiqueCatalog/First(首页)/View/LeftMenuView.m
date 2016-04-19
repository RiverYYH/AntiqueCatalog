//
//  LeftMenuView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/6.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "LeftMenuView.h"
#import "leftTableViewCell.h"

#define backgroundColor_alpha 0.8

@interface LeftMenuView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)BOOL ishidden;
@property (nonatomic,strong)UITableView *tableVeiw;

@property (nonatomic,strong)UIView      *bgView;
@property (nonatomic,strong)UIView      *userbgView;
@property (nonatomic,strong)UIButton    *loginBtn;
@property (nonatomic,strong)UIImageView *HeadPortrait;
@property (nonatomic,strong)UILabel     *name;
@property (nonatomic,strong)UILabel     *infor;
@property (nonatomic,assign)BOOL        isLogin;

@property (nonatomic,strong)NSArray     *array;

@end

@implementation LeftMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationloaduserinfo:) name:@"loaduserinfo" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationupatateHeadImage:) name:@"upatateHeadImage" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeView:) name:@"makeView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"LOGOUT" object:nil];
        _ishidden = YES;
        self.frame = frame;
        _array = @[@[@"艺术足迹",@"我的消息",@"邀请好友",@"编辑资料",@"下载列表"],@[@"设置"]];
        [self CreatUI];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loaduserinfo" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeView" object:nil];
}

- (void)makeView:(NSNotificationCenter *)obj{
    _name.text = [[UserModel userUserInfor] objectForKey:@"uname"];
    _infor.text = [[UserModel userUserInfor] objectForKey:@"intro"];
}

- (void)CreatUI{
    
    _isLogin = [UserModel checkLogin];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.userInteractionEnabled = YES;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [self addSubview:_bgView];
    
    _userbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, 182)];
    _userbgView.backgroundColor = Blue_color;
    [_bgView addSubview:_userbgView];
    
    _loginBtn = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"登录" Withcolor:Essential_Colour WithSelectcolor:Essential_Colour Withfont:Catalog_Cell_Name_Font WithBgcolor:White_Color WithcornerRadius:4 Withbold:YES];
    _loginBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 50)/2 - 40, 91-20, 80, 40);
    [_loginBtn addTarget:self action:@selector(loginclick:) forControlEvents:UIControlEventTouchUpInside];
    [_userbgView addSubview:_loginBtn];
    
    _HeadPortrait = [[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 50)/2 - 36, 32, 72, 72)];
    _HeadPortrait.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _HeadPortrait.layer.masksToBounds = YES;
    _HeadPortrait.layer.cornerRadius = 36;
    _HeadPortrait.layer.borderColor = White_Color.CGColor;
    _HeadPortrait.layer.borderWidth = 2.0;
    [_userbgView addSubview:_HeadPortrait];
    
    _name = [Allview Withstring:@"" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _name.frame = CGRectMake((UI_SCREEN_WIDTH - 50)/2 - 120, CGRectGetMaxY(_HeadPortrait.frame) + 16, 240, 15);
    [_userbgView addSubview:_name];
    
    _infor = [Allview Withstring:@"" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:Catalog_Cell_uname_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _infor.frame = CGRectMake(20, CGRectGetMaxY(_name.frame) + 8, (UI_SCREEN_WIDTH - 50) - 40, 15);
    [_userbgView addSubview:_infor];
    
    
    if (_isLogin) {
        
        _loginBtn.hidden = YES;
        _HeadPortrait.hidden = NO;
        _name.hidden = NO;
        _infor.hidden = NO;
        
        NSDictionary *dic = [UserModel userUserInfor];
        [_HeadPortrait sd_setImageWithURL:[dic objectForKey:@"avatar"]];
        _name.text = [dic objectForKey:@"uname"];
        _infor.text = [dic objectForKey:@"intro"];
        
    }else{
        
        _loginBtn.hidden = NO;
        _HeadPortrait.hidden = YES;
        _name.hidden = YES;
        _infor.hidden = YES;
        
    }
    
    
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 182+16, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableVeiw.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVeiw.showsHorizontalScrollIndicator=NO;
    _tableVeiw.showsVerticalScrollIndicator=NO;
    _tableVeiw.allowsMultipleSelection = NO;
    _tableVeiw.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
    [_bgView addSubview:_tableVeiw];


}

-(void)logout:(NSNotificationCenter*)notification{
    _isLogin = [UserModel checkLogin];
    
    if (_isLogin) {
        _loginBtn.hidden = YES;
        _HeadPortrait.hidden = NO;
        _name.hidden = NO;
        _infor.hidden = NO;
        
        NSDictionary *dic = [UserModel userUserInfor];
        [_HeadPortrait sd_setImageWithURL:[dic objectForKey:@"avatar"]];
        _name.text = [dic objectForKey:@"uname"];
        _infor.text = [dic objectForKey:@"intro"];
        
    }else{
        
        _loginBtn.hidden = NO;
        _HeadPortrait.hidden = YES;
        _name.hidden = YES;
        _infor.hidden = YES;
        
    }

}

#pragma mark- 读取用户信息
- (void)notificationloaduserinfo:(NSNotificationCenter *)botification
{
    if ([UserModel checkLogin]) {
//        NSLog(@"ddddddddddddddddddd");
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"uname"] = [UserModel userUname];
        [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER withParams:param withSuccess:^(id responseObject) {
            
            if (DIC_NOT_EMPTY(responseObject)) {
                _loginBtn.hidden = YES;
                _HeadPortrait.hidden = NO;
                _name.hidden = NO;
                _infor.hidden = NO;
                [_HeadPortrait sd_setImageWithURL:[responseObject objectForKey:@"avatar"]];
                _name.text = [responseObject objectForKey:@"uname"];
                _infor.text = [responseObject objectForKey:@"intro"];
                [UserModel saveUserInformationWithdic:responseObject];
            }
            
            
        } withError:^(NSError *error) {
            
        }];
    }
}
- (void)notificationupatateHeadImage:(NSNotification *)botification{
    if ([UserModel checkLogin]) {
        NSDictionary * useDict = [botification userInfo];
        _loginBtn.hidden = YES;
        _HeadPortrait.hidden = NO;
        _name.hidden = NO;
        _infor.hidden = NO;
        [_HeadPortrait sd_setImageWithURL:[useDict objectForKey:@"avatar"]];
        _name.text = [useDict objectForKey:@"uname"];
        _infor.text = [useDict objectForKey:@"intro"];
        
    }
}



#pragma mark- 去登陆
- (void)loginclick:(UIButton *)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(gologin)]) {
        [_delegate gologin];
    }
    
}


- (void)click
{
    self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);

    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT);
        _ishidden = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:backgroundColor_alpha];
    } completion:^(BOOL finished) {
       
    }];
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_ishidden == YES){
                self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint panpoint = [recognizer translationInView:self];
            
            if (panpoint.x>0 && _ishidden == YES) {
                if (panpoint.x < UI_SCREEN_WIDTH-50) {
                    _bgView.frame = CGRectMake(-UI_SCREEN_WIDTH+panpoint.x+50, 0, UI_SCREEN_WIDTH-50, UI_SCREEN_HEIGHT);
                    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:panpoint.x/UI_SCREEN_WIDTH*backgroundColor_alpha];
                }
                
            }else if (panpoint.x<0 && _ishidden == NO) {
                _bgView.frame = CGRectMake(panpoint.x, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT);
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:(UI_SCREEN_WIDTH+panpoint.x)/UI_SCREEN_WIDTH*backgroundColor_alpha];
            }            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint panpoint = [recognizer translationInView:self];
            if (_ishidden ==YES  && panpoint.x > UI_SCREEN_WIDTH/3) {
                [UIView animateWithDuration:0.2 animations:^{
                    _bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT);
                    _ishidden = NO;
                    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:backgroundColor_alpha];
                } completion:^(BOOL finished) {
                    _bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT);
                    _ishidden = NO;
                    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:backgroundColor_alpha]; 
                }];
                
            }else if (_ishidden ==NO  && panpoint.x > -80.0f){
                _bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, UI_SCREEN_HEIGHT);
                _ishidden = NO;
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:backgroundColor_alpha];
            }else{
                
                [UIView animateWithDuration:0.2 animations:^{
                    _bgView.frame = CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
                    _ishidden = YES;
                    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                } completion:^(BOOL finished) {
                    self.frame = CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
                }];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"cellUp";
        leftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[leftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadstring:[[_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        return cell;
    }else{
        static NSString *identifier = @"cellUp";
        leftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[leftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell reloadstring:[[_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        return cell;
    
    }
  
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 16.0f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(golist:)]) {
        [_delegate golist:indexPath];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
