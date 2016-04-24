//
//  ReadingViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ReadingViewController.h"
#import "AntiqueCatalogData.h"
#import "ParsingData.h"
#import "templateView.h"

#import "UpView.h"
#import "downView.h"
#import "chapterTableViewCell.h"

#import "ShopNameView.h"
#import "BrightnessView.h"
#import "CommenListViewController.h"
#import "FMDB.h"

@interface ReadingViewController ()<UpViewDelegate,downViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,chapterTableViewCellDelegate,templateViewDelegate,ShopNameViewDelegate,BrightnessViewDelegate>{
    FMDatabase *db;

}

@property (nonatomic,strong)AntiqueCatalogData *antiqueCatalog;
@property (nonatomic,strong)templateView *template;

@property (nonatomic,assign)BOOL isMenu;
@property (nonatomic,strong)UpView *upView;
@property (nonatomic,strong)downView *downview;

@property (nonatomic,strong)NSMutableArray    *chapter_title;
@property (nonatomic,strong)NSMutableArray    *chapter_titleTemp;

@property (nonatomic,strong)NSMutableArray    *chapter_int;

@property (nonatomic,strong)UIView          *chapterView;
@property (nonatomic,strong)UITableView     *tableView;

@property (nonatomic,strong)ShopNameView *shopnameView;
@property (nonatomic,assign)BOOL isshopname;

@property (nonatomic,strong)BrightnessView *brightness;
@property (nonatomic,assign)BOOL isbrightness;
@property (nonatomic,assign)float screenbrightnessvalue;
@property (nonatomic,strong) UIColor * firstCorlor;
@property (nonatomic,assign) CGFloat fontInt;
@property (nonatomic,assign) CGFloat titlFontInt;
@property (nonatomic,strong) NSMutableArray * contentArray;
@property (nonatomic,strong) NSString * readFilePath;
@end

@implementation ReadingViewController

-(void)viewWillAppear:(BOOL)animated{
//    [db open];
//    FMResultSet * rs = [Api queryTableIsOrNotInTheDatebaseWithDatabase:db AndTableName:TABLE_ACCOUNTINFOS];
//    if(![rs next]){
//        NSString *sqlCreateTable =  [Api creatTable_TeacherAccountSq];
//        BOOL res = [db executeUpdate:sqlCreateTable];
//        if (!res) {
//            NSLog(@"error when creating TABLE_ACCOUNTINFOS");
//        } else {
//            NSLog(@"success to creating TABLE_ACCOUNTINFOS");
//        }
//        
//    }else{
//        
//    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [db close];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fontInt = 15.0;
    self.titlFontInt = 18;
    db = [Api initTheFMDatabase];

    self.leftButton.hidden = YES;
    self.titleImageView.hidden = YES;
    _isMenu = NO;
    _isshopname = NO;
    _isbrightness = NO;
    
    _screenbrightnessvalue = [UIScreen mainScreen].brightness;
    
    _chapter_title = [[NSMutableArray alloc]init];
//    _chapter_titleTemp = [NSMutableArray alloc]
    _chapter_int = [[NSMutableArray alloc]init];
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];

    [self loaddata];
    [self adRedBook];
    [self CreatUI];
    [self addmybook];
    // Do any additional setup after loading the view.
    BOOL isnight = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_NIGHT"];
    
    if (isnight) {
        self.view.backgroundColor = [UIColor colorWithConvertString:@"#333333"];
        
    }else{
        self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color1];
        
    }
}


NSInteger customSort(id obj1, id obj2,void* context){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}

-(void)adRedBook{
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"cid":_ID};
    [Api requestWithbool:YES withMethod:@"post" withPath:API_URL_Catalog_RedBook withParams:prams withSuccess:^(id responseObject) {
//        [Api alert4:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] inView:self.view offsetY:self.view.bounds.size.height - 50];
        
    }withError:^(NSError *error) {
        [Api alert4:[NSString stringWithFormat:@"%@",error] inView:self.view offsetY:self.view.bounds.size.height - 50];

    }];
    
}

