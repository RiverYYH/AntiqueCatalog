//
//  TopicSettingViewController.m
//  藏民网
//
//  Created by Hong on 15/3/25.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "TopicSettingViewController.h"
#import "Api.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLRequestSerialization.h"
#import "UIViewController+HUD.h"

@interface TopicSettingViewController ()
{
    UIImageView *_headImageView;
    UIPlaceHolderTextView *_contentTextView;
    UILabel *_countLabel;
    CGFloat _textCount;
    NSString *_topicId;
}
@end

@implementation TopicSettingViewController

- (id)initWithTopicId:(NSString *)topicId
{
    self = [self init];
    if(self) {
        _topicId = topicId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"基本设置";
    self.rightButton.hidden = YES;
    //上传头像
    
    UILabel *line1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, 0.3)];
    line1Label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1Label];
    
    UIView *headImageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1Label.frame), UI_SCREEN_WIDTH, 60)];
    [self.view addSubview:headImageBgView];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    [control addTarget:self action:@selector(headImageClicked) forControlEvents:UIControlEventTouchUpInside];
    [headImageBgView addSubview:control];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    _headImageView.image = [UIImage imageNamed:@"PostWeiBo_tianjiazhaopian"];
    [headImageBgView addSubview:_headImageView];
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 20)];
    imageLabel.text = @"上传头像";
    imageLabel.font = [UIFont systemFontOfSize:15];
    imageLabel.textColor = TITLE_COLOR;
    [headImageBgView addSubview:imageLabel];
    
    UIImageView *jiantouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-20, 25, 10, 10)];
    jiantouImageView.image = [UIImage imageNamed:@"jiantou"];
    [headImageBgView addSubview:jiantouImageView];
    
    UILabel *line2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageBgView.frame), UI_SCREEN_WIDTH, 0.3)];
    line2Label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2Label];
    
    //设置简介
    UILabel *briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(line2Label.frame), UI_SCREEN_WIDTH, 20)];
    briefLabel.text = @"请完善专辑简介，让更多的人参与";
    briefLabel.font = [UIFont systemFontOfSize:10];
    briefLabel.textColor = TITLE_COLOR;
    [self.view addSubview:briefLabel];
    
    _contentTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(briefLabel.frame), UI_SCREEN_WIDTH-10, 100)];
    _contentTextView.placeholder = @"请输入内容";
    _contentTextView.layer.borderWidth = 0.3;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];
    
    UILabel *line4Label = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_contentTextView.frame), UI_SCREEN_WIDTH-10, 0.3)];
    line4Label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line4Label];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-60, CGRectGetMaxY(_contentTextView.frame)+10, 60, 20)];
    _countLabel.text = @"200/200";
    _countLabel.textColor = TITLE_COLOR;
    _countLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_countLabel];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(10, CGRectGetMaxY(_countLabel.frame)+10, UI_SCREEN_WIDTH-20, 40);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:33.0/255.0 blue:17.0/255.0 alpha:1]];
    [saveBtn addTarget:self action:@selector(saveBtnCicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    // Do any additional setup after loading the view.
}

- (void)headImageClicked
{
    [_contentTextView resignFirstResponder];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [LPActionSheetView showInView:self.view title:@"选择方式" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tagNumber:100];
    }
    else{
        
        [LPActionSheetView showInView:self.view title:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册"] tagNumber:101];
        
    }
}
- (void)saveBtnCicked
{
    if(_textCount > 200) {
        [self showHudInView:self.view showHint:@"字数不可超过200哦"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_contentTextView.text forKey:@"des"];
    [params setObject:_topicId forKey:@"topic_id"];
    if ([_headImageView.image isEqual:[UIImage imageNamed:@"PostWeiBo_tianjiazhaopian"]]) {
        if (!STRING_NOT_EMPTY(_contentTextView.text)) {
            [self showHudInView:self.view showHint:@"您没有做任何更改哦"];
        } else {
            [self showHudInView:self.view hint:@"上传中..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [Api requestWithMethod:@"POST" withPath:API_URL_TOPICSETNOTIMAGE withParams:params withSuccess:^(id responseObject) {
                    [self hideHud];
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    if([[dic objectForKey:@"status"] integerValue]) {
                        [self showHudInView:self.view showHint:@"设置成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TOPICSETTINGSUCCED" object:nil userInfo:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self showHudInView:self.view showHint:@"设置失败，请重试"];
                    }
                    
                } withError:^(NSError *error) {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"请检查网络设置"];
                }];
            });
            
        }
    } else {
        [self showHudInView:self.view hint:@"上传中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [NSString stringWithFormat:@"%@%@&oauth_token=%@&oauth_token_secret=%@",HEADURL,API_URL_TOPICSETWITHIMAGE,[[UserModel userPassport] objectForKey:@"oauthToken"],[[UserModel userPassport] objectForKey:@"oauthTokenSecret"]];
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *data = UIImageJPEGRepresentation(_headImageView.image, 0.3);
                [formData appendPartWithFileData:data name:@"1" fileName:@"headImage1.jpg" mimeType:@"image/jpeg"];
            } error:nil];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation start];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self hideHud];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",responseObject);
                if([[dic objectForKey:@"status"] integerValue]) {
                    [self showHudInView:self.view showHint:@"设置成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TOPICSETTINGSUCCED" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [self showHudInView:self.view showHint:@"设置失败，请重试"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        });
    }
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_contentTextView resignFirstResponder];
}

#pragma maek - LPActionSheetViewDelegate
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex
{
    BOOL hasCamera = [UIImagePickerController
                      isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (buttonIndex == 0)
        [self selectPhoto]; // 用户相册
    else if (buttonIndex == 1 && hasCamera)
        [self takePhoto];   // 拍照
}

- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        BOOL canTakePhoto = NO;
        for (NSString *mediaType in availableMediaTypes)
        {
            if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
            {
                canTakePhoto = YES;
                break;
            }
        }
        
        if (canTakePhoto)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            picker.allowsEditing = YES;
            
            picker.delegate = self;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持静态图片"];
        }
    }
    else
    {
        [self showHudInView:self.view showHint:@"设备不支持相机模式"];
    }
}

- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        BOOL selectPhoto = NO;
        for (NSString *mediaType in availableMediaTypes)
        {
            if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
            {
                selectPhoto = YES;
                break;
            }
        }
        
        if (selectPhoto)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持静态图片"];
        }
    }
    else
    {
        [self showHudInView:self.view showHint:@"设备不支持相机模式"];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *editeImage = [info objectForKey:UIImagePickerControllerEditedImage];
        _headImageView.image = editeImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 更新字数
- (void)updateWordCount
{
    _textCount = 0;
    NSString *titleTemp= [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (int index = 0; index < [titleTemp length]; index++)
    {
        NSString *character = [titleTemp substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            _textCount++;
        }
        else
        {
            _textCount = _textCount + 0.5;
        }
    }
    if (_textCount == 0)
    {
        _countLabel.text = @"200/200";
    }
    else
    {
        _countLabel.text = [NSString stringWithFormat:@"%.f/200",200 - _textCount];
        if (200 - _textCount<0)
        {
            _countLabel.textColor = [UIColor redColor];
        }
        else
        {
            _countLabel.textColor = TITLE_COLOR;
        }
    }
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
