//
//  CatalogDetailsViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogDetailsViewController.h"

#import "catalogdetailsdata.h"
#import "commentData.h"
#import "catalogdetailsTableViewCell.h"
#import "CatalogIntroduceTableViewCell.h"
#import "catalogdetailsTagTableViewCell.h"
#import "catalogdetailsUserTableViewCell.h"
#import "catalogCommentTableViewCell.h"
#import "catalogMoreTableViewCell.h"

#import "ReadingViewController.h"
#import "CatalogGetListViewController.h"
#import "TagViewController.h"

#import "CommenListViewController.h"
#import "CommenListViewController2.h"
#import "UserSpaceViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AFHTTPRequestOperation.h"
#import "FMDB.h"

@interface CatalogDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,CatalogIntroduceTableViewCellDelegate,catalogdetailsUserTableViewCellDelegate,catalogMoreTableViewCellDelegate,catalogdetailsTableViewCellDelegate,catalogdetailsTagTableViewCellDelegate,catalogCommentTableViewCellDelegate>{
    FMDatabase *db;

}

@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;
@property (nonatomic,strong)NSMutableArray *commentArray;
@property (nonatomic,strong)NSMutableArray *commentCellArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic, assign) NSInteger ImageCount;
@property (nonatomic, strong) NSMutableArray * childImageArray;
@property (nonatomic, strong) NSMutableArray * countImageArray;

@end

