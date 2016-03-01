//
//  ParsingData.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ParsingData.h"

@interface ParsingData ()

@property (nonatomic,strong)NSMutableArray    *dataArray;
@property (nonatomic,assign)CGFloat           currentheight;//记录当前
@property (nonatomic,assign)NSRange           range;
@property (nonatomic,assign)BOOL              ishave_chapter;


@end

@implementation ParsingData

- (instancetype )init{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        _chapter_title = [[NSMutableArray alloc]init];
        _chapter_int = [[NSMutableArray alloc]init];

    }
    return self;
}

- (NSMutableArray *)AuctionfromtoMutable:(NSArray *)array withContentFont:(CGFloat)contentFont{
    
    _currentheight = 0.f;
    _range = NSMakeRange(0, 0);
    
    for (NSDictionary *dic in array) {
        
        if (STRING_NOT_EMPTY([dic objectForKey:@"cover"])) {
            
            CGFloat img_width = [[dic objectForKey:@"img_width"] integerValue]/2;
            CGFloat img_height = [[dic objectForKey:@"img_height"] integerValue]/2;
            CGFloat adapter_width;
            CGFloat adapter_height;
            /**
             *    @author huihao, 16-01-20 14:01:58
             *
             *    判读图片的宽高
             */
            if (img_width <= UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40) {
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = img_height * (UI_SCREEN_WIDTH - 40)/img_width;
            }else if (img_width <= UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40){
                adapter_height = UI_SCREEN_HEIGHT - 40;
                adapter_width = adapter_height/img_height*img_width;
            }else if (img_width > UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40){
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }else if (img_width > UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40 && img_width/UI_SCREEN_WIDTH >= img_height/(UI_SCREEN_HEIGHT - 40)){
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }else{
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }
            
            if (UI_SCREEN_HEIGHT - 40 - _currentheight >= (UI_SCREEN_HEIGHT - 40)/3) {
                
                if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                    if (ARRAY_NOT_EMPTY(_dataArray)) {
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        [mutableArray addObject:dicUnit];
                        
                    }else{
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        [_dataArray addObject:unitArray];
                    }
                }else{
                    NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                    NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                    [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",(UI_SCREEN_WIDTH - 40)/3 - 5] forKey:@"img_height"];
                    adapter_height = (UI_SCREEN_HEIGHT - 40)/3 - 5;
                    [mutableArray addObject:dicUnit];
                }
                
            }else{
                
                if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                    if (ARRAY_NOT_EMPTY(_dataArray)) {
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        [mutableArray addObject:dicUnit];
                        
                    }else{
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        [_dataArray addObject:unitArray];
                    }
                }else{
                    _currentheight = 0.f;
                    NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                    [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                    NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                    [unitArray addObject:dicUnit];
                    [_dataArray addObject:unitArray];
                }
            }
            
            _currentheight = _currentheight + adapter_height + 20;
            
        }
        
        
        NSString *describestring = @"";
        
        if (STRING_NOT_EMPTY([dic objectForKey:@"lot"])) {
            describestring = [NSString stringWithFormat:@"%@%@",describestring,[dic objectForKey:@"lot"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"name"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"name"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"author"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"author"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"info"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"info"]];
            
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"price"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"price"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"size"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"size"]];
        }
        
        if ( UI_SCREEN_HEIGHT - 40 - _currentheight <= 20) {
            
            _currentheight = 0.f;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            
            // 2.将字符串封装到TextStorage中
            //            NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring];
            NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
            
            //                [storage beginEditing];
            
            // 3.为TextStorag添加一个LayoutManager
            NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
            [storage addLayoutManager:layoutManager];
            
            while ( YES )
            {
                
                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                [layoutManager addTextContainer:textContainer];
                
                // 5.绑定TextContainer到TextView上
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                
                // 排版结束的判断
                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                
                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                
                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                [unitArray addObject:dicUnit];
                [_dataArray addObject:unitArray];
                
                if ( _range.length + _range.location == describestring.length )
                    break;
            }
            
            NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range] ];
            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
            
            NSDictionary *attributesOne = @{
                                            NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                            };
            
            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
            
            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
            [textStorage addLayoutManager:layoutManagerOne];
            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
            [textContainerOne setLineFragmentPadding:lineSpacingValue];
            [layoutManagerOne addTextContainer:textContainerOne];
            [textStorage setAttributedString:attributedStringone];
            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
            
            CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:contentFont WithCGSize:TEXT_WIDTH];
            //            _currentheight = _currentheight + rangesize.height + 20;
            _currentheight = _currentheight + frame.size.height + 20;
            
            _range = NSMakeRange(0,0);
            
        }else{
            
            _ishave_chapter = YES;
            
            if (_ishave_chapter == YES) {
                
                // 2.将字符串封装到TextStorage中
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                
                NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                //                [storage beginEditing];
                
                // 3.为TextStorag添加一个LayoutManager
                NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                [storage addLayoutManager:layoutManager];
                
                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                [layoutManager addTextContainer:textContainer];
                [textContainer setLineFragmentPadding:lineSpacingValueOne];
                [layoutManager ensureLayoutForTextContainer:textContainer];
                
                // 5.绑定TextContainer到TextView上
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                textView.font = [UIFont systemFontOfSize:contentFont];
                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                
                // 排版结束的判断
                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                
                _ishave_chapter = NO;
                
                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                [mutableArray addObject:dicUnit];
                
            }
            if (_ishave_chapter == NO) {
                
                if (_range.length < describestring.length) {
                    NSString *remaining_content_string = [describestring substringFromIndex:_range.length];
                    //                NSLog(@"%d",remaining_content_string.length);
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 };
                    // 2.将字符串封装到TextStorage中
                    NSTextStorage *storage = [[NSTextStorage alloc]initWithString:remaining_content_string attributes:attributes];
                    
                    // 3.为TextStorag添加一个LayoutManager
                    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                    [storage addLayoutManager:layoutManager];
                    
                    while ( YES )
                    {
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                        [layoutManager addTextContainer:textContainer];
                        [textContainer setLineFragmentPadding:lineSpacingValueOne];
                        [layoutManager ensureLayoutForTextContainer:textContainer];
                        
                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        NSLog(@"eeeeeeeee: %@",remaining_content_string);
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[remaining_content_string substringWithRange:_range] forKey:@"info"];
                        NSLog(@"eeeeeeeee: %@",[remaining_content_string substringWithRange:_range]);
                        
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        
                        [_dataArray addObject:unitArray];
                        
                        if ( _range.length + _range.location == remaining_content_string.length )
                            break;
                    }
                    
                    NSMutableArray *mutarray = [_dataArray lastObject];
                    NSMutableDictionary *mutdic = [mutarray lastObject];
                    NSString *string = [mutdic objectForKey:@"info"];
                    NSLog(@"dddddddddddd:%@",string);
                    NSString * textStr = [NSString stringWithFormat:@"%@",string];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                    NSParagraphStyleAttributeName:paragraphStyleOne
                                                    };
                    
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorage addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValue];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorage setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                    
                    
                    CGSize rangesize = [self String:string Withfont:contentFont WithCGSize:TEXT_WIDTH];
                    //                    _currentheight = rangesize.height + 20;
                    _currentheight = frame.size.height + 20;
                    _range = NSMakeRange(0,0);
                }else{
                    //                    CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
                    NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                    NSParagraphStyleAttributeName:paragraphStyleOne
                                                    };
                    
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorageOne = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorageOne addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValueOne];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorageOne setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                    _currentheight = _currentheight + frame.size.height ;
                    
                    //                    _currentheight = _currentheight + rangesize.height + 20;
                }
            }
            
        }
        
    }
    return _dataArray;
    
}

