//
//  templateView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/21.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "templateView.h"
#import "ImageBrowser.h"

#import "SDPhotoBrowser.h"

@interface templateView ()<UIScrollViewDelegate,SDPhotoBrowserDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *lefttemplateView;
@property (nonatomic,strong)UIView *centertemplateView;
@property (nonatomic,strong)UIView *righttemplateView;

@property (nonatomic,assign)NSInteger    indexShow;

@end

@implementation templateView

- (instancetype)initWithFrame:(CGRect)frame andWithmutbleArray:(NSMutableArray *)array withContentFont:(CGFloat)contentfont withTitlFont:(CGFloat)titlFont{
    self = [super initWithFrame:frame];
    if (self) {
        self.fontInt = contentfont;
        self.titlFontInt = titlFont;
        _dataarray = array;
        [self loaddata];
        
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andWithmutbleArray:(NSMutableArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.fontInt = Catalog_Cell_Name_Font_big;
        self.titlFontInt = 24;
        _dataarray = array;
        [self loaddata];
//        self.isNigth = [[NSUserDefaults standardUserDefaults] objectForKey:@"IS_NIGHT"];

    }
    return self;
}

- (void)loaddata{
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isNigth = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_NIGHT"];


    self.backgroundColor = Clear_Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handTap:)];
    tap.delegate = self;
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    _indexShow = 0;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*3, 0);
    _scrollView.backgroundColor = Clear_Color;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _lefttemplateView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    if(_dataarray.count > 0){
        [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_lefttemplateView];

    }
//    _lefttemplateView = [self loadarray1:[_dataarray objectAtIndex:_indexShow]];
//    _lefttemplateView.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:_lefttemplateView];
    
    _centertemplateView = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    if (_dataarray.count > 1) {
        [self loadarray:[_dataarray objectAtIndex:1] andWithview:_centertemplateView];
    }
    

//    _centertemplateView = [self loadarray2:[_dataarray objectAtIndex:1]];
//    _centertemplateView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:_centertemplateView];
    
    _righttemplateView = [[UIView alloc]initWithFrame:CGRectMake(2*UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    if (_dataarray.count>2) {
        [self loadarray:[_dataarray objectAtIndex:2] andWithview:_righttemplateView];
    }
    

//    _righttemplateView = [self loadarray3:[_dataarray objectAtIndex:2]];
//    _righttemplateView.backgroundColor = [UIColor redColor];

    [_scrollView addSubview:_righttemplateView];
    
  
}

- (void )loadarray:(NSMutableArray *)array andWithview:(UIView *)view{
//    NSLog(@"kkkkkkkkk:%d",_indexShow);
    CGFloat height = 10.0f;
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSMutableDictionary *dic = array[i];
//        NSLog(@"wwwwwwww->:%@  %ld",dic[@"info"],(long)i);

        
        if (STRING_NOT_EMPTY([dic objectForKey:@"cover"])) {
            
            CGFloat x = [[dic objectForKey:@"img_width"] floatValue];
            CGFloat y = [[dic objectForKey:@"img_height"] floatValue];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH-x)/2, height+10 , x, y)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds  = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"cover"]]];
            
            height = height + y + 15;
            [view addSubview:imageView];
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
            imageTgr.delegate = self;
            [imageView addGestureRecognizer:imageTgr];
//            [ImageBrowser showImage:imageView];
            
        }else if (STRING_NOT_EMPTY([dic objectForKey:@"info"])) {
            
            NSString * textStr = [NSString stringWithFormat:@"%@",dic[@"info"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = lineSpacingValueOne;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:self.fontInt],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            
//            viewtext.text = [dic objectForKey:@"info"];
//            viewtext.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
//            UILabel *viewtext = [[UILabel alloc]init];
//            viewtext.text = [dic objectForKey:@"info"];
//            viewtext.font = [UIFont systemFontOfSize:Catalog_Cell_info_Font];
            NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];

            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
            NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
            [textStorage addLayoutManager:layoutManager];
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
            [textContainer setLineFragmentPadding:lineSpacingValueOne];
            [layoutManager addTextContainer:textContainer];
            [textStorage setAttributedString:attributedString];
            [layoutManager ensureLayoutForTextContainer:textContainer];
            CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
            
            UITextView *viewtext = [[UITextView alloc]initWithFrame:CGRectMake(25, height , TEXT_WIDTH, frame.size.height + 37) textContainer:textContainer];
            viewtext.attributedText = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];

            if (self.isNigth) {
                viewtext.textColor = White_Color;

            }else{
                viewtext.textColor = Essential_Colour;

            }
            viewtext.backgroundColor = Clear_Color;