-(void)getDataNetwork{
    [Api showLoadMessage:@"正在加载数据"];
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"id":_ID};
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getTemp withParams:prams withSuccess:^(id responseObject) {
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = responseObject;
        
        if (ARRAY_NOT_EMPTY([dic objectForKey:@"list"])) {
            ParsingData *parsingdata = [[ParsingData alloc]init];
            
            self.contentArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
            
            NSMutableArray *array = [parsingdata MyYesChapterAuctionfromtoMutable:[dic objectForKey:@"list"] withContentFont:15.0f];
            _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array withImagePatjh:nil];
            _template.delegate = self;
            if (ARRAY_NOT_EMPTY(parsingdata.chapter_title)) {
                [_chapter_int removeAllObjects];
                [_chapter_title removeAllObjects];
                
                _chapter_title = parsingdata.chapter_title;
                _chapter_int = parsingdata.chapter_int;
                
            }
            if (ARRAY_NOT_EMPTY(parsingdata.chapter_titleTemp)) {
                [_chapter_int removeAllObjects];
                [_chapter_title removeAllObjects];
                
                _chapter_title = parsingdata.chapter_titleTemp;
                NSArray * tempArray = parsingdata.chapter_int;
                
                
                _chapter_int = (NSMutableArray*)[tempArray sortedArrayUsingFunction:customSort context:nil];
                
            }
            
            [_tableView reloadData];
            [self.view addSubview:_template];
            [self.view insertSubview:_template atIndex:0];
            [Api hideLoadHUD];
            
        }else{
            [Api alert4:@"数据为空" inView:self.view offsetY:self.view.bounds.size.height - 100];
        }
        [Api hideLoadHUD];
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
        
        
        
    }];
    


}

-(void)getDataReadFile:(NSString*)filedName{
    [Api showLoadMessage:@"正在加载数据"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];    //初始化临时文件路径
    NSString *folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@",filedName]];
    NSString * filedPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",filedName]];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [[NSData alloc] init];
    data = [fm contentsAtPath:filedPath];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSString *fileStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * dict = [Api dictionaryWithJsonString:fileStr];
    NSString *pathOne = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@/Image",filedName] ];
        self.readFilePath = pathOne;
        if (ARRAY_NOT_EMPTY([dict objectForKey:@"list"])) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                ParsingData *parsingdata = [[ParsingData alloc]init];
                
                self.contentArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"list"]];
                
                NSMutableArray *array = [parsingdata MyYesChapterAuctionfromtoMutable:[dict objectForKey:@"list"] withContentFont:15.0f];
                
//                                NSLog(@"eeeeeeeeeee");

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array withImagePatjh:pathOne];
                    _template.delegate = self;
                    
                    if (ARRAY_NOT_EMPTY(parsingdata.chapter_title)) {
                        [_chapter_int removeAllObjects];
                        [_chapter_title removeAllObjects];
                        
                        _chapter_title = parsingdata.chapter_title;
                        _chapter_int = parsingdata.chapter_int;
                        
                    }
                    if (ARRAY_NOT_EMPTY(parsingdata.chapter_titleTemp)) {
                        [_chapter_int removeAllObjects];
                        [_chapter_title removeAllObjects];
                        
                        _chapter_title = parsingdata.chapter_titleTemp;
                        NSArray * tempArray = parsingdata.chapter_int;
                        
                        
                        _chapter_int = (NSMutableArray*)[tempArray sortedArrayUsingFunction:customSort context:nil];
                        
                        
                    }

                    [_tableView reloadData];
                    [self.view addSubview:_template];
                    [self.view insertSubview:_template atIndex:0];
                    [Api hideLoadHUD];
                    [db close];
                });
            });
            
       
    }
    
}

