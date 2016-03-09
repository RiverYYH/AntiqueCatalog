//
//  WHShare.m
//  藏民网
//
//  Created by Hong on 15/8/27.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "WHShare.h"
#import <ShareSDK/ShareSDK.h>

@implementation WHShare

- (void)whShareWithTitle:(NSString *)title content:(NSString *)content shareImageUrl:(id)shareImageUrl urlString:(NSString *)urlString index:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:DEFAULTCONTENT
                                                        image:shareImageUrl
                                                        title:title
                                                          url:urlString
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [self succeed];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [self fialedWitherror:[error errorDescription]];
                                }
                            }];
        }
            break;
        case 1:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:DEFAULTCONTENT
                                                        image:shareImageUrl
                                                        title:title
                                                          url:urlString
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiSession
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self succeed];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [self fialedWitherror:[error errorDescription]];
                                }
                            }];
        }
            break;
        case 2:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:DEFAULTCONTENT
                                                        image:shareImageUrl
                                                        title:title
                                                          url:urlString
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiTimeline
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self succeed];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [self fialedWitherror:[error errorDescription]];
                                }
                            }];
        }
            break;
        case 3:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@ #到处是宝# 官方APP（“%@”@到处是宝）",title,urlString,[UserModel userUname]]
                                               defaultContent:DEFAULTCONTENT
                                                        image:shareImageUrl
                                                        title:title
                                                          url:urlString
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self succeed];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [self fialedWitherror:[error errorDescription]];
                                }
                            }];
        }
            break;
        case 4:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:DEFAULTCONTENT
                                                        image:shareImageUrl
                                                        title:title
                                                          url:urlString
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQSpace
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self succeed];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [self fialedWitherror:[error errorDescription]];
                                }
                            }];
            
        }
            break;
        default:
            break;
    }
}

- (void)succeed
{
    if(_delegate && [_delegate respondsToSelector:@selector(WHShareSucceed)]) {
        [_delegate WHShareSucceed];
    }
}
- (void)fialedWitherror:(NSString *)error
{
    if(_delegate && [_delegate respondsToSelector:@selector(WHShareFailedWithError:)]) {
        [_delegate WHShareFailedWithError:error];
    }
}
@end