//            CGSize sizetext = [self String:viewtext.text Withfont:Catalog_Cell_Name_Font WithCGSize:TEXT_WIDTH];
//            CGSize sizetext = [self String:viewtext.text Withfont:self.fontInt WithCGSize:TEXT_WIDTH];
//            viewtext.frame = CGRectMake(25, height , TEXT_WIDTH, frame.size.height);
//            NSLog(@"wwwwwwww->: %f ",viewtext.frame.size.height);
//            viewtext.backgroundColor = [UIColor whiteColor];
            viewtext.editable = NO;
            viewtext.scrollEnabled = NO;//是否可以拖动
//            [viewtext setContentInset:UIEdgeInsetsMake(-10, 0, 0, 0)];//设置UITextView的内边距
            viewtext.textAlignment = NSTextAlignmentLeft;
            viewtext.layoutManager.allowsNonContiguousLayout = NO;
            
            height = height + frame.size.height + 10;
            
            [view addSubview:viewtext];
 

            
        }else if (STRING_NOT_EMPTY([dic objectForKey:@"title"])){
            
            UITextView *viewtext = [[UITextView alloc]init];
            NSString * textStr = [NSString stringWithFormat:@"%@",dic[@"title"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:self.titlFontInt],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            viewtext.attributedText = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];
//            viewtext.text = [dic objectForKey:@"title"];
//            viewtext.font = [UIFont systemFontOfSize:ChapterFont];
//            CGSize sizetext = [self String:viewtext.text Withfont:ChapterFont WithCGSize:TEXT_WIDTH];
            CGSize sizetext = [self String:viewtext.text Withfont:self.titlFontInt WithCGSize:TEXT_WIDTH];

            viewtext.frame = CGRectMake(25, height, TEXT_WIDTH, sizetext.height + 10);
            viewtext.editable = NO;
            viewtext.scrollEnabled = NO;//是否可以拖动
            if (self.isNigth) {
                viewtext.textColor = White_Color;
                
            }else{
                viewtext.textColor = Essential_Colour;
                
            }
//            viewtext.textColor = Essential_Colour;
            viewtext.backgroundColor = Clear_Color;
//            [viewtext setContentInset:UIEdgeInsetsMake(-10, -5, 20, -5)];//设置UITextView的内边距
            viewtext.textAlignment = NSTextAlignmentLeft;
            viewtext.layoutManager.allowsNonContiguousLayout = NO;
            
            height = height + sizetext.height + 5;
            
            [view addSubview:viewtext];
            
        }
        
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = [_scrollView contentOffset];
    
    
    if (_indexShow == 0 && offset.x == UI_SCREEN_WIDTH) {
        [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0) animated:NO];
        _indexShow = (_indexShow + 1)%_dataarray.count;
    }
    if (offset.x > UI_SCREEN_WIDTH && _indexShow > 0) {
        
        
        if (_indexShow == _dataarray.count-2) {
            
            [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH*2, 0) animated:NO];
            
        }else{
            _indexShow = (_indexShow + 1)%_dataarray.count;
            [self reload];
        }
        
    }
    
    if (offset.x < UI_SCREEN_WIDTH && _indexShow > 0) {
        if (_indexShow == 1) {
            
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            _indexShow = (_indexShow + _dataarray.count - 1)%_dataarray.count;
        }else{
            
            _indexShow = (_indexShow + _dataarray.count - 1)%_dataarray.count;
            [self reload];
            
        }
        
    }
    
}

