//
//  Api.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkClient.h"
#import "FMDB.h"

//#define HEADURL @"http://devsns.zcyun.cn"//测试环境
#define HEADURL @"http://catalog.cangm.com"//测试环境

#define Oauth_token @"4351cbacc91d72015257921626e045aa"
#define Oauth_token_secret @"a4d4ea0611ac4b26f9ed5dc122039488"

#define versionNumber 1.0

#define API_URL_Catalog_index @"api.php?mod=Catalog&act=index"//展示首页热门图录用于用户推荐(max_id翻页)
#define API_URL_Catalog_userBook @"api.php?mod=Catalog&act=userBook"//用户的个人云库（max_id翻页,参数rtime,max_id=rtime）
#define API_URL_Catalog_getCatalog @"api.php?mod=Catalog&act=getCatalog"//图录展示页面(传图录id,id=?)

#define API_URL_USER_Follow @"api.php?mod=User&act=follow"//添加关注,传入user_id（uid）
#define API_URL_USER_UNFollow @"api.php?mod=User&act=unfollow"//取消关注,传入user_id（uid）
#define API_URL_Catalog_getCatalogCategory @"api.php?mod=Catalog&act=getCatalogCategory"//拉取所以网站图录分类名名称和ID
#define API_URL_Catalog_getCategoryCatalog @"api.php?mod=Catalog&act=getCategoryCatalog"//分类下的图录(传分类id和max_id)
#define API_URL_USER_Followering @"api.php?mod=User&act=user_following"//关注列表,参数传uid或者uname,max_id（上次返回最后一人follow_id）,count（返回数量）
#define API_URL_USER_AddFolloering @"api.php?mod=Catalog&act=userList" //添加关注页面
#define API_URL_USER_userInfo @"api.php?mod=Catalog&act=userInfo"//出版机构主页,(user_id,max_id)
#define API_URL_Catalog_retrieve @"api.php?mod=Catalog&act=retrieve"//检索拍卖图录
#define API_URL_Catalog_search @"api.php?mod=Catalog&act=search"//搜索图录
#define API_URL_Catalog_UserSearch @"api.php?mod=Catalog&act=userSearch" //搜索关注中的艺术号
#define API_URL_Catalog_getList @"api.php?mod=Catalog&act=getList"//外部的目录接口(传图录id)
#define API_URL_Catalog_get @"api.php?mod=Catalog&act=get"//打开图录进入阅读请求数据
#define API_URL_Catalog_getTemp @"api.php?mod=Catalog&act=getCatalogAllData"//图录展示页面(传图录id,id=?)
#define API_URL_Catalog_RedBook @"api.php?mod=Catalog&act=doRead"//图录展示页面(传图录id,id=?)

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
#define API_URL_ADDTOBOOK @"api.php?mod=Catalog&act=addToBook" //加入云库

//又拍云的bucket和passcode
#define Bucket @"snscangm"
#define Passcode @"OBgogA06OGKFNY0/LADcICZBbNg="

#pragma mark - 通用------------------------------------------

#define API_URL_LONG_WEIBO_DETAIL @"api.php?mod=Weiba&act=long_detail" //长微博详情

#define API_URL_LONG_XiangQing @"http://sns.cangm.com/index.php?app=w3g&mod=Weiba&act=postDetail&post_id="//第三方分享的时候长文详情的URL
#define API_URL_XiangQing @"http://sns.cangm.com/index.php?app=w3g&mod=Index&act=detail&weibo_id="//第三方分享的时候微博详情的URL
#define API_URL_TOPIC @"http://sns.cangm.com/index.php?app=w3g&mod=Index&act=doSearch&key="//第三方分享专辑的url
#define API_URL_PLAZA @"http://sns.cangm.com/index.php?app=w3g&mod=Index&act=tag_detail&feed_category_id="
//又拍云的前面拼接地址
#define upYunImgUrl @"http://snscangm.b0.upaiyun.com%@%@.jpg!img.avatar.jpg"



//第三方相关
#define APPICON [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"]
#define DEFAULTCONTENT @"来自到处是宝的邀请" //默认分享内容

#define API_URL_POST_Photoweibo_New @"api.php?mod=Weibo&act=post_weibo_new"//发送图片微博到upyun得接口
#define API_URL_POST_Photoweibo [NSString stringWithFormat:@"%@api.php?mod=Weibo&act=upload_photo&format=json",HEADURL] //发送图片微博 content from
#define API_URL_INVITATION @"http://sns.cangm.com/index.php?app=w3g&mod=Public&act=mobile_app&uname="//邀请链接