- (NSMutableArray *)AuctionfromtoMutable:(NSArray *)array{
    
    _currentheight = 0.f;
    _range = NSMakeRange(0, 0);
    
    for (NSDictionary *dic in array) {
        
        if (STRING_NOT_EMPTY([dic objectForKey:@"cover"])) {
            
            CGFloat img_width = [[dic objectForKey:@"img_width"] integerValue]/2;
            CGFloat img_height = [[dic objectForKey:@"img_height"] integerValue]/2;
            CGFloat adapter_width;
            CGFloat adapter_height;
            /**
             *    @author huihao, 16-01-20 14:01:58
             *
             *    判读图片的宽高
             */
            if (img_width <= UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40) {
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = img_height * (UI_SCREEN_WIDTH - 40)/img_width;
            }else if (img_width <= UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40){
                adapter_height = UI_SCREEN_HEIGHT - 40;
                adapter_width = adapter_height/img_height*img_width;
            }else if (img_width > UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40){
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }else if (img_width > UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40 && img_width/UI_SCREEN_WIDTH >= img_height/(UI_SCREEN_HEIGHT - 40)){
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }else{
                adapter_width = UI_SCREEN_WIDTH - 40;
                adapter_height = adapter_width/img_width*img_height;
            }
            
            if (UI_SCREEN_HEIGHT - 40 - _currentheight >= (UI_SCREEN_HEIGHT - 40)/3) {
                
                if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                    if (ARRAY_NOT_EMPTY(_dataArray)) {
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        [mutableArray addObject:dicUnit];
                        
                    }else{
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        [_dataArray addObject:unitArray];
                    }
                }else{
                    NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                    NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                    [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",(UI_SCREEN_WIDTH - 40)/3 - 5] forKey:@"img_height"];
                    adapter_height = (UI_SCREEN_HEIGHT - 40)/3 - 5;
                    [mutableArray addObject:dicUnit];
                }
                
            }else{
                
                if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                    if (ARRAY_NOT_EMPTY(_dataArray)) {
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        [mutableArray addObject:dicUnit];
                        
                    }else{
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                        [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        [_dataArray addObject:unitArray];
                    }
                }else{
                    _currentheight = 0.f;
                    NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                    [dicUnit setValue:[dic objectForKey:@"cover"] forKey:@"cover"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                    [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                    NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                    [unitArray addObject:dicUnit];
                    [_dataArray addObject:unitArray];
                }
            }
            
            _currentheight = _currentheight + adapter_height + 20;
            
        }

   
        NSString *describestring = @"";
        
        if (STRING_NOT_EMPTY([dic objectForKey:@"lot"])) {
            describestring = [NSString stringWithFormat:@"%@%@",describestring,[dic objectForKey:@"lot"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"name"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"name"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"author"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"author"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"info"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"info"]];
            
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"price"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"price"]];
        }
        if (STRING_NOT_EMPTY([dic objectForKey:@"size"])) {
            describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[dic objectForKey:@"size"]];
        }
        
        if ( UI_SCREEN_HEIGHT - 40 - _currentheight <= 20) {
            
            _currentheight = 0.f;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            
            // 2.将字符串封装到TextStorage中
//            NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring];
            NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];

            //                [storage beginEditing];
            
            // 3.为TextStorag添加一个LayoutManager
            NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
            [storage addLayoutManager:layoutManager];
            
            while ( YES )
            {
                
                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                [layoutManager addTextContainer:textContainer];
                
                // 5.绑定TextContainer到TextView上
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                
                // 排版结束的判断
                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                
                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                
                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                [unitArray addObject:dicUnit];
                [_dataArray addObject:unitArray];
                
                if ( _range.length + _range.location == describestring.length )
                    break;
            }
            
            NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range] ];
            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
            
            NSDictionary *attributesOne = @{
                                            NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                            };
            
            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
            
            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
            [textStorage addLayoutManager:layoutManagerOne];
            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
            [textContainerOne setLineFragmentPadding:lineSpacingValue];
            [layoutManagerOne addTextContainer:textContainerOne];
            [textStorage setAttributedString:attributedStringone];
            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
            
            CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