@implementation CatalogDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.childImageArray = [NSMutableArray array];
    self.countImageArray = [NSMutableArray array];
    db = [Api initTheFMDatabase];
    
    self.titleLabel.text = @"图录详情";
    [self.rightButton setTitle:@"目录" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:Blue_color forState:UIControlStateNormal];
    
    _isOpen = NO;
    _commentArray = [[NSMutableArray alloc]init];
    _commentCellArray = [[NSMutableArray alloc]init];
    
    [db open];
    FMResultSet * rs = [Api queryTableIsOrNotInTheDatebaseWithDatabase:db AndTableName:TABLE_ACCOUNTINFOS];
    if(![rs next]){
        NSString *sqlCreateTable =  [Api creatTable_TeacherAccountSq];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating TABLE_ACCOUNTINFOS");
        } else {
            NSLog(@"success to creating TABLE_ACCOUNTINFOS");
        }
        
    }else{
        
    }

    
    [self CreatUI];
    [self loaddata];
    // Do any additional setup after loading the view.
}
-(void)rightButtonClick:(id)sender{
    CatalogGetListViewController *cataloggetlist = [[CatalogGetListViewController alloc]init];
    cataloggetlist.ID = _ID;
    [self.navigationController pushViewController:cataloggetlist animated:YES];
}
- (void)CreatUI{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.allowsMultipleSelection = NO;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (void)loaddata{
    
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"id":_ID};
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCatalog withParams:prams withSuccess:^(id responseObject) {
        
//        NSLog(@"%@",responseObject);
        if (DIC_NOT_EMPTY(responseObject)) {
            _catalogdetailsData = [catalogdetailsdata WithcatalogdetailsdataDataDic:responseObject];
            if (ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
                for (NSDictionary *dic in _catalogdetailsData.comment) {
                    commentData *commentdata = [commentData WithcommentDataDic:dic];
                    [_commentArray addObject:commentdata];
                    catalogCommentTableViewCell *commentcell = [[catalogCommentTableViewCell alloc]init];
                    [_commentCellArray addObject:commentcell];
                }
            }
            
        }
        [_tableView reloadData];
        
        
    } withError:^(NSError *error) {
        
    }];
    
    
       
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
//    NSString *urlstr = [NSString stringWithFormat:@"%@/%@&id=%@&&oauth_token=%@&oauth_token_secret=%@",HEADURL,API_URL_Catalog_getCatalog,_ID,Oauth_token,Oauth_token_secret];
//    NSURL *url = [NSURL URLWithString:urlstr];
//    
//    [manager GET:url.absoluteString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
////        NSLog(@"JSON: %@", responseObject);
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        if (DIC_NOT_EMPTY(dic)) {
//            _catalogdetailsData = [catalogdetailsdata WithcatalogdetailsdataDataDic:dic];
//            if (ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
//                for (NSDictionary *dic in _catalogdetailsData.comment) {
//                    commentData *commentdata = [commentData WithcommentDataDic:dic];
//                    [_commentArray addObject:commentdata];
//                    catalogCommentTableViewCell *commentcell = [[catalogCommentTableViewCell alloc]init];
//                    [_commentCellArray addObject:commentcell];
//                }
//            }
//            
//        }
//        [_tableView reloadData];
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (ARRAY_NOT_EMPTY(_catalogdetailsData.tag)) {
                return 4;
            }else{
                return 3;
            }
        }
            
            break;
        case 1:
        {
            if (ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
                return _catalogdetailsData.comment.count;
            }else{
                return 0;
            }
        }
            break;
        case 2:
        {
            return 2;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        static NSString *identifier = @"celldetails";
        catalogdetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[catalogdetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell initSubView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.catalogdetailsData = _catalogdetailsData;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 0){
        static NSString *identifier = @"cellIntroduce";
        CatalogIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CatalogIntroduceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
//        cell.backgroundColor = [UIColor redColor];
        [cell updateCellWithData:_catalogdetailsData andmore:_isOpen andIndexPath:indexPath];
        return cell;
        
    }else if (indexPath.row == 2 && indexPath.section == 0) {
        if (ARRAY_NOT_EMPTY(_catalogdetailsData.tag)) {
            static NSString *identifier = @"celltag";
            catalogdetailsTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[catalogdetailsTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.catalogdetailsData = _catalogdetailsData;
            return cell;
        }else{
            static NSString *identifier = @"celluser";
            catalogdetailsUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[catalogdetailsUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell loadCatalogdetailsData:_catalogdetailsData andindexPath:indexPath];
            cell.delegate = self;
            return cell;

        }
        
    }else if (indexPath.row == 3 && indexPath.section == 0 && ARRAY_NOT_EMPTY(_catalogdetailsData.tag)){
        static NSString *identifier = @"celluser";
        catalogdetailsUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[catalogdetailsUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadCatalogdetailsData:_catalogdetailsData andindexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1){
        if (ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
            /*
            if (indexPath.row < _commentArray.count) {
                static NSString *identifier = @"cellcomment";
                catalogCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[catalogCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                [cell loadWithCommentArray:_commentArray[indexPath.row] andWithIndexPath:indexPath];
                return cell;
            }else{
                static NSString *identifier = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"查看更多";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont systemFontOfSize:Nav_title_font];
                return cell;
                
            }
            */
            static NSString *identifier = @"cellcomment";
            catalogCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[catalogCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell loadWithCommentArray:_commentArray[indexPath.row] andWithIndexPath:indexPath];
            return cell;
        }
        
    }else if (indexPath.section == 2){
        
        static NSString *identifier = @"cellmore";
        catalogMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[catalogMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        switch (indexPath.row) {
            case 0:
            {
                if([_catalogdetailsData isEqual:[NSNull null]] || _catalogdetailsData == NULL){
                    [cell loadWithstring:[NSString stringWithFormat:@""] andWitharray:_catalogdetailsData.userInfo_moreCatalog andWithIndexPath:indexPath];

                }else{
                    if ([_catalogdetailsData.author isEqualToString:@""] || [_catalogdetailsData.author isEqual:[NSNull null]] || _catalogdetailsData.author.length == 0) {
                        [cell loadWithstring:@"其他图录" andWitharray:_catalogdetailsData.userInfo_moreCatalog andWithIndexPath:indexPath];

                    }else{
                        [cell loadWithstring:[NSString stringWithFormat:@"%@的其他图录",_catalogdetailsData.author] andWitharray:_catalogdetailsData.userInfo_moreCatalog andWithIndexPath:indexPath];

                    }

                }
            }
                break;
            case 1:
            {
                [cell loadWithstring:@"你可能感兴趣的图录" andWitharray:_catalogdetailsData.moreCatalog andWithIndexPath:indexPath];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //return 40+116+40+40+16+1;
                    return 40+116+60+60+40+16+1;
                }
                    break;
                case 1:
                {
                    UILabel *lable = [[UILabel alloc]init];
                    CGSize infosize = [Allview String:_catalogdetailsData.info Withfont:Catalog_Cell_info_Font WithCGSize:UI_SCREEN_WIDTH - 64 Withview:lable Withinteger:0];
                    if ([_catalogdetailsData.type isEqualToString:@"0"]) {
                        
                        if (_isOpen) {
                            return 16+15*4+5*4+infosize.height+30;
                            
                        }else{
                            if (infosize.height > 156.0f) {
                                return 16+15*4+5*4+156.0+30;
                            }else{
                                return 16+15*4+5*4+infosize.height+10;
                            }
                        }
                        
                    }else{
                        
//                        if (_isOpen) {
//                            
//                            return 16+infosize.height+30;
//                            
//                        }else{
//                            if (infosize.height > 35.0f) {
//                                return 16+35+30;
//                            }else{
//                                return 16+infosize.height+10;
//                            }
//                        }
                        if (_isOpen) {
                            
                            return 16+infosize.height+30;
                            
                        }else{
                            if (infosize.height > 156.0f) {
                                return 16+156+30;
                            }else{
                                return 16+infosize.height+10;
                            }
                        }

                        
                        
                    }
                }
                    break;
                case 2:
                {
                    if (ARRAY_NOT_EMPTY(_catalogdetailsData.tag)) {
                        return 50 + 30 + 10;
                    }else{
                        return 64 + 1 + 1;
                    }
                    
                }
                    break;
                case 3:
                {
                    return 64 + 10 + 10;
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 1:
        {
            if (ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
                if (indexPath.row < _commentArray.count) {
                    catalogCommentTableViewCell *commenttableviewcell = _commentCellArray[indexPath.row];
                    [commenttableviewcell loadWithCommentArray:_commentArray[indexPath.row] andWithIndexPath:indexPath];
                    return commenttableviewcell.height;
                }else{
                    return 30.f;
                }
                
            }else{
                
                return 56;
            }
        }
            break;
         
        case 2:
        {
            return 20+30+116+12+25+20;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        if (_catalogdetailsData.comment.count) {
            return 32.f;
        }else{
            //return 56.f;
            return 0.0f;
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1 && _commentArray.count>=3){
        return 32.f;
    }else{
        return 0.0f;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        /*
        if (!ARRAY_NOT_EMPTY(_catalogdetailsData.comment)) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, UI_SCREEN_WIDTH, 56)];
            view.backgroundColor = White_Color;
            UILabel *label = [Allview Withstring:@"精彩评论" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(16, 0, UI_SCREEN_WIDTH - 32, 24);
            UILabel *commentlabel = [Allview Withstring:@"点击发布第一条评论" Withcolor:Blue_color Withbgcolor:Clear_Color Withfont:Catalog_Cell_uname_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
            commentlabel.frame = CGRectMake(16, CGRectGetMaxY(label.frame), UI_SCREEN_WIDTH - 32, 32);
            commentlabel.tag = 1;
            [view addSubview:label];
            [view addSubview:commentlabel];
            
            //开启交互功能
            commentlabel.userInteractionEnabled = YES;
            
            
            //添加点击动作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            tap.numberOfTouchesRequired = 1;
            tap.numberOfTapsRequired = 1;
            [commentlabel addGestureRecognizer:tap];
            
            return view;
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
            view.backgroundColor = White_Color;
            UILabel *label = [Allview Withstring:@"精彩评论" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
            label.frame = CGRectMake(16, 0, UI_SCREEN_WIDTH - 32, 32);
            [view addSubview:label];
            return view;
        }
         */
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
        view.backgroundColor = White_Color;
        UILabel *label = [Allview Withstring:@"精彩评论" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(16, 0, UI_SCREEN_WIDTH - 32, 32);
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1 && _commentArray.count >= 3){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
        view.backgroundColor = White_Color;
        UILabel *label = [Allview Withstring:@"查看全部评论" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(16, 0, UI_SCREEN_WIDTH - 32, 32);
        [view addSubview:label];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = view.bounds;
        [button addTarget:self action:@selector(lookAll:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }else{
        return nil;
    }
}

-(void)lookAll:(UIButton*)sender{
    NSLog(@"查看全部评论");
    [self centerViewDidClick];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"我点击了查看更多");
    commentData * item = _commentArray[indexPath.row];
    CommenListViewController2 * commenlist = [[CommenListViewController2 alloc]init];
    commenlist.ID = _ID;
    commenlist.ID2 = item.ID;
    [self.navigationController pushViewController:commenlist animated:YES];
    
    /*
    if ( _catalogdetailsData.author.length == 0) {
        _catalogdetailsData.author = [NSString stringWithFormat:@"%@",self.catalogData.uname];

    }
    commenlist.catalogData = _catalogdetailsData;
    */
}

#pragma mark-catalogCommentTableViewCellDelegate
-(void)hanisdigg:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    NSDictionary *param = [NSDictionary dictionary];
    NSString *isdiggurl;
    commentData *commentdata = [_commentArray objectAtIndex:indexPath.row];
    if (commentdata.is_digg) {
        param = @{@"comment_id":commentdata.ID};
        isdiggurl = API_URL_Catalog_undiggComment;
    }else{
        param = @{@"comment_id":commentdata.ID};
        isdiggurl = API_URL_Catalog_diggComment;
    }
    
    [Api requestWithbool:YES withMethod:@"get" withPath:isdiggurl withParams:param withSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            if (commentdata.is_digg) {
                commentdata.is_digg = NO;
                NSInteger commentcount = [commentdata.digg_count integerValue];
                commentdata.digg_count = [NSString stringWithFormat:@"%ld",commentcount-1];
            }else{
                commentdata.is_digg = YES;
                NSInteger commentcount = [commentdata.digg_count integerValue];
                commentdata.digg_count = [NSString stringWithFormat:@"%ld",commentcount+1];
            }
            [_commentArray removeObjectAtIndex:indexPath.row];
            [_commentArray insertObject:commentdata atIndex:indexPath.row];
            
            [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }

        
    } withError:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}

#pragma mark-CatalogIntroduceTableViewCellDelegate
- (void)han:(BOOL)more andIndexPath:(NSIndexPath *)indexPath{
    
    _isOpen = !_isOpen;
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark-catalogdetailsUserTableViewCellDelegate
-(void)follow:(catalogdetailsdata *)catalogdetailsData andIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];

    NSDictionary *param = [NSDictionary dictionary];
    NSString *followurl;
    if (_catalogdetailsData.userInfo_following) {
        param = @{@"user_id":_catalogdetailsData.userInfo_uid};
        followurl = API_URL_USER_UNFollow;
    }else{
        param = @{@"user_id":_catalogdetailsData.userInfo_uid};
        followurl = API_URL_USER_Follow;
    }
    [Api requestWithbool:YES withMethod:@"get" withPath:followurl withParams:param withSuccess:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (!_catalogdetailsData.userInfo_following) {
                _catalogdetailsData.userInfo_following = YES;
            }else{
                _catalogdetailsData.userInfo_following = NO;
                
            }
            [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

        }
        
    } withError:^(NSError *error) {
        
//        NSLog(@"%@",error);
        
    }];
    
}

- (void)hanheadImage{
    
    UserSpaceViewController *userspaceVC = [[UserSpaceViewController alloc]init];
    userspaceVC.uid = _catalogdetailsData.userInfo_uid;
    [self.navigationController pushViewController:userspaceVC animated:YES];
    
}

#pragma mark - 精彩评论
-(void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    CommenListViewController *commenlist = [[CommenListViewController alloc]init];
    commenlist.ID = _ID;
    if ( _catalogdetailsData.author.length == 0) {
        _catalogdetailsData.author = [NSString stringWithFormat:@"%@",self.catalogData.uname];
        
    }
    commenlist.catalogData = _catalogdetailsData;
    [self.navigationController pushViewController:commenlist animated:YES];
            
}

#pragma mark - catalogdetailsTableViewCellDelegate
- (void)hanreadingclick{
    
    ReadingViewController *readingVC = [[ReadingViewController alloc]init];
    readingVC.ID = _ID;
    [self.navigationController pushViewController:readingVC animated:YES];
    
}

/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
    //
    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //
    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}

-(void)dowLoadImage:(NSString*)urlStr withArrayCount:(NSInteger)arrayCount withImageId:(NSString*)imageId{
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *que = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:que completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"AsynchronousRequest1 get data is OK  on thread %@!!  %@",[NSThread currentThread],[connectionError localizedDescription]);
        }
        else{
            UIImage * image = [UIImage imageWithData:data];
            NSString * imageName = [NSString stringWithFormat:@"%@_image",imageId];
//            image.le
            NSDictionary * imageDict = [[NSDictionary alloc] initWithObjectsAndKeys:image,imageName, imageId,@"ImageId",nil];
            [self.childImageArray addObject:imageDict];
            if (self.childImageArray.count == arrayCount) {
                NSArray * child = [NSArray arrayWithArray:self.childImageArray];
                [self.countImageArray addObject:child];
                if (self.ImageCount == self.countImageArray.count) {
                    NSMutableData *dataOne = [[NSMutableData alloc] init];
                    NSKeyedArchiver *vdArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataOne];
                    [vdArchiver encodeObject:self.countImageArray forKey:[NSString stringWithFormat:@"ImageKey_%@",_ID]];
                    [vdArchiver finishEncoding];
                    
                    NSLog(@"rrrrrrr:%lu",(unsigned long)dataOne.length);
//                    NSString *updateSql = [NSString stringWithFormat:
//                                           @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
//                                           TABLE_ACCOUNTINFOS,IMAGEDATA,dataOne,DATAID,_ID];
                    NSString *updateSql = [NSString stringWithFormat:
                                           @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                           TABLE_ACCOUNTINFOS,IMAGEDATA,self.childImageArray,DATAID,_ID];
                    BOOL res = [db executeUpdate:updateSql];
                    if (!res) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        NSLog(@"success to update TABLE_ACCOUNTINFOS");
                    }
                    
                    
                }
                if (self.childImageArray.count) {
                    [self.childImageArray removeAllObjects];

                }


            }
            

          
        }
    }];

    
}

