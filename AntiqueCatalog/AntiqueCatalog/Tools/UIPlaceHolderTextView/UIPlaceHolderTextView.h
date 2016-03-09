//
//  UIPlaceHolderTextView.h
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/8/22.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor*placeholderColor;
    
@private
    UILabel*placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
