//
//  CommenListViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CommenListViewController.h"
#import "catalogCommentTableViewCell.h"
#import "cimmenView.h"
#import "AntiqueCatalogViewCell.h"
#import "catalogdetailsTableViewCell.h"

@interface CommenListViewController ()<UITableViewDataSource,UITableViewDelegate,cimmenViewDelegate,UITextViewDelegate,catalogCommentTableViewCellDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL        isMore;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *commentCellArray;
@property (nonatomic,strong)cimmenView  *cimmenView;

@end

@implementation CommenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"全部评论";
    
    _isMore = NO;
    _dataArray = [[NSMutableArray alloc]init];
    _commentCellArray = [[NSMutableArray alloc]init];
    
    
    [self CreatUI];
    [self loaddata];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 46) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _cimmenView = [[cimmenView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 46, UI_SCREEN_WIDTH, 46)];
    _cimmenView.delegate = self;
    [self.view addSubview:_cimmenView];
}

#pragma mark - cimmenViewDelegate
-(void)TextForComment:(NSString *)commStr{
    NSLog(@"%@",commStr);
    
    NSDictionary *prams = [[NSDictionary alloc]init];
    prams = @{@"cid":_ID,@"content":commStr};
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_addBookComment withParams:prams withSuccess:^(id responseObject) {
        
        _isMore = NO;
        [self loaddata];
        
    } withError:^(NSError *error) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _cimmenView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 46, UI_SCREEN_WIDTH, 46);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [endValue CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        
        _cimmenView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - height - 46, UI_SCREEN_WIDTH, 46);
       
    }];
    
}

- (void)loaddata{
    
    NSDictionary *prams = [[NSDictionary alloc]init];
    if (_isMore) {
        prams = @{@"cid":_ID,@"max_id":@"0"};
    }else{
        prams = @{@"cid":_ID,@"max_id":@"0"};
    }
    
    [Api requestWithbool:NO withMethod:@"get" withPath:API_URL_Catalog_agetCommentList withParams:prams withSuccess:^(id responseObject) {
        
        if (_isMore) {
            
        }else{
            [_dataArray removeAllObjects];
            [_commentCellArray removeAllObjects];
        }
        
        NSLog(@"%@",responseObject);
        if (ARRAY_NOT_EMPTY(responseObject)) {
            for (NSDictionary *dic in responseObject) {
                commentData *commentdata = [commentData WithcommentDataDic:dic];
                
                [_dataArray addObject:commentdata];
                catalogCommentTableViewCell *commentcell = [[catalogCommentTableViewCell alloc]init];
                [_commentCellArray addObject:commentcell];
            }
            [_tableView reloadData];
        }
        
        
    } withError:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0) {
        return _dataArray.count + 1;
    }else{
        return _dataArray.count;

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        
        if (indexPath.row == 0) {
            static NSString *identifier = @"celldetails";
            catalogdetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell.isPingLun = YES;
            if (!cell) {
                
                cell = [[catalogdetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.isPingLun = YES;

            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.catalogdetailsData = self.catalogData;
            NSLog(@"ddddddddd:%@",self.catalogData);
//            cell.delegate = self;
            return cell;

        }else{
            static NSString *identifier = @"cellcomment";
            catalogCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[catalogCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell loadWithCommentArray:_dataArray[indexPath.row-1] andWithIndexPath:indexPath];
            return cell;

        }
        
        return nil;
        
    }else{
        static NSString *identifier = @"cellcomment";
        catalogCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[catalogCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell loadWithCommentArray:_dataArray[indexPath.row] andWithIndexPath:indexPath];
        return cell;

    }
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > 0){
        if (indexPath.row == 0) {
            return 40+116;
            
        }else{
            catalogCommentTableViewCell *commenttableviewcell = _commentCellArray[indexPath.row -1];
            [commenttableviewcell loadWithCommentArray:_dataArray[indexPath.row -1] andWithIndexPath:indexPath];
            return commenttableviewcell.height;
        }
        
    }else{
        catalogCommentTableViewCell *commenttableviewcell = _commentCellArray[indexPath.row];
        [commenttableviewcell loadWithCommentArray:_dataArray[indexPath.row] andWithIndexPath:indexPath];
        return commenttableviewcell.height;
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

#pragma mark-catalogCommentTableViewCellDelegate
-(void)hanisdigg:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    NSDictionary *param = [NSDictionary dictionary];
    NSString *isdiggurl;
    commentData *commentdata = [_dataArray objectAtIndex:indexPath.row -1];
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
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_dataArray insertObject:commentdata atIndex:indexPath.row];
//            if(_dataArray.count == 1){
//                [_tableView reloadData];
//                
//            }else{
//                [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//
//            }
            [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

            
        }
        
        
    } withError:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