-(void)responseDictFinish:(NSArray*)responseArry{
    if (self.childImageArray) {
        [self.childImageArray removeAllObjects];
    }
    if (self.countImageArray) {
        [self.countImageArray removeAllObjects];
    }
    self.ImageCount = responseArry.count;
    
    for (NSDictionary * responseDict in responseArry) {
        if([[responseDict allKeys] containsObject:@"child"]){
            NSArray * childArray = responseDict[@"child"];
            NSArray * valueArray = responseDict[@"value"];
            if (ARRAY_NOT_EMPTY(childArray)) {
                for (NSDictionary * childDict in childArray) {
                    NSArray * cValueArray= childDict[@"value"];
                    for (NSDictionary * cValueDict in cValueArray) {
                        NSString *imageUrl = cValueDict[@"cover"];
                        NSString * imageId = cValueDict[@"id"];

                        if (STRING_NOT_EMPTY(imageUrl)) {
                            [self dowLoadImage:imageUrl withArrayCount:childArray.count withImageId:imageId];

                            
                        }else{
                        }
                        
                    }
                    
               }
                
            }else if (ARRAY_NOT_EMPTY(valueArray)){
                for (NSDictionary * valueDict in valueArray) {

                    NSString *imageUrl = valueDict[@"cover"];
                    NSString * imageId = valueDict[@"id"];

                    if (STRING_NOT_EMPTY(imageUrl)) {
                        [self dowLoadImage:imageUrl withArrayCount:valueArray.count withImageId:imageId];
                        
                    }else{
                        
                    }
                }

            }


        }else if([[responseDict allKeys] containsObject:@"value"]){
            NSArray * valueArray = responseDict[@"value"];
            if (ARRAY_NOT_EMPTY(valueArray)){
                for (NSDictionary * valueDict in valueArray) {
                    NSString *imageUrl = valueDict[@"cover"];
                    NSString * imageId = valueDict[@"id"];
                    NSLog(@"ddddddddd ImageId->:%@",imageId);
                    if (STRING_NOT_EMPTY(imageUrl)) {
                        [self dowLoadImage:imageUrl withArrayCount:valueArray.count withImageId:imageId];

                        
                    }
                }
   
            }

            
        }
        
    }
    
    

}

