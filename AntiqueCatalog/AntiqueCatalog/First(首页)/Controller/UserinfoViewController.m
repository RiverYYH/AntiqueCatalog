//
//  UserinfoViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/28.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserinfoViewController.h"
#import "nameViewController.h"
#import "introViewController.h"
#import "passwordViewController.h"
#import "LPActionSheetView.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "GDataXMLNode.h"

@interface UserinfoViewController ()<LPActionSheetViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic,strong)UIView *viewimage;
@property (nonatomic,strong)UILabel *headimage;
@property (nonatomic,strong)UIImageView *image;

@property (nonatomic,strong)UIView *nameview;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *nametitle;

@property (nonatomic,strong)UIView  *introview;
@property (nonatomic,strong)UILabel  *intro;
@property (nonatomic,strong)UILabel  *introtitle;

@property (nonatomic,strong)UILabel  *password;

@end

@implementation UserinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeView1:) name:@"makeView1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeView2:) name:@"makeView2" object:nil];
    
    self.titleLabel.text = @"编辑资料";
    
    [self CreatUI];
    // Do any additional setup after loading the view.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeView1" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeView2" object:nil];
}

- (void)makeView1:(NSNotificationCenter *)obj{
    
    _nametitle.text = [[UserModel userUserInfor] objectForKey:@"uname"];
    
}
-(void)makeView2:(NSNotificationCenter *)obj{
    _introtitle.text = [[UserModel userUserInfor] objectForKey:@"intro"];
}

- (void)CreatUI{
    
    self.view.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _viewimage = [[UIView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT + 16, UI_SCREEN_WIDTH, 80)];
    _viewimage.backgroundColor = White_Color;
    _viewimage.userInteractionEnabled = YES;
    _viewimage.tag = 0;
    _headimage = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 80)];
    _headimage.text = @"头像";
    _headimage.textColor = Essential_Colour;
    _headimage.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 54, 16, 48, 48)];
    _image.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"avatar"])) {
        [_image sd_setImageWithURL:[NSURL URLWithString:[[UserModel userUserInfor] objectForKey:@"avatar"]]];
    }
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 24;
    [self.view addSubview:_viewimage];
    [_viewimage addSubview:_headimage];
    [_viewimage addSubview:_image];
    UIButton * imagBtn = [[UIButton alloc] initWithFrame:_image.frame];
    [imagBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_viewimage addSubview:imagBtn];

    
    
    _nameview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewimage.frame)+1, UI_SCREEN_WIDTH, 60)];
    _nameview.backgroundColor = White_Color;
    _nameview.userInteractionEnabled = YES;
    _nameview.tag = 1;
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 60)];
    _name.text = @"昵称";
    _name.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _name.textColor = Essential_Colour;
    
    _nametitle = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 216, 0,200, 60)];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"uname"])) {
        _nametitle.text = [[UserModel userUserInfor] objectForKey:@"uname"];
    }
    _nametitle.textAlignment = NSTextAlignmentRight;
    _nametitle.font = [UIFont systemFontOfSize:Nav_title_font];
    _nametitle.textColor = Deputy_Colour;
    [self.view addSubview:_nameview];
    [_nameview addSubview:_name];
    [_nameview addSubview:_nametitle];
    
    
    
    _introview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameview.frame)+1, UI_SCREEN_WIDTH, 60)];
    _introview.backgroundColor = White_Color;
    _introview.userInteractionEnabled = YES;
    _introview.tag = 2;
    
    _intro = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 60)];
    _intro.text = @"个性签名";
    _intro.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _intro.textColor = Essential_Colour;
    
    _introtitle = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 216, 0,200, 60)];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"intro"])) {
        _introtitle.text = [[UserModel userUserInfor] objectForKey:@"intro"];
    }else{
        _introtitle.text = @"未填写";
    }
    _introtitle.textAlignment = NSTextAlignmentRight;
    _introtitle.font = [UIFont systemFontOfSize:Nav_title_font];
    _introtitle.textColor = Deputy_Colour;
    [self.view addSubview:_introview];
    [_introview addSubview:_intro];
    [_introview addSubview:_introtitle];
    
    
    _password = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_introview.frame)+16,UI_SCREEN_WIDTH, 60)];
    _password.userInteractionEnabled = YES;
    _password.tag = 3;
    _password.text = @"    修改密码";
    _password.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _password.backgroundColor = White_Color;
    _password.textColor = Essential_Colour;
    [self.view addSubview:_password];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_viewimage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_nameview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_introview addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_password addGestureRecognizer:tap3];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            nameViewController *nameVC = [[nameViewController alloc]init];
            [self.navigationController pushViewController:nameVC animated:YES];
        }
            break;
        case 2:
        {
            introViewController *introVC = [[introViewController alloc]init];
            [self.navigationController pushViewController:introVC animated:YES];
        }
            break;
        case 3:
        {
            passwordViewController *passwordVC = [[passwordViewController alloc]init];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
            break;
            
        default:
            break;
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
-(void)imageBtnAction:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [LPActionSheetView showInView:self.view title:@"选择图片" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"相册"] tagNumber:0];
    }
    else
    {
        [LPActionSheetView showInView:self.view title:@"选择图片" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"相册"] tagNumber:0];
    }

}

#pragma mark - LPActionSheetViewDelegate
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheetView.tag == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self takePhoto];
                }
                    break;
                case 1:
                {
                    [self selectPhoto];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            [self selectPhoto];
        }
    }

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
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"11",@"name", nil];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:API_UIL_REGISTERUPLOADAVATAR parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData= UIImageJPEGRepresentation(editeImage, 0.5);
            [formData appendPartWithFileData:imageData name:@"0" fileName:[NSString stringWithFormat:@"image%d.jpg",0] mimeType:@"image/jpeg"];
        } error:nil];
        
        [self showHudInView:self.view hint:@"上传中..."];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            NSLog(@"%@",responseObject);
            NSLog(@"%@",response);
            if ([[response objectForKey:@"status"] intValue] == 1)
            {
                response = response;
                [self hideHud];
                [self showHudInView:self.view showHint:@"上传成功"];
                
                NSString *string = [[response objectForKey:@"data"] objectForKey:@"fullpicurl"];
                string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [_image sd_setImageWithURL:[NSURL URLWithString:string]];
                NSMutableDictionary * mutlDict = [[NSMutableDictionary alloc] initWithDictionary:[UserModel userUserInfor]];
                mutlDict[@"avatar"] = [NSString stringWithFormat:@"%@",string];
                [UserModel saveUserInformationWithdic:mutlDict];
//                NSLog(@"lllllllllll:%@",string);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"upatateHeadImage" object:nil userInfo:mutlDict];

//                [_image sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[NSURL URLWithString:[[UserModel userUserInfor] objectForKey:@"avatar"]]];
//                [_headimage sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Login_chuantouxiang"]];
//                [_headimage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"Login_chuantouxiang"]];
                
            }
            else if ([[response objectForKey:@"status"] intValue] == 0)
            {
                [self hideHud];
                [self showHudInView:self.view showHint:@"上传失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