//            _currentheight = _currentheight + rangesize.height + 20;
            _currentheight = _currentheight + frame.size.height + 20;

            _range = NSMakeRange(0,0);
  
        }else{
            
            _ishave_chapter = YES;
            
            if (_ishave_chapter == YES) {
                
                // 2.将字符串封装到TextStorage中
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                
                NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                //                [storage beginEditing];
                
                // 3.为TextStorag添加一个LayoutManager
                NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                [storage addLayoutManager:layoutManager];
                
                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                [layoutManager addTextContainer:textContainer];
                
                [textContainer setLineFragmentPadding:lineSpacingValueOne];
                [layoutManager ensureLayoutForTextContainer:textContainer];

                // 5.绑定TextContainer到TextView上
                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                
                // 排版结束的判断
                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                
                _ishave_chapter = NO;
                
                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                [mutableArray addObject:dicUnit];
                
            }
            if (_ishave_chapter == NO) {
                
                if (_range.length < describestring.length) {
                    NSString *remaining_content_string = [describestring substringFromIndex:_range.length];
                    //                NSLog(@"%d",remaining_content_string.length);
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 };
                    // 2.将字符串封装到TextStorage中
                    NSTextStorage *storage = [[NSTextStorage alloc]initWithString:remaining_content_string attributes:attributes];
                    
                    // 3.为TextStorag添加一个LayoutManager
                    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                    [storage addLayoutManager:layoutManager];
                    
                    while ( YES )
                    {
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                        [layoutManager addTextContainer:textContainer];
                        [textContainer setLineFragmentPadding:lineSpacingValueOne];
                        [layoutManager ensureLayoutForTextContainer:textContainer];
                        
                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        NSLog(@"eeeeeeeee: %@",remaining_content_string);
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[remaining_content_string substringWithRange:_range] forKey:@"info"];
                        NSLog(@"eeeeeeeee: %@",[remaining_content_string substringWithRange:_range]);

                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];

                        [_dataArray addObject:unitArray];
                        
                        if ( _range.length + _range.location == remaining_content_string.length )
                            break;
                    }
                    
                    NSMutableArray *mutarray = [_dataArray lastObject];
                    NSMutableDictionary *mutdic = [mutarray lastObject];
                    NSString *string = [mutdic objectForKey:@"info"];
                    NSLog(@"dddddddddddd:%@",string);
                    NSString * textStr = [NSString stringWithFormat:@"%@",string];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                 NSParagraphStyleAttributeName:paragraphStyleOne
                                                 };
                    
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorage addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValue];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorage setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];

                    
                    CGSize rangesize = [self String:string Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
//                    _currentheight = rangesize.height + 20;
                    _currentheight = frame.size.height + 20;
                    _range = NSMakeRange(0,0);
                }else{
//                    CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
                    NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                    NSParagraphStyleAttributeName:paragraphStyleOne
                                                    };
                    
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorageOne = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorageOne addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValueOne];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorageOne setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                    _currentheight = _currentheight + frame.size.height ;