-(void)inserNewData:(NSDictionary*)responseDict withId:(NSString*)tempId{
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    NSString * keyName=[NSString stringWithFormat:@"KEY_%@",tempId];
//    [archiver encodeObject:responseDict forKey:keyName];
//    [archiver finishEncoding];
    
    NSString *insertSql= [NSString stringWithFormat:
                          @"INSERT INTO '%@' ('%@', '%@','%@') VALUES ('%@', '%@','%@' )",
                          TABLE_ACCOUNTINFOS,DATAID,ALLINFOData,IMAGEDATA,tempId,responseDict,@"BBB"];
    BOOL res = [db executeUpdate:insertSql];
    if (!res) {
        NSLog(@"error when TABLE_ACCOUNTINFOS");
    } else {
        NSLog(@"success to TABLE_ACCOUNTINFOS");
    }
    
    
}
- (void)hancataloglistclick{
    NSLog(@"下载，下载!");
    FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:TABLE_ACCOUNTINFOS AndWhereName:DATAID AndValue:self.ID];
    if([tempRs next]){
        NSDictionary * infoData =[tempRs objectForColumnName:ALLINFOData];
        NSMutableArray * imageData =[tempRs objectForColumnName:IMAGEDATA];

        NSLog(@"rrrrrrr:%@",infoData);
        NSLog(@"dddddddd:%@",imageData);

    }else{
        NSDictionary *prams = [NSDictionary dictionary];
        prams = @{@"id":_ID};
        [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getTemp withParams:prams withSuccess:^(id responseObject) {
            NSDictionary * responseDict = (NSDictionary*)responseObject;
//           NSString * type = @"insert";
            
            [self inserNewData:responseDict withId:_ID];
            [self responseDictFinish:responseDict[@"list"]];
            
        }withError:^(NSError *error) {
            
            
        }];
    }

   
    /*
    CatalogGetListViewController *cataloggetlist = [[CatalogGetListViewController alloc]init];
    cataloggetlist.ID = _ID;
    [self.navigationController pushViewController:cataloggetlist animated:YES];
    */
}