- (void)loaddata{

    [db open];
    FMResultSet * resOne = [Api  queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:_ID];
    if ([resOne next]) {
        NSString * fileState = [resOne objectForColumnName:DOWNFILE_TYPE];
        NSString * fileName = [resOne objectForColumnName:DOWNFILE_NAME];
        
        if ([fileState isEqualToString:@"1"]) {
            [self getDataReadFile:fileName];
            
        }else{
            [self getDataNetwork];

        }
        
    }else{
        [self getDataNetwork];
    }
    
    
    
    
    
//    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_get withParams:prams withSuccess:^(id responseObject) {
//        NSDictionary *dic = [[NSDictionary alloc]init];
//        dic = responseObject;
//        
//        if (DIC_NOT_EMPTY([dic objectForKey:@"catalog"])) {
//            _antiqueCatalog = [AntiqueCatalogData WithTypeListDataDic:[dic objectForKey:@"catalog"]];
//        }
//        
//        if ([_antiqueCatalog.type isEqualToString:@"0"]) {
//            ParsingData *parsingdata = [[ParsingData alloc]init];
//            self.contentArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
//           NSMutableArray *array = [parsingdata AuctionfromtoMutable:[dic objectForKey:@"list"]];
//            _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array];
//            _template.delegate = self;
//            [self.view addSubview:_template];
//            [self.view insertSubview:_template atIndex:0];
//            
//        }else{
//            ParsingData *parsingdata = [[ParsingData alloc]init];
//
//            if (ARRAY_NOT_EMPTY([dic objectForKey:@"list"])) {
//                self.contentArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
//
//                NSMutableArray *array = [parsingdata YesChapterAuctionfromtoMutable:[dic objectForKey:@"list"]];
//                _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array];
//                _template.delegate = self;
//                _chapter_title = parsingdata.chapter_title;
//                _chapter_int = parsingdata.chapter_int;
//                [_tableView reloadData];
//                [self.view addSubview:_template];
//                [self.view insertSubview:_template atIndex:0];
//            }
// 
//        }
//        
//    } withError:^(NSError *error) {
//        
//        
//        
//    }];
    
    
    
}

- (void)addmybook{
    
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"cid":_ID};
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_addToBook withParams:prams withSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addmybook" object:nil];
        }
        
    } withError:^(NSError *error) {
        
        
        
    }];
    
}

- (void)CreatUI{
    
    //开启交互功能
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color1];
    
    _upView = [[UpView alloc]initWithFrame:CGRectMake(0, -64, UI_SCREEN_WIDTH, 64)];
    _upView.delegate = self;
    [self.view addSubview:_upView];
    
    
    _downview = [[downView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 64)];
    _downview.delegate = self;
    [self.view addSubview:_downview];
    
    _chapterView = [[UIView alloc]initWithFrame:CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _chapterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:_chapterView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, UI_SCREEN_HEIGHT)];
    bgView.backgroundColor = White_Color;
    [_chapterView addSubview:bgView];
    
    UILabel *chaptertitle = [Allview Withstring:@"目录" Withcolor:Essential_Colour Withbgcolor:White_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    [chaptertitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];

    chaptertitle.frame = CGRectMake(0, 20, UI_SCREEN_WIDTH - 40, 44);
    [bgView addSubview:chaptertitle];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-40, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = Clear_Color;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [bgView addSubview:_tableView];
    
    _chapterView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_chapterView addGestureRecognizer:panGestureRecognizer];
    
    UIView *right = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40, 0, 40, UI_SCREEN_HEIGHT)];
    right.backgroundColor = Clear_Color;
    [_chapterView addSubview:right];
    
    
    //添加点击动作
    UITapGestureRecognizer *tapchapterView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTapchapterView:)];
    tapchapterView.numberOfTouchesRequired = 1;
    tapchapterView.numberOfTapsRequired = 1;
    [right addGestureRecognizer:tapchapterView];
    
}

