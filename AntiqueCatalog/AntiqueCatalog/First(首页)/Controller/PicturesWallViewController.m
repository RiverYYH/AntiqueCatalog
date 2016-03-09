//
//  PicturesWallViewController.m
//  藏民网
//
//  Created by Hong on 15/3/20.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "PicturesWallViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MJDIYGifHeader.h"
#import "MJAutoGifFooter.h"
#import "UIViewController+HUD.h"

@interface PicturesWallViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *_array;
    
//    MJRefreshHeaderView *_header;
//    MJRefreshFooterView *_footer;
    
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    
    CGFloat _leftHeight;
    CGFloat _rightHeight;
    
    NSInteger _num;
    BOOL _isMore;
}
@end

@implementation PicturesWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"图片墙";
    
    _dataArray = [NSMutableArray array];
    _array = [NSMutableArray array];
    _leftArray = [NSMutableArray array];
    _rightArray = [NSMutableArray array];
    
    _leftHeight = 0;
    _rightHeight = 0;
    _num = 0;
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(3, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH/2-4, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.showsHorizontalScrollIndicator = NO;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.tag = 1;
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+1, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH/2-4, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.showsHorizontalScrollIndicator = NO;
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tag = 2;
    [self.view addSubview:_rightTableView];
    
    _isMore = NO;
    _leftTableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        [self loadNewData];
    }];
    _leftTableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        [self loadNewData];
    }];
    
    _rightTableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        [self loadNewData];
    }];
    _rightTableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        [self loadNewData];
    }];

    
    [self showHudInView:self.view hint:@"加载中..."];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_topicName,@"k",nil];
    [Api requestWithMethod:@"GET" withPath:API_URL_TOPICIMAGEWALL withParams:params withSuccess:^(id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        [_dataArray addObjectsFromArray:[[dic objectForKey:@"topic"] objectForKey:@"img"]];
        if(ARRAY_NOT_EMPTY(_dataArray)) {
            NSLog(@"%ld",(unsigned long)_dataArray.count);
            if(_dataArray.count>20){
                for(int i=0; i<20; i++) {
                    [_array addObject:[_dataArray objectAtIndex:i+_num*20]];
                }
            } else {
                [_array addObjectsFromArray:_dataArray];
            }
            [self downloadImage];
        }
    } withError:^(NSError *error) {
        
    }];
    
    // Do any additional setup after loading the view.
}
#pragma mark - MJRefreshBaseViewDelegate

-(void)stopRefreshing
{
    [_leftTableView.header endRefreshing];
    [_leftTableView.footer endRefreshing];
    [_rightTableView.header endRefreshing];
    [_rightTableView.footer endRefreshing];
}
- (void)dealloc
{
    
}
- (void)loadNewData
{
    if(_isMore) {
        _num ++;
        if(_dataArray.count>20){
            if(_num*20 > _dataArray.count) {
                [self downloadImage];
                return;
            }
            for(NSInteger i=_num*20; i<20*_num+20; i++) {
                if(i<_dataArray.count){
                    [_array addObject:[_dataArray objectAtIndex:i]];
                } else {
                    break;
                }
            }
            
        }
        _isMore = NO;
    } else {
        [self stopRefreshing];
    }
    [self downloadImage];
}
- (void)downloadImage
{
    if(_num*20 >= _array.count) {
        [self showHudInView:self.view showHint:@"没有更多了"];
        [self stopRefreshing];
        return;
    }
    for (NSInteger i=_num*20; i<_array.count; i++) {
        UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        NSString *string = [_array objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *re = [NSURLRequest requestWithURL:url];
        [view1 setImageWithURLRequest:re placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSInteger height = image.size.height*UI_SCREEN_WIDTH/2/image.size.width;
            if (_leftHeight > _rightHeight) {
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                [_rightArray addObject:data];
                _rightHeight += height;
            } else {
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                [_leftArray addObject:data];
                _leftHeight += height;
            }
            [_leftTableView reloadData];
            [_rightTableView reloadData];
            if(_leftArray.count+_rightArray.count == _array.count) {
                [self hideHud];
                [self stopRefreshing];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            [self hideHud];
            [self stopRefreshing];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
        [self.view addSubview:view1];
    }
}
#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _leftTableView) {
        if(_leftArray.count) {
            UIImage *image = [UIImage imageWithData:[_leftArray objectAtIndex:indexPath.row]];
            return image.size.height*UI_SCREEN_WIDTH/2/image.size.width;
        } else {
            return 0;
        }
    } else {
        if(_rightArray.count) {
            UIImage *image = [UIImage imageWithData:[_rightArray objectAtIndex:indexPath.row]];
            return image.size.height*UI_SCREEN_WIDTH/2/image.size.width;
        } else {
            return 0;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _leftTableView) {
        return _leftArray.count;
    } else {
        return _rightArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    for(id vc in [cell.contentView subviews]) {
        [vc removeFromSuperview];
    }
    
    if (tableView == _leftTableView) {
        if(_leftArray.count) {
            UIImage *image = [UIImage imageWithData:[_leftArray objectAtIndex:indexPath.row]];
            NSInteger height = image.size.height*UI_SCREEN_WIDTH/2/image.size.width;
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2, height-2)];
            imageview.image = image;
            [cell.contentView addSubview:imageview];
        }
    } else {
        if(_rightArray.count) {
            UIImage *image = [UIImage imageWithData:[_rightArray objectAtIndex:indexPath.row]];
            NSInteger height = image.size.height*UI_SCREEN_WIDTH/2/image.size.width;
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2, height-2)];
            imageview.image = image;
            [cell.contentView addSubview:imageview];
        }
    }
    return cell;
}
#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _leftTableView) {
        _rightTableView.contentOffset = _leftTableView.contentOffset;
    } else {
        _leftTableView.contentOffset = _rightTableView.contentOffset;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if(scrollView == _leftTableView) {
//        _footer.scrollView = _leftTableView;
//        _header.scrollView = _leftTableView;
//    } else {
//        _footer.scrollView = _rightTableView;
//        _header.scrollView = _rightTableView;
//    }
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
