//
//  Api.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkClient.h"

//#define HEADURL @"http://devsns.zcyun.cn"//测试环境
#define HEADURL @"http://catalog.cangm.com"//测试环境

#define Oauth_token @"4351cbacc91d72015257921626e045aa"
#define Oauth_token_secret @"a4d4ea0611ac4b26f9ed5dc122039488"

#define API_URL_Catalog_index @"api.php?mod=Catalog&act=index"//展示首页热门图录用于用户推荐(max_id翻页)
#define API_URL_Catalog_userBook @"api.php?mod=Catalog&act=userBook"//用户的个人云库（max_id翻页,参数rtime,max_id=rtime）
#define API_URL_Catalog_getCatalog @"api.php?mod=Catalog&act=getCatalog"//图录展示页面(传图录id,id=?)
#define API_URL_USER_Follow @"api.php?mod=User&act=follow"//添加关注,传入user_id（uid）
#define API_URL_USER_UNFollow @"api.php?mod=User&act=unfollow"//取消关注,传入user_id（uid）
#define API_URL_Catalog_getCatalogCategory @"api.php?mod=Catalog&act=getCatalogCategory"//拉取所以网站图录分类名名称和ID
#define API_URL_Catalog_getCategoryCatalog @"api.php?mod=Catalog&act=getCategoryCatalog"//分类下的图录(传分类id和max_id)
#define API_URL_USER_Followering @"api.php?mod=User&act=user_following"//关注列表,参数传uid或者uname,max_id（上次返回最后一人follow_id）,count（返回数量）
#define API_URL_USER_userInfo @"api.php?mod=Catalog&act=userInfo"//出版机构主页,(user_id,max_id)
#define API_URL_Catalog_retrieve @"api.php?mod=Catalog&act=retrieve"//检索拍卖图录
#define API_URL_Catalog_search @"api.php?mod=Catalog&act=search"//搜索图录
#define API_URL_Catalog_getList @"api.php?mod=Catalog&act=getList"//外部的目录接口(传图录id)
#define API_URL_Catalog_get @"api.php?mod=Catalog&act=get"//打开图录进入阅读请求数据
#define API_URL_Catalog_getTagCatalog @"api.php?mod=Catalog&act=getTagCatalog"//请求标签图录
#define API_URL_Catalog_agetCommentList @"api.php?mod=Catalog&act=getCommentList"//评论列表
#define API_URL_Catalog_addBookComment @"api.php?mod=Catalog&act=addBookComment"//书本评论接口
#define API_URL_USER @"api.php?mod=User&act=show"//TA信息,传入uname（用户名）,或者user_id
#define API_URL_AUTHORIZE @"api.php?mod=Oauth&act=authorize"//登录,参数1-login 参数2-password
#define API_URL_Catalog_getUserRead @"api.php?mod=Catalog&act=getUserRead"//艺术足迹
#define API_URL_USER_Modify @"api.php?mod=User&act=save_user_info"
#define API_URL_Catalog_addToBook @"api.php?mod=Catalog&act=addToBook"
#define API_URL_Catalog_delToBook @"api.php?mod=Catalog&act=delToBook"//删除图录
#define API_URL_Catalog_diggComment @"api.php?mod=Catalog&act=diggComment"//点赞（comment_id）
#define API_URL_Catalog_undiggComment @"api.php?mod=Catalog&act=undiggComment"//取消点赞

#define API_URL_NOTIFY @"api.php?mod=Notifytion&act=get_system_notify" //系统通知

@interface Api : NSObject

/**
 参数0 -- isuser  判断是否需要Oauth_token
 参数1 -- 请求方法,get post
 参数2 -- 接口链接(类似api.php?mod=FindPeople&act=search_user)
 参数3 -- 接口参数
 */
+ (void)requestWithbool:(BOOL)isuser
               withMethod:(NSString*)method
               withPath:(NSString*)path
               withParams:(NSDictionary*)params
               withSuccess:(void (^)(id responseObject))success
               withError:(void (^)(NSError* error))failed;

+ (void)showLoadMessage:(NSString *)message;
+ (void)hideLoadHUD;
@end