#define API_URL_NOTIFICATION @"api.php?mod=Message&act=unreadcount" //进入程序便需要不断调用,用来查看新消息
#define API_URL_CheckinLo @"api.php?mod=Checkin&act=checkinlocation" //传地理位置
#define API_URL_TOPICSEARCH @"api.php?mod=Topic&act=topicSearch"//搜索专辑传入k和max_id和count

#define API_URL_SEARCH_topic @"api.php?mod=Weibo&act=search_topic" //专辑列表 分页max_id key为空所有
#define API_URL_SEARCH_at @"api.php?mod=Weibo&act=search_at" //@联系人 分页max_id  key为空所有
#define API_URL_TOPICIMAGEWALL @"api.php?mod=Topic&act=imgswall"//图片墙传入k：专辑名称
#define API_URL_TOPICSETWITHIMAGE @"api.php?mod=Topic&act=upload_photo"//专辑设置带图片传参des和topic_id
#define API_URL_TOPICSETNOTIMAGE @"api.php?mod=Topic&act=topicSet"//专辑设置无图片传参des和topic_id
#define API_URL_COMMENT_weibo @"api.php?mod=Weibo&act=comment_weibo" //评论微博 content、feed_id、from
#define API_URL_COMMENT_weiba @"api.php?mod=Weiba&act=comment_post" //评论/转发帖子 content、post_id、from ifShareFeed判断评论or转发
#define API_URL_REPOST_Knowledge @"api.php?mod=Blog&act=repost_blog" //转发知识content、feed_id、from
#define API_URL_REPOST_weibo @"api.php?mod=Weibo&act=repost_weibo" //转发微博content、feed_id、from
#define API_URL_TopicDetail @"api.php?mod=Weibo&act=topic_timeline"//微博-专辑详情,传入topic_name（专辑名称）,max_id（上次返回最后一条微博feed_id）
#define API_URL_ATTENTIONTOPIC @"api.php?mod=Topic&act=favoriteTopic"//关注专辑传参topic_id
#define API_URL_NOTATTENTIONTOPIC @"api.php?mod=Topic&act=unfavoriteTopic"//取消关注专辑传参topic_id
#define API_URL_DEL_weibo @"api.php?mod=Weibo&act=del_weibo" //删除微博 feed_id
#define API_URL_DENOUNCE_weibo @"api.php?mod=Weibo&act=denounce_weibo" //举报微博 reason feed_id from
#define API_URL_ADD_zan @"api.php?mod=Weibo&act=digg_weibo" //点赞 传feed_id

#define API_URL_DEL_zan @"api.php?mod=Weibo&act=undigg_weibo" //取消赞 传feed_id
#define API_URL_Statistic @"api.php?mod=Oauth&act=shareCount"//统计用户有效行为，传入feed_id(用户操作的微博id),share_uid(用户自己的id)，source_uid(微博主人的id)
#define API_URL_Knowledge_unfavorite @"api.php?mod=Blog&act=unfavorite"//取消收藏知识blog_id
#define API_URL_Knowledge_unzan @"api.php?mod=Blog&act=delDigg"//取消赞知识,传row_id,(id)
#define API_URL_Knowledge_Detail @"api.php?mod=Blog&act=blog_detail"//知识详情,传文章id,(id)
#define API_URL_Knowledge_CommentList @"api.php?mod=Blog&act=blog_comments"//知识评论列表 feed_id和max_id(上次返回最后一评论的comment_id)
#define API_URL_COMMENT_Knowledge @"api.php?mod=Blog&act=comment_blog" //评论知识 content、feed_id、from
#define API_URL_Knowledge_favorite @"api.php?mod=Blog&act=favorite"//收藏知识,传blog_id
#define API_URL_Knowledge_ZanList @"api.php?mod=Blog&act=blog_digg" //知识赞列表id max_id(id)
#define API_URL_Knowledge_zan @"api.php?mod=Blog&act=addDigg"//赞知识,传row_id,(id)
#define API_URL_Weiba_unfavorite @"api.php?mod=Weiba&act=unfavorite"//取消收藏帖子post_id,weiba_id,post_uid
#define API_URL_Weiba_favorite @"api.php?mod=Weiba&act=favorite"//收藏帖子,传post_id,weiba_id,post_uid
#define API_URL_Weiba_CircleDetail @"api.php?mod=Weiba&act=post_detail"//帖子详情,传文章id,(post_id)
#define API_URL_Weiba_CommentList @"api.php?mod=Weiba&act=weiba_comments"//帖子评论列表 feed_id和max_id(上次返回最后一评论的comment_id)
#define API_URL_DEL_weiba @"api.php?mod=Weiba&act=del_post" //删除帖子 post_id
#define API_URL_DENOUNCE_weiba @"api.php?mod=Weiba&act=denounce_post" //举报帖子 reason post_id from
#define API_URL_Weiba_unzan @"api.php?mod=Weiba&act=del_post_digg"//取消赞帖子,传post_id,(post_id)
#define API_URL_Weiba_zan @"api.php?mod=Weiba&act=add_post_digg"//赞帖子,传post_id,(post_id)
#define API_URL_COMMEN_LABLE @"api.php?mod=Weibo&act=getPostFeedCategory"//请求常用标签
#define API_URL_ZANLIST @"api.php?mod=Weibo&act=weibo_diggs" //赞列表 传feed_id max_id(id)
#define API_URL_Weiba_ZanList @"api.php?mod=Weiba&act=weiba_post_digg" //帖子赞列表post_id max_id(id)