-(void)reloadData{
    NSInteger leftIndex,rightIndex,temIndext;
    //重新设置左右图片
    temIndext = _indexShow;
//    NSLog(@"dddddd:%d",self.fontInt);
    if (_indexShow == 0) {
        leftIndex = 0;
        _indexShow = 1;
        rightIndex = 2;
    }else{
        leftIndex = (long)(_indexShow + _dataarray.count-1) % _dataarray.count;
        rightIndex = (long)(_indexShow + 1) % _dataarray.count;
    }
    
    [_lefttemplateView removeFromSuperview];
    [_centertemplateView removeFromSuperview];
    [_righttemplateView removeFromSuperview];
    
    _lefttemplateView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_lefttemplateView];
    _centertemplateView = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_centertemplateView];
    _righttemplateView = [[UIView alloc]initWithFrame:CGRectMake(2*UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_righttemplateView];
    if(_dataarray.count > 1){
        [self loadarray:[_dataarray objectAtIndex:leftIndex] andWithview:_lefttemplateView];
        [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_centertemplateView];

    }else if (_dataarray.count > 2){
        [self loadarray:[_dataarray objectAtIndex:leftIndex] andWithview:_lefttemplateView];
        [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_centertemplateView];
        [self loadarray:[_dataarray objectAtIndex:rightIndex] andWithview:_righttemplateView];

    }else{
        _indexShow = 0;
        [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_centertemplateView];

    }
    
//    if (leftIndex == 0 && temIndext == 0) {
//        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }else{
//        
//        [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * temIndext , 0) animated:NO];
//    }

}

- (void)reload
{
    NSInteger leftIndex,rightIndex;
    //重新设置左右图片
    leftIndex = (long)(_indexShow + _dataarray.count-1) % _dataarray.count;
    rightIndex = (long)(_indexShow + 1) % _dataarray.count;
    
    [_lefttemplateView removeFromSuperview];
    [_centertemplateView removeFromSuperview];
    [_righttemplateView removeFromSuperview];
    
    _lefttemplateView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_lefttemplateView];
    _centertemplateView = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_centertemplateView];
    _righttemplateView = [[UIView alloc]initWithFrame:CGRectMake(2*UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_righttemplateView];
    
    [self loadarray:[_dataarray objectAtIndex:leftIndex] andWithview:_lefttemplateView];
    [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_centertemplateView];
    [self loadarray:[_dataarray objectAtIndex:rightIndex] andWithview:_righttemplateView];
    
    [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0) animated:NO];
    
}

- (void)goNumberofpages:(NSString *)string{
    
    _indexShow = [string integerValue];
    
    NSInteger leftIndex,rightIndex;
    //重新设置左右图片
    
    if (_indexShow == 0) {
        leftIndex = 0;
        _indexShow = 1;
        rightIndex = 2;
    }else{
        leftIndex = (long)(_indexShow + _dataarray.count-1) % _dataarray.count;
        rightIndex = (long)(_indexShow + 1) % _dataarray.count;
    }
    
    [_lefttemplateView removeFromSuperview];
    [_centertemplateView removeFromSuperview];
    [_righttemplateView removeFromSuperview];
    
    _lefttemplateView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_lefttemplateView];
    _centertemplateView = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_centertemplateView];
    _righttemplateView = [[UIView alloc]initWithFrame:CGRectMake(2*UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView addSubview:_righttemplateView];
    
    [self loadarray:[_dataarray objectAtIndex:leftIndex] andWithview:_lefttemplateView];
    [self loadarray:[_dataarray objectAtIndex:_indexShow] andWithview:_centertemplateView];
    [self loadarray:[_dataarray objectAtIndex:rightIndex] andWithview:_righttemplateView];
    
    if (leftIndex == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else{
        [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0) animated:NO];
    }
    
    
    
}

- (void)handTap:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(handTapVeiw:)]) {
        [_delegate handTapVeiw:tap];
    }
    
}

- (void)imageButtonClicked:(UITapGestureRecognizer *)tap
{
    [ImageBrowser showImage:(UIImageView *)tap.view];

}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
//    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//    return [NSURL URLWithString:urlStr];
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIImageView class]]){
        
        return YES;
        
    }
    
    return YES;
    
}

- (CGSize)String:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName,nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

@end