- (void)handTapVeiw:(UITapGestureRecognizer *)tap
{
    if (_isMenu) {
        [UIView animateWithDuration:0.4 animations:^{
            
            _upView.frame = CGRectMake(0, -64, UI_SCREEN_WIDTH, 64);
            _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 64);
            _isMenu = NO;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        if (_isshopname) {
            
            _isshopname = NO;
            [UIView animateWithDuration:0.4 animations:^{
                
                _shopnameView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 0);
                
            } completion:^(BOOL finished) {
                _shopnameView = nil;
            }];
            
        }
//        else{
//            
//            [UIView animateWithDuration:0.4 animations:^{
//                
//                _upView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 64);
//                _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 64, UI_SCREEN_WIDTH, 64);
//                _isMenu = YES;
//                
//            } completion:^(BOOL finished) {
//                
//            }];
//            
//        }
        if (_isbrightness) {
            
            _isbrightness = NO;
            [UIView animateWithDuration:0.4 animations:^{
                
                _brightness.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 0);
                
            } completion:^(BOOL finished) {
                _brightness = nil;
            }];
            
        }else{
            
            [UIView animateWithDuration:0.4 animations:^{
                
                _upView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 64);
                _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 64, UI_SCREEN_WIDTH, 64);
                _isMenu = YES;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        
    }
    
}
- (void)longhandTap:(UILongPressGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.4 animations:^{
    
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UpViewDelegate

-(void)backgo{
    
    [UIView animateWithDuration:0.1 animations:^{
        _chapterView.hidden = YES;
        [[UIScreen mainScreen] setBrightness:_screenbrightnessvalue];
    } completion:^(BOOL finished) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
-(void)sharego{
    
}

#pragma mark - downViewDelegate
-(void)menuo:(NSInteger)integer{
    
    switch (integer) {
        case 0:
        {
            [UIView animateWithDuration:0.1 animations:^{
                
                _upView.frame = CGRectMake(0, -64, UI_SCREEN_WIDTH, 64);
                _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 64);
                _isMenu = NO;
                
            } completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:0.4 animations:^{
                
                _chapterView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.4 animations:^{
                
                _upView.frame = CGRectMake(0, -64, UI_SCREEN_WIDTH, 64);
                _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 64);
                _isMenu = NO;
                
            } completion:^(BOOL finished) {
                
                    _isbrightness = YES;
                    if (_brightness == nil) {
                        _brightness = [[BrightnessView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 64, UI_SCREEN_WIDTH, 64)];
                        _brightness.delegate = self;
                        [self.view addSubview:_brightness];
                    }
                
            }];
            
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.4 animations:^{
                
                _upView.frame = CGRectMake(0, -64, UI_SCREEN_WIDTH, 64);
                _downview.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 64);
                _isMenu = NO;
                
            } completion:^(BOOL finished) {
                
            }];
            _isshopname = YES;
            if (_shopnameView == nil) {
                _shopnameView = [[ShopNameView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 124, UI_SCREEN_WIDTH, 124)];
                _shopnameView.delegate = self;
                [self.view addSubview:_shopnameView];
            }
        }
            break;
        case 3:
        {
            CommenListViewController *commenlist = [[CommenListViewController alloc]init];
            commenlist.ID = _ID;
            [self.navigationController pushViewController:commenlist animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chapter_title.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellantique";
    chapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[chapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (ARRAY_NOT_EMPTY(_chapter_title)) {
        [cell loadstring:[_chapter_title objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
   
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41.0f;
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

#pragma mark- chapterTableViewCellDelegate

-(void)gomenu:(NSInteger)integer{
//    NSLog(@"wwwwwwwwwww:%@",_chapter_int);
    if (integer == 0) {
        [_template goNumberofpages:@"0"];

    }else{
        [_template goNumberofpages:[_chapter_int objectAtIndex:integer]];

    }
    [UIView animateWithDuration:0.2 animations:^{
        
        _chapterView.frame = CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
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
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                _chapterView.frame = CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)handTapchapterView:(UITapGestureRecognizer *)tap{
    
    CGPoint panpoint = [tap locationInView:_chapterView];
    if (panpoint.x > UI_SCREEN_WIDTH - 40) {
        [UIView animateWithDuration:0.2 animations:^{
            
            _chapterView.frame = CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark - ShopNameViewDelegate
- (void)shopnamehan:(NSInteger)integer{
    switch (integer) {
        case 0:
        {
            self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color1];
        }
            break;
        case 1:
        {
            self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color2];
        }
            break;
        case 2:
        {
            self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color3];
        }
            break;
        case 3:
        {
            self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color4];
        }
            break;
        case 4:
        {
            self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color5];
        }
            break;
        case 10:
        {
            if (self.fontInt > 10 && self.titlFontInt > 16) {
                self.fontInt --;
                self.titlFontInt --;
                [self.template removeFromSuperview];
                self.template = nil;
                [Api showLoadMessage:@"正在加载数据"];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ParsingData *parsingdata = [[ParsingData alloc]init];

                NSMutableArray *array = [parsingdata MyYesChapterAuctionfromtoMutable:self.contentArray withContentFont:self.fontInt];
                dispatch_async(dispatch_get_main_queue(), ^{

                _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array withContentFont:self.fontInt withTitlFont:self.titlFontInt];
                _template.delegate = self;
                [self.view addSubview:_template];
                [self.view insertSubview:_template atIndex:0];
                    [Api hideLoadHUD];
                    });
                });

//                if ([_antiqueCatalog.type isEqualToString:@"0"]) {
//                    ParsingData *parsingdata = [[ParsingData alloc]init];
//                    NSMutableArray * dataArray = [parsingdata AuctionfromtoMutable:self.contentArray withContentFont:self.fontInt];
//                    _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:dataArray withContentFont:self.fontInt withTitlFont:self.titlFontInt];
//                    _template.delegate = self;
//                    [self.view addSubview:_template];
//                    [self.view insertSubview:_template atIndex:0];
//                    
//                }else{
//                    ParsingData *parsingdata = [[ParsingData alloc]init];
//                    NSMutableArray * dataArray = [parsingdata YesChapterAuctionfromtoMutable:self.contentArray withContenFont:self.fontInt];
//                    _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:dataArray withContentFont:self.fontInt withTitlFont:self.titlFontInt];
//                    _template.delegate = self;
//                    [self.view addSubview:_template];
//                    [self.view insertSubview:_template atIndex:0];
//
//                }
//
                
                
                
//                self.template.fontInt = self.fontInt;
//                self.template.titlFontInt = self.titlFontInt;
//                
//                [self.template reloadData];
                
            }else{
                UIAlertView * altview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最小字体" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [altview show];
            }
            

            
        }
            break;
        case 11:
        {
            if (self.fontInt >= 17 && self.titlFontInt >= 20) {
                UIAlertView * altview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最大字体" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [altview show];
            }else{
                self.fontInt ++;
                self.titlFontInt ++;
                [self.template removeFromSuperview];
                self.template = nil;
                [Api showLoadMessage:@"正在加载数据"];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    ParsingData *parsingdata = [[ParsingData alloc]init];
                    
                    NSMutableArray *array = [parsingdata MyYesChapterAuctionfromtoMutable:self.contentArray withContentFont:self.fontInt];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:array withContentFont:self.fontInt withTitlFont:self.titlFontInt];
                        _template.delegate = self;
                        [self.view addSubview:_template];
                        [self.view insertSubview:_template atIndex:0];
                        [Api hideLoadHUD];
                    });
                });
                
//                if ([_antiqueCatalog.type isEqualToString:@"0"]) {
//                    ParsingData *parsingdata = [[ParsingData alloc]init];
//                    NSMutableArray * dataArray = [parsingdata AuctionfromtoMutable:self.contentArray withContentFont:self.fontInt];
//                    _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:dataArray withContentFont:self.fontInt withTitlFont:self.titlFontInt];
//                    _template.delegate = self;
//                    [self.view addSubview:_template];
//                    [self.view insertSubview:_template atIndex:0];
//                    
//                }else{
//                    ParsingData *parsingdata = [[ParsingData alloc]init];
//                    NSMutableArray * dataArray = [parsingdata YesChapterAuctionfromtoMutable:self.contentArray withContenFont:self.fontInt];
//                    _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:dataArray withContentFont:self.fontInt withTitlFont:self.titlFontInt];
//                    _template.delegate = self;
//                    [self.view addSubview:_template];
//                    [self.view insertSubview:_template atIndex:0];
//                    
//                }

                
//                ParsingData *parsingdata = [[ParsingData alloc]init];
//                NSMutableArray * dataArray = [parsingdata AuctionfromtoMutable:self.contentArray withContentFont:self.fontInt];
//                _template = [[templateView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) andWithmutbleArray:dataArray withContentFont:self.fontInt withTitlFont:self.titlFontInt];
//                _template.delegate = self;
//                [self.view addSubview:_template];
//                [self.view insertSubview:_template atIndex:0];

  
//                self.template.fontInt = self.fontInt;
//                self.template.titlFontInt = self.titlFontInt;
//                [self.template reloadData];
            }
            
            
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - BrightnessViewDelegate
-(void)BrightnessViewhan:(float)value{

    [[UIScreen mainScreen] setBrightness:value];
    
}
-(void)NightMode:(BOOL)isnight{
    self.template.isNigth = isnight;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IS_NIGHT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (isnight) {
        self.view.backgroundColor = [UIColor colorWithConvertString:@"#333333"];
        
    }else{
        self.view.backgroundColor = [UIColor colorWithConvertString:Reading_color1];

    }
    [[NSUserDefaults standardUserDefaults] setBool:isnight forKey:@"IS_NIGHT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.template reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
