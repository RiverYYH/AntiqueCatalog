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
#import "UserSpaceViewController.h"

@interface CatalogDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,CatalogIntroduceTableViewCellDelegate,catalogdetailsUserTableViewCellDelegate,catalogMoreTableViewCellDelegate,catalogdetailsTableViewCellDelegate,catalogdetailsTagTableViewCellDelegate,catalogCommentTableViewCellDelegate>

@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;
@property (nonatomic,strong)NSMutableArray *commentArray;
@property (nonatomic,strong)NSMutableArray *commentCellArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isOpen;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"图录详情";
    
    _isOpen = NO;
    _commentArray = [[NSMutableArray alloc]init];
    _commentCellArray = [[NSMutableArray alloc]init];
    
    [self CreatUI];
    [self loaddata];
    // Do any additional setup after loading the view.
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
                return _catalogdetailsData.comment.count + 1;
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
                    [cell loadWithstring:[NSString stringWithFormat:@"%@的其他图录",_catalogdetailsData.author] andWitharray:_catalogdetailsData.userInfo_moreCatalog andWithIndexPath:indexPath];

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
                    return 40+116+40+40+16+1;
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
                            if (infosize.height > 35.0f) {
                                return 16+15*4+5*4+35+30;
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
                        return 64 + 10 + 10;
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
            return 56.f;
        }
    }
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.0f;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
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

    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) & (indexPath.row == _commentArray.count)) {
        NSLog(@"我点击了查看更多");
        CommenListViewController *commenlist = [[CommenListViewController alloc]init];
        commenlist.ID = _ID;
        commenlist.catalogData = _catalogdetailsData;
        
        [self.navigationController pushViewController:commenlist animated:YES];
    }
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

#pragma mark - 查看
-(void)handleTap:(UITapGestureRecognizer *)recognizer{
    
    CommenListViewController *commenlist = [[CommenListViewController alloc]init];
    commenlist.ID = _ID;
    commenlist.catalogData = _catalogdetailsData;
    
    [self.navigationController pushViewController:commenlist animated:YES];
            
}

#pragma mark - catalogdetailsTableViewCellDelegate
- (void)hanreadingclick{
    
    ReadingViewController *readingVC = [[ReadingViewController alloc]init];
    readingVC.ID = _ID;
    [self.navigationController pushViewController:readingVC animated:YES];
    
}
- (void)hancataloglistclick{
    CatalogGetListViewController *cataloggetlist = [[CatalogGetListViewController alloc]init];
    cataloggetlist.ID = _ID;
    [self.navigationController pushViewController:cataloggetlist animated:YES];
    
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

@end