-(void)hanMoreIndexPath:(NSString *)MoreindexPath{
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    
    catalogVC.ID = MoreindexPath;
    [self.navigationController pushViewController:catalogVC animated:YES];
}

#pragma mark - catalogdetailsTagTableViewCellDelegate

- (void)hanTapOne:(NSDictionary *)dic{
    
//    NSLog(@"%@",dic);
    
    TagViewController *tagVC = [[TagViewController alloc]init];
    tagVC.ID = [dic objectForKey:@"id"];
    tagVC.dic = dic;
    [self.navigationController pushViewController:tagVC animated:YES];
    
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

-(void)leftViewDidClick{
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"cid":_ID};
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_ADDTOBOOK withParams:prams withSuccess:^(id responseObject) {
        if([responseObject[@"status"] intValue] == 0){
            [self showHudInView:self.view showHint:@"该图录已经存在云库"];
        }
        if([responseObject[@"status"] intValue] == 1){
            [self showHudInView:self.view showHint:@"加入云库成功"];
        }
        
    } withError:^(NSError *error) {
        
    }];
}
-(void)centerViewDidClick{
    CommenListViewController *commenlist = [[CommenListViewController alloc]init];
    commenlist.ID = _ID;
    if ( _catalogdetailsData.author.length == 0) {
        _catalogdetailsData.author = [NSString stringWithFormat:@"%@",self.catalogData.uname];
        
    }
    commenlist.catalogData = _catalogdetailsData;
    [self.navigationController pushViewController:commenlist animated:YES];

}
-(void)rightViewDidClick{
    [self showShareView];
}