//                    _currentheight = _currentheight + rangesize.height + 20;
                }
            }

        }
  
    }
    return _dataArray;
    
}

- (NSMutableArray *)YesChapterAuctionfromtoMutable:(NSArray *)array withContenFont:(CGFloat)contentFont{
    
    _currentheight = 0.f;
    _range = NSMakeRange(0, 0);
    
    for (NSDictionary *unitarray in array) {
        
        _currentheight = 0.f;
        _range = NSMakeRange(0, 0);
        //        NSLog(@"%@",unitarray);
        
        
        if (STRING_NOT_EMPTY([unitarray objectForKey:@"title"])) {
            NSString *chapter_string = [unitarray objectForKey:@"title"];
            CGSize chaptersize = [self String:chapter_string Withfont:ChapterFont WithCGSize:UI_SCREEN_WIDTH - 40];
            
            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
            [dicUnit setValue:[unitarray objectForKey:@"title"] forKey:@"title"];
            NSMutableArray *unitArray = [[NSMutableArray alloc]init];
            [unitArray addObject:dicUnit];
            
            [_dataArray addObject:unitArray];
            
            [_chapter_title addObject:[unitarray objectForKey:@"title"]];
            [_chapter_int addObject:[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count-1]];
            
            _currentheight = _currentheight + chaptersize.height +20;
            
        }
        
        if (ARRAY_NOT_EMPTY([unitarray objectForKey:@"value"])) {
            for (NSDictionary *unitdic in [unitarray objectForKey:@"value"]) {
                
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"cover"])) {
                    
                    CGFloat img_width = [[unitdic objectForKey:@"img_width"] integerValue]/2;
                    CGFloat img_height = [[unitdic objectForKey:@"img_height"] integerValue]/2;
                    CGFloat adapter_width;
                    CGFloat adapter_height;
                    /**
                     *    @author huihao, 16-01-20 14:01:58
                     *
                     *    判读图片的宽高
                     */
                    if (img_width <= UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40) {
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = img_height * (UI_SCREEN_WIDTH - 40)/img_width;
                    }else if (img_width <= UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else if (img_width > UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else if (img_width > UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40 && img_width/UI_SCREEN_WIDTH >= img_height/(UI_SCREEN_HEIGHT - 40)){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else{
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }
                    
                    if (UI_SCREEN_HEIGHT - 40 - _currentheight >= (UI_SCREEN_HEIGHT - 40)/3 ) {
                        
                        if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                            if (ARRAY_NOT_EMPTY(_dataArray)) {
                                
                                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                [mutableArray addObject:dicUnit];
                                
                            }else{
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                [_dataArray addObject:unitArray];
                            }
                        }else{
                            NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                            [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",(UI_SCREEN_HEIGHT - 40)/3 - 5] forKey:@"img_height"];
                            adapter_height = (UI_SCREEN_HEIGHT - 40)/3 - 5;
                            [mutableArray addObject:dicUnit];
                        }
                        
                    }else{
                        
                        if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                            if (ARRAY_NOT_EMPTY(_dataArray)) {
                                
                                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                [mutableArray addObject:dicUnit];
                                
                            }else{
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                [_dataArray addObject:unitArray];
                            }
                        }else{
                            _currentheight = 0.f;
                            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                            [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                            NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                            [unitArray addObject:dicUnit];
                            [_dataArray addObject:unitArray];
                        }
                        
                        
                    }
                    
                    _currentheight = _currentheight + adapter_height + 20;
                    
                }
                
                
                NSString *describestring = @"";
                
                
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"name"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"name"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"author"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"author"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"info"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"info"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"price"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"price"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"size"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"size"]];
                }
                
                
                
                if ( UI_SCREEN_HEIGHT - 40 - _currentheight <= 20) {
                    
                    _currentheight = 0.f;
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 };
                    // 2.将字符串封装到TextStorage中
                    NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                    //                [storage beginEditing];
                    
                    // 3.为TextStorag添加一个LayoutManager
                    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                    [storage addLayoutManager:layoutManager];
                    
                    while ( YES )
                    {
                        
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                        [layoutManager addTextContainer:textContainer];
                        
                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:contentFont];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];
                        
                        [_dataArray addObject:unitArray];
                        
                        if ( _range.length + _range.location == describestring.length )
                            break;
                    }
                    
                    NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                    NSParagraphStyleAttributeName:paragraphStyleOne
                                                    };
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorage addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValue];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorage setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                    
                    
                    CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:contentFont WithCGSize:TEXT_WIDTH];
