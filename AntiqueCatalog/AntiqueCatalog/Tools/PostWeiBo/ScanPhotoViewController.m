//
//  ScanPhotoViewController.m
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/8/23.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ScanPhotoViewController ()

@end

@implementation ScanPhotoViewController

@synthesize imgArr,index,delegate,isPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	currentIndex = index;
	
	self.titleLabel.text = [NSString stringWithFormat:@"%d/%d",index+1,[imgArr count]];
	if (isPhoto) {
		self.rightButton.hidden = YES;
	}else{
		[self.rightButton setTitle:@"删除" forState:0];
	}
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self initScrollView];
	imgCount = [imgArr count];
}

-(void)initScrollView{
	
	if (_scrollView) {
		for (UIImageView *imageView in _scrollView.subviews) {
			[imageView removeFromSuperview];
		}
	}else{
		_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH+20, UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT))];
		_scrollView.backgroundColor = [UIColor blackColor];
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		_scrollView.tag = 222;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		[self.view addSubview:_scrollView];
	}
	
	_scrollView.contentSize = CGSizeMake((UI_SCREEN_WIDTH+20) * [imgArr count], UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT));
	for (int i = 0; i < [imgArr count]; i ++) {
		float imageWidth,imageHeight;
		UIImage *image;
		if (isPhoto) {
			ALAsset *asset = [imgArr objectAtIndex:i];
			ALAssetRepresentation *representation = [asset defaultRepresentation];
			//获取资源图片的长宽
			imageHeight = [representation dimensions].height/2;
			imageWidth = [representation dimensions].width/2;
			image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
		}else{
			image = [imgArr objectAtIndex:i];
			CGImageRef imageRef = [image CGImage];
			imageWidth = CGImageGetWidth(imageRef)/2;
			imageHeight = CGImageGetHeight(imageRef)/2;
		}

		
		if (imageHeight > 425) {
			imageHeight = 425;
		}
		if (imageWidth > UI_SCREEN_WIDTH) {
			imageWidth = UI_SCREEN_WIDTH;
		}
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH+20)*i, 20, imageWidth, imageHeight)];
		imageView.center = CGPointMake(UI_SCREEN_WIDTH/2+340*i, ((UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT))/2));
		imageView.image = image;
		[_scrollView addSubview:imageView];
	}
    [_scrollView setMinimumZoomScale:50];//设置最小的缩放大小
    [_scrollView setZoomScale:50];//设置scrollview的缩放
	_scrollView.contentOffset = CGPointMake((UI_SCREEN_WIDTH+20)*currentIndex, 0);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	int count = scrollView.contentOffset.x/340;

	self.titleLabel.text = [NSString stringWithFormat:@"%d/%d",count+1,[imgArr count]];
	currentIndex = count;
}

-(void)leftButtonClick:(id)sender
{

	if (imgCount!=[imgArr count])
    {
		if (self.delegate &&[self.delegate respondsToSelector:@selector(sendPhotoArr:)])
        {
			NSMutableArray *array = [NSMutableArray array];
			for (int i=0; i<imgArr.count; i++)
            {
                if ([[imgArr objectAtIndex:i] isKindOfClass:[UIImage class]])
                {
                    [array addObject:imgArr[i]];
                }
                else
                {
                    ALAsset *asset = imgArr[i];
                    [array addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                }
			}
			[self.delegate sendPhotoArr:array];
		}
	}
	[self dismissViewControllerAnimated:YES completion:^{
        
	}];
}

-(void)rightButtonClick:(id)sender{
    [LPActionSheetView showInView:self.view title:@"确定要删除吗" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"删除" otherButtonTitles:nil tagNumber:1];
}

- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView{
	[imgArr removeObjectAtIndex:currentIndex];
    if ([imgArr count]==0) {
        [self leftButtonClick:nil];
        return;
    }
    
    int index1;
    if (currentIndex == 0) {
        index1 = 1;
    }else if (currentIndex == [imgArr count]){
        index1 = [imgArr count];
    }else{
        index1 = currentIndex+1;
    }
    currentIndex = index1-1;
    [self initScrollView];
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%d",index1,[imgArr count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