-(void)showShareView{
    UIView * shareView = [[UIView alloc]init];
    shareView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    float littleButtonWidth = UI_SCREEN_WIDTH * 0.156;
    float shareViewHeight = 50 + littleButtonWidth * 1.4 + 20; //取消的高度+图标的高度+上下各10
    shareView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-shareViewHeight, UI_SCREEN_WIDTH, shareViewHeight);
    shareView.tag = 1001;
    
    NSArray *array = [NSArray arrayWithObjects:@"Activity_pengyouquan", @"Activity_weixin", @"Activity_sina", @"Activity_qq", nil];
    float avrWidth = UI_SCREEN_WIDTH / 5;
    for(int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(avrWidth * (i + 1) - littleButtonWidth/2, 10, littleButtonWidth, littleButtonWidth * 1.4);
        [btn setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ shareView addSubview:btn];
    }
    
    UILabel * downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, shareView.bounds.size.height - 50, UI_SCREEN_WIDTH, 50)];
    downLabel.text = @"取消";
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = [UIColor whiteColor];
    downLabel.backgroundColor = [UIColor grayColor];
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = downLabel.frame;
    [button addTarget:self action:@selector(cancelShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:downLabel];
    [shareView addSubview:button];
    
    [self.view addSubview:shareView];
}

-(void)btnClicked:(UIButton*)sender{
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 100:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiTimeline
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 101:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@", API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiSession
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 102:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP（“虎头”@到处是宝）下载：%@%@",API_URL_INVITATION,[UserModel userUname]]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self showHudInView:self.view showHint:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 103:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    //                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        default:
            break;
    }

}
-(void)cancelShareView:(UIButton*)sender{
    UIView * shareView = [self.view viewWithTag:1001];
    [shareView removeFromSuperview];
}
@end