//                    _currentheight = _currentheight + rangesize.height + 20;
                    _currentheight = _currentheight + frame.size.height + 20;

                    _range = NSMakeRange(0,0);
                    
                }else{
                    
                    _ishave_chapter = YES;
                    
                    if (_ishave_chapter == YES) {
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                        
                        NSDictionary *attributes = @{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:contentFont],
                                                     NSParagraphStyleAttributeName:paragraphStyle
                                                     };
                        // 2.将字符串封装到TextStorage中
                        NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                        //                [storage beginEditing];
                        
                        // 3.为TextStorag添加一个LayoutManager
                        NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                        [storage addLayoutManager:layoutManager];
                        
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                        [layoutManager addTextContainer:textContainer];
                        [textContainer setLineFragmentPadding:lineSpacingValueOne];
                        [layoutManager ensureLayoutForTextContainer:textContainer];
                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:contentFont];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        
                        _ishave_chapter = NO;
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                        [mutableArray addObject:dicUnit];
                        
                    }
                    if (_ishave_chapter == NO) {
                        
                        if (_range.length < describestring.length) {
                            /**
                             *    @author huihao, 16-01-22 18:01:13
                             *
                             *    重新开一页,让_currentheight归0
                             */
                            _currentheight = 0.f;
                            
                            NSString *remaining_content_string = [describestring substringFromIndex:_range.length];
                            //                NSLog(@"%d",remaining_content_string.length);
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributes = @{
                                                         NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                         NSParagraphStyleAttributeName:paragraphStyle
                                                         };
                            
                            // 2.将字符串封装到TextStorage中
                            NSTextStorage *storage1 = [[NSTextStorage alloc]initWithString:remaining_content_string attributes:attributes];
                            
                            // 3.为TextStorag添加一个LayoutManager
                            NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                            [storage1 addLayoutManager:layoutManager];
                            
                            while ( YES )
                            {
                                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                                [layoutManager addTextContainer:textContainer];
                                [textContainer setLineFragmentPadding:lineSpacingValueOne];
                                [layoutManager ensureLayoutForTextContainer:textContainer];
                                // 5.绑定TextContainer到TextView上
                                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                                textView.font = [UIFont systemFontOfSize:contentFont];
                                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                                
                                // 排版结束的判断
                                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[remaining_content_string substringWithRange:_range] forKey:@"info"];
                                
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                
                                
                                [_dataArray addObject:unitArray];
                                
                                if ( _range.length + _range.location == remaining_content_string.length )
                                    break;
                            }
                            
                            NSMutableArray *mutarray = [_dataArray lastObject];
                            NSMutableDictionary *mutdic = [mutarray lastObject];
                            NSString *string = [mutdic objectForKey:@"info"];
                            
                            NSString * textStr = [NSString stringWithFormat:@"%@",string];
                            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributesOne = @{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                                            };
                            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                            
                            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                            [textStorage addLayoutManager:layoutManagerOne];
                            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                            [textContainerOne setLineFragmentPadding:lineSpacingValue];
                            [layoutManagerOne addTextContainer:textContainerOne];
                            [textStorage setAttributedString:attributedStringone];
                            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                            
                            
                            CGSize rangesize = [self String:string Withfont:contentFont WithCGSize:TEXT_WIDTH];
//                            _currentheight = rangesize.height + 20;
                            _currentheight = frame.size.height + 20;

                            _range = NSMakeRange(0,0);
                            
                            
                        }else{
                            
                            NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributesOne = @{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                                            };
                            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                            
                            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                            [textStorage addLayoutManager:layoutManagerOne];
                            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                            [textContainerOne setLineFragmentPadding:lineSpacingValue];
                            [layoutManagerOne addTextContainer:textContainerOne];
                            [textStorage setAttributedString:attributedStringone];
                            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                            
//                            CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:contentFont WithCGSize:TEXT_WIDTH];
//                            _currentheight = _currentheight + rangesize.height + 20;
                            _currentheight = _currentheight + frame.size.height + 20;

                            
                        }
                    }
                    
                }
                
                
            }
        }
        
    }
    
    return _dataArray;
}

