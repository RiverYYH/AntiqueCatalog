//
//  CustomTextView.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/10.
//  Copyright © 2016年 Cangmin. All rights reserved.
//



#import "CustomTextView.h"

@interface CustomTextView ()<UITextViewDelegate>{
    float heightText;//文字高度
    float currentLineNum;//当前文本框高度
    UILabel * label;
}

@end


@implementation CustomTextView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self initTextViewFrame:frame];
    }
    return self;
}

-(void)initTextViewFrame:(CGRect)frame{
    currentLineNum=1;//默认文本框显示一行文字
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(2, 2, frame.size.width-2*2, frame.size.height-2*2)];
    self.textView.delegate=self;
    self.textView.font = [UIFont systemFontOfSize:14.0];

    [self addSubview:self.textView];
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize contentSize=[@"我" sizeWithAttributes:dict];
    heightText=contentSize.height;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 200, frame.size.height)];
    label.enabled = NO;
    label.text = @"在此输入反馈意见";
    label.font =  [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:label];

}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString * textStr = [NSString stringWithFormat:@"%@",self.textView.text];
//    NSLog(@"wwwwwwwww->:%@   %lu",textStr, (unsigned long)textStr.length);
//    
//    if (textStr.length >= 10) {
//        
//        return NO;
//    }
//    return YES;
//}


-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }

    NSString * textStr = textView.text;
    NSString * lang = textView.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (textStr.length > 300) {
                
                textView.text = [textStr substringToIndex:300];
                
            }
        }
    }else{
        textView.text = [textStr substringToIndex:300];

    }
    
    float textViewWidth=self.textView.frame.size.width;//取得文本框高度
    NSString *content=textView.text;
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize contentSize=[content sizeWithAttributes:dict];//计算文字长度
    float numLine=ceilf(contentSize.width/textViewWidth); //计算当前文字长度对应的行数
    
     NSLog(@"numLine=%f  currentLineNum=%f",numLine,currentLineNum);
    if(numLine>currentLineNum ){
        //如果发现当前文字长度对应的行数超过。 文本框高度，则先调整当前view的高度和位置，然后调整输入框的高度，最后修改currentLineNum的值
//        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-heightText*(numLine-currentLineNum), self.frame.size.width, self.frame.size.height+heightText*(numLine-currentLineNum));
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+heightText*(numLine-currentLineNum));

        textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height+heightText*(numLine-currentLineNum));
        currentLineNum=numLine;
    }else if (numLine<currentLineNum ){
        //次数为删除的时候检测文字行数减少的时候
//        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+heightText*(currentLineNum-numLine), self.frame.size.width, self.frame.size.height-heightText*(currentLineNum-numLine));
        if (currentLineNum > 1) {
            textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height-heightText*(currentLineNum-numLine));
            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-heightText*(currentLineNum-numLine));
  
        }else{
            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

            textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
            numLine = 1;

        }
        currentLineNum=numLine;
    }
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [self.delegate getNumberTextView:self.textView.text withViewRect:self.frame];

        }
    }else{
        [self.delegate getNumberTextView:self.textView.text withViewRect:self.frame];
        
    }

    
    
    
}

@end