#define API_URL_User_Phone @"api.php?mod=User&act=do_bind_phone" //绑定手机号
#define API_URL_User_UNPhone @"api.php?mod=User&act=unbind" //解绑手机号
#define API_URL_USER_RESETPHONE @"api.php?mod=User&act=send_code"//重置手机获取验证码
#define API_URL_USER_RESET_PHONE @"api.php?mod=User&act=reset_phone"//重置手机号绑定
#define API_URL_USER_Interest @"api.php?mod=Oauth&act=get_user_tags"//获取标签列表


#pragma mark - 系统设置
//------系统设置
#define API_URL_Other_Bind @"api.php?mod=User&act=user_bind" //帐号是否已绑定
#define API_URL_Other_Bind_Other @"api.php?mod=User&act=bind_other" //帐号绑定
#define API_URL_Other_UNBind @"api.php?mod=User&act=unbind" //取消绑定
#define API_URL_Other_Login @"api.php?mod=Oauth&act=get_other_login_info" //第三方登录
#define API_UIL_DISanFang_REGISTER @"api.php?mod=Oauth&act=bind_new_user_new"//第三方注册
#define API_UIL_REGISTER @"api.php?mod=Oauth&act=register"//注册
#define API_UIL_REGISTERUPLOADAVATAR [NSString stringWithFormat:@"%@/api.php?mod=Oauth&act=register_upload_avatar&format=json",HEADURL]//上传注册头像

#define API_URL_User_Send_Code @"api.php?mod=User&act=send_bind_code" //获取绑定手机号验证码
#define API_URL_User_Send_Code_New @"api.php?mod=Oauth&act=check_mob_code"//通过shareSDK获取绑定手机验证码

#define API_UIL_SENDFINDPWDCODE @"api.php?mod=Oauth&act=send_findpwd_code"//获取重置密码验证码
#define API_UIL_CHECKPWCODE @"api.php?mod=Oauth&act=check_password_code"//检查重置密码验证码正确性
#define API_UIL_SAVEUSERPW @"api.php?mod=Oauth&act=save_user_pwd"//重置密码

//sqlite数据库名称、表名称、字段名称
#define DB_NAME    @"allData.sqlite"
#define TABLE_ACCOUNTINFOS @"ACCOUNTINFOS"  //表名称
#define KEYID        @"id"     //主键ID
#define DATAID       @"acountId"
#define ALLINFOData   @"allInfoData"
#define IMAGEDATA @"imagedata" //图片信息

#define FileSavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


#define DOWNTABLE_NAME @"downTableName"
#define DOWNFILEID      @"fileId"
#define DOWNFILE_NAME      @"fileName"

#define DOWNFILEIMAGE_NAME @"downImageName"
#define DOWNFILEIMAGE_ID    @"dowImageId"
#define DOWNFILEIMAGE_STATE @"downImageState"
#define DOWNFILEIMAGE_URL   @"dowlImageUrl"
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

+ (void)requestWithMethod:(NSString*)method
                 withPath:(NSString*)path
               withParams:(NSDictionary*)params
              withSuccess:(void (^)(id responseObject))success
                withError:(void (^)(NSError* error))failed;

+ (void)endClient;
+(void)alert4:(NSString *)message inView:(UIView *)view offsetY:(CGFloat)yOffset;

 //数据库
+(FMDatabase *)initTheFMDatabase;
+(FMResultSet*)queryTableIsOrNotInTheDatebaseWithDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName;
+(FMResultSet*)queryTableIsOrNotInTheDatebaseWithDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName withColumn:(NSString*)column;
+(NSString *)creatTable_TeacherAccountSq;
+(FMResultSet*)queryResultSetWithWithDatabase:(FMDatabase*)db AndTable:(NSString *)tableName AndWhereName:(NSString *)keyName AndValue:(NSString *)value;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSMutableArray *)ArrayWithJsonString:(NSString *)jsonString;

//下载表
+(NSString*)creatTable_DownAccountSq;
+(NSString*)creatTable_DownImageSQl:(NSString*)tableName;
+(FMResultSet*)queryTableIALLDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName;
@end