- (NSMutableArray *)YesChapterAuctionfromtoMutable:(NSArray *)array{
    
    _currentheight = 0.f;
    _range = NSMakeRange(0, 0);
    
    for (NSDictionary *unitarray in array) {
        
        _currentheight = 0.f;
        _range = NSMakeRange(0, 0);
//        NSLog(@"%@",unitarray);
        
        
        if (STRING_NOT_EMPTY([unitarray objectForKey:@"title"])) {
            NSString *chapter_string = [unitarray objectForKey:@"title"];
            CGSize chaptersize = [self String:chapter_string Withfont:ChapterFont WithCGSize:UI_SCREEN_WIDTH - 40];
            
            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
            [dicUnit setValue:[unitarray objectForKey:@"title"] forKey:@"title"];
            NSMutableArray *unitArray = [[NSMutableArray alloc]init];
            [unitArray addObject:dicUnit];

            [_dataArray addObject:unitArray];
            
            [_chapter_title addObject:[unitarray objectForKey:@"title"]];
            [_chapter_int addObject:[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count-1]];
            
            _currentheight = _currentheight + chaptersize.height +20;
            
        }
        
        if (ARRAY_NOT_EMPTY([unitarray objectForKey:@"value"])) {
            for (NSDictionary *unitdic in [unitarray objectForKey:@"value"]) {
                
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"cover"])) {
                    
                    CGFloat img_width = [[unitdic objectForKey:@"img_width"] integerValue]/2;
                    CGFloat img_height = [[unitdic objectForKey:@"img_height"] integerValue]/2;
                    CGFloat adapter_width;
                    CGFloat adapter_height;
                    /**
                     *    @author huihao, 16-01-20 14:01:58
                     *
                     *    判读图片的宽高
                     */
                    if (img_width <= UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40) {
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = img_height * (UI_SCREEN_WIDTH - 40)/img_width;
                    }else if (img_width <= UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else if (img_width > UI_SCREEN_WIDTH && img_height <= UI_SCREEN_HEIGHT - 40){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else if (img_width > UI_SCREEN_WIDTH && img_height > UI_SCREEN_HEIGHT - 40 && img_width/UI_SCREEN_WIDTH >= img_height/(UI_SCREEN_HEIGHT - 40)){
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }else{
                        adapter_width = UI_SCREEN_WIDTH - 40;
                        adapter_height = adapter_width/img_width*img_height;
                    }
                    
                    if (UI_SCREEN_HEIGHT - 40 - _currentheight >= (UI_SCREEN_HEIGHT - 40)/3 ) {
                        
                        if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                            if (ARRAY_NOT_EMPTY(_dataArray)) {
                                
                                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                [mutableArray addObject:dicUnit];
                                
                            }else{
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                [_dataArray addObject:unitArray];
                            }
                        }else{
                            NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                            [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",(UI_SCREEN_HEIGHT - 40)/3 - 5] forKey:@"img_height"];
                            adapter_height = (UI_SCREEN_HEIGHT - 40)/3 - 5;
                            [mutableArray addObject:dicUnit];
                        }
                        
                    }else{
                        
                        if (adapter_height <= UI_SCREEN_HEIGHT - 40 - _currentheight) {
                            if (ARRAY_NOT_EMPTY(_dataArray)) {
                                
                                NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                [mutableArray addObject:dicUnit];
                                
                            }else{
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                                [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                [_dataArray addObject:unitArray];
                            }
                        }else{
                            _currentheight = 0.f;
                            NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                            [dicUnit setValue:[unitdic objectForKey:@"cover"] forKey:@"cover"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_width] forKey:@"img_width"];
                            [dicUnit setValue:[NSString stringWithFormat:@"%f",adapter_height] forKey:@"img_height"];
                            NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                            [unitArray addObject:dicUnit];
                            [_dataArray addObject:unitArray];
                        }

                        
                    }
                    
                    _currentheight = _currentheight + adapter_height + 20;
                    
                }
                
                
                NSString *describestring = @"";
                
                
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"name"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"name"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"author"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"author"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"info"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"info"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"price"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"price"]];
                }
                if (STRING_NOT_EMPTY([unitdic objectForKey:@"size"])) {
                    describestring = [NSString stringWithFormat:@"%@\n%@",describestring,[unitdic objectForKey:@"size"]];
                }
                
                
                
                if ( UI_SCREEN_HEIGHT - 40 - _currentheight <= 20) {
                    
                    _currentheight = 0.f;
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 };
                    // 2.将字符串封装到TextStorage中
                    NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                    //                [storage beginEditing];
                    
                    // 3.为TextStorag添加一个LayoutManager
                    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                    [storage addLayoutManager:layoutManager];
                    
                    while ( YES )
                    {
                        
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                        [layoutManager addTextContainer:textContainer];
                        
                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                        NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                        [unitArray addObject:dicUnit];

                        [_dataArray addObject:unitArray];
                        
                        if ( _range.length + _range.location == describestring.length )
                            break;
                    }
                    
                    NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                    
                    NSDictionary *attributesOne = @{
                                                    NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                    NSParagraphStyleAttributeName:paragraphStyleOne
                                                    };
                    NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                    
                    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                    NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                    [textStorage addLayoutManager:layoutManagerOne];
                    NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                    [textContainerOne setLineFragmentPadding:lineSpacingValue];
                    [layoutManagerOne addTextContainer:textContainerOne];
                    [textStorage setAttributedString:attributedStringone];
                    [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                    CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                    
                    CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
//                    _currentheight = _currentheight + rangesize.height + 20;
                    _currentheight = _currentheight + frame.size.height + 20;

                    _range = NSMakeRange(0,0);
                    
                }else{
                    
                    _ishave_chapter = YES;
                    
                    if (_ishave_chapter == YES) {
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                        
                        NSDictionary *attributes = @{
                                                     NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                     NSParagraphStyleAttributeName:paragraphStyle
                                                     };
                        // 2.将字符串封装到TextStorage中
                        NSTextStorage *storage = [[NSTextStorage alloc]initWithString:describestring attributes:attributes];
                        //                [storage beginEditing];
                        
                        // 3.为TextStorag添加一个LayoutManager
                        NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                        [storage addLayoutManager:layoutManager];
                        
                        // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                        NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, UI_SCREEN_HEIGHT - 40 - _currentheight)];
                        [layoutManager addTextContainer:textContainer];
                        
                        [textContainer setLineFragmentPadding:lineSpacingValueOne];
                        [layoutManager ensureLayoutForTextContainer:textContainer];

                        // 5.绑定TextContainer到TextView上
                        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                        textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                        //        NSLog(@"%lu",(unsigned long)textView.text.length);
                        
                        // 排版结束的判断
                        _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                        
                        _ishave_chapter = NO;
                        
                        NSMutableArray *mutableArray = (NSMutableArray *)[_dataArray lastObject];
                        NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                        [dicUnit setValue:[describestring substringWithRange:_range] forKey:@"info"];
                        [mutableArray addObject:dicUnit];
                        
                    }
                    if (_ishave_chapter == NO) {
                        
                        if (_range.length < describestring.length) {
                            /**
                             *    @author huihao, 16-01-22 18:01:13
                             *
                             *    重新开一页,让_currentheight归0
                             */
                            _currentheight = 0.f;
                            
                            NSString *remaining_content_string = [describestring substringFromIndex:_range.length];
                            //                NSLog(@"%d",remaining_content_string.length);
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyle.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributes = @{
                                                         NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                         NSParagraphStyleAttributeName:paragraphStyle
                                                         };
                            
                            // 2.将字符串封装到TextStorage中
                            NSTextStorage *storage1 = [[NSTextStorage alloc]initWithString:remaining_content_string attributes:attributes];
                            
                            // 3.为TextStorag添加一个LayoutManager
                            NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
                            [storage1 addLayoutManager:layoutManager];
                            
                            while ( YES )
                            {
                                // 4.将有准确矩形大小的TextContainer添加到LayoutManager上
                                NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                                [layoutManager addTextContainer:textContainer];
                                [textContainer setLineFragmentPadding:lineSpacingValueOne];
                                [layoutManager ensureLayoutForTextContainer:textContainer];
                                
                                // 5.绑定TextContainer到TextView上
                                UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0 , 0, TEXT_WIDTH , UI_SCREEN_HEIGHT - 40 - _currentheight ) textContainer:textContainer];
                                textView.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font_big];
                                //        NSLog(@"%lu",(unsigned long)textView.text.length);
                                
                                // 排版结束的判断
                                _range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
                                
                                NSMutableDictionary *dicUnit = [[NSMutableDictionary alloc]init];
                                [dicUnit setValue:[remaining_content_string substringWithRange:_range] forKey:@"info"];
                                
                                NSMutableArray *unitArray = [[NSMutableArray alloc]init];
                                [unitArray addObject:dicUnit];
                                

                                [_dataArray addObject:unitArray];
                                
                                if ( _range.length + _range.location == remaining_content_string.length )
                                    break;
                            }
                            
                            NSMutableArray *mutarray = [_dataArray lastObject];
                            NSMutableDictionary *mutdic = [mutarray lastObject];
                            NSString *string = [mutdic objectForKey:@"info"];
                            NSString * textStr = [NSString stringWithFormat:@"%@",string];
                            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributesOne = @{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                                            };
                            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                            
                            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                            [textStorage addLayoutManager:layoutManagerOne];
                            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                            [textContainerOne setLineFragmentPadding:lineSpacingValue];
                            [layoutManagerOne addTextContainer:textContainerOne];
                            [textStorage setAttributedString:attributedStringone];
                            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                            
                            CGSize rangesize = [self String:string Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
//                            _currentheight = rangesize.height + 20;
                            _currentheight = frame.size.height + 20;

                            _range = NSMakeRange(0,0);
                            
                            
                        }else{
                            
                            NSString * textStr = [NSString stringWithFormat:@"%@",[describestring substringWithRange:_range]];
                            NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyleOne.lineSpacing = lineSpacingValue;// 字体的行间距
                            
                            NSDictionary *attributesOne = @{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:Catalog_Cell_Name_Font_big],
                                                            NSParagraphStyleAttributeName:paragraphStyleOne
                                                            };
                            NSAttributedString * attributedStringone= [[NSAttributedString alloc] initWithString:textStr attributes:attributesOne];
                            
                            NSTextStorage *textStorage = [[NSTextStorage alloc] init];
                            NSLayoutManager *layoutManagerOne = [[NSLayoutManager alloc] init];
                            [textStorage addLayoutManager:layoutManagerOne];
                            NSTextContainer *textContainerOne = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
                            [textContainerOne setLineFragmentPadding:lineSpacingValue];
                            [layoutManagerOne addTextContainer:textContainerOne];
                            [textStorage setAttributedString:attributedStringone];
                            [layoutManagerOne ensureLayoutForTextContainer:textContainerOne];
                            CGRect frame = [layoutManagerOne usedRectForTextContainer:textContainerOne];
                            
                            CGSize rangesize = [self String:[describestring substringWithRange:_range] Withfont:Catalog_Cell_Name_Font_big WithCGSize:TEXT_WIDTH];
//                            _currentheight = _currentheight + rangesize.height + 20;
                            
                            _currentheight = _currentheight + frame.size.height + 20;

                            
                        }
                    }
                    
                }

                
            }
        }

    }
    
    return _dataArray;
}

- (CGSize)String:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width
{
//    NSString * textStr = [NSString stringWithFormat:@"%@",string];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = lineSpacingValueOne;// 字体的行间距
//    
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:font],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//
//    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];
//    
//    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
//    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
//    [textStorage addLayoutManager:layoutManager];
//    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(TEXT_WIDTH, FLT_MAX)];
//    [textContainer setLineFragmentPadding:lineSpacingValueOne];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage setAttributedString:attributedString];
//    [layoutManager ensureLayoutForTextContainer:textContainer];
//    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName,nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//    return frame.size;
    return size;
}

@end
