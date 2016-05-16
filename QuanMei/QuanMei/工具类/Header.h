//
//  Header.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/29.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#ifndef QuanMei_Header_h
#define QuanMei_Header_h

//#define kBaseUrl @"http://139.196.172.208/qm/api/"
#define kBaseUrl @"http://service.min-fo.com/quanmei/api/one/"

//新URL：12.1
//1.init
#define kInitUrl [kBaseUrl stringByAppendingString:@"public/Init.php"]

//2.记录极光ID
#define kJPush_url [kBaseUrl stringByAppendingString:@"public/SetJpush.php"]

//3.checkPhone
#define kCheckPhone [kBaseUrl stringByAppendingString:@"public/CheckTel.php"]

//4.注册
#define kRegisterUrl [kBaseUrl stringByAppendingString:@"public/Register.php"]

//5.login
#define kLoginUrl [kBaseUrl stringByAppendingString:@"public/Login.php"]

//6.第三方
#define kDSFRegisterUrl [kBaseUrl stringByAppendingString:@"public/Login_dsf.php"]

//7.首页
#define kMainUrl [kBaseUrl stringByAppendingString:@"public/Main.php"]

//8.项目大全
#define kProjectListUrl [kBaseUrl stringByAppendingString:@"project/List.php"]

//9.项目详情
#define kProjectDetailUrl [kBaseUrl stringByAppendingString:@"project/Detail.php"]

//10.项目日记
#define kProjectRijiUrl [kBaseUrl stringByAppendingString:@"project/Riji.php"]

//11.特惠详情
#define kTehui_detail [kBaseUrl stringByAppendingString:@"tehui/Detail.php"]

//12.特惠类别列表(带主题活动列表)
#define kTeHuiListUrl [kBaseUrl stringByAppendingString:@"tehui/TypeList.php"]

//13.特惠列表(带筛选)
#define kTeHuiTypeUrl [kBaseUrl stringByAppendingString:@"tehui/List.php"]

//14.特惠列表(主题活动的特惠)
#define kTehui_alist [kBaseUrl stringByAppendingString:@"tehui/ActList.php"]

//15.小组列表
#define kGroupListUrl [kBaseUrl stringByAppendingString:@"group/List.php"]

//16.文章列表
#define kWenzhangUrl [kBaseUrl stringByAppendingString:@"wenzhang/List.php"]

//17.日记添加
#define kRiji_add [kBaseUrl stringByAppendingString:@"wenzhang/AddRj.php"]

//18.帖子
#define kTiezi_add  [kBaseUrl stringByAppendingString:@"wenzhang/AddTz.php"]

//19.小组详情
#define kGroup_detail [kBaseUrl stringByAppendingString:@"group/Detail.php"]

//20.文章详情
#define kWenzhangDetailUrl [kBaseUrl stringByAppendingString:@"wenzhang/Detail.php"]

//21.加入小组
#define kGroup_join @"http://service.min-fo.com/quanmei/api/one/group/In.php"

//22.退出小组
#define kGroup_exit @"http://service.min-fo.com/quanmei/api/one/group/Out.php"

//23.文章评论点赞
#define kAddZan @"http://service.min-fo.com/quanmei/api/one/wenzhang/AddZan.php"

//24.文章/评论 评论
#define kPl_add @"http://service.min-fo.com/quanmei/api/one/wenzhang/AddPl.php"

//25.个人中心首页
#define kMyCenterMain @"http://service.min-fo.com/quanmei/api/one/user/Main.php"

//26.修改昵称
#define kEditNickName @"http://service.min-fo.com/quanmei/api/one/user/EditName.php"

//27.修改生日
#define kEditBrithday @"http://service.min-fo.com/quanmei/api/one/user/EditAge.php"

//28.修改头像
#define kEditIcon @"http://service.min-fo.com/quanmei/api/one/user/EditImg.php"

//29.取消赞
#define kDelZan @"http://service.min-fo.com/quanmei/api/one/wenzhang/DelZan.php"

//30.文章评论列表
#define KPLListUrl @"http://service.min-fo.com/quanmei/api/one/wenzhang/PlList.php"

//31.修改地区
#define kEditCity @"http://service.min-fo.com/quanmei/api/one/user/EditDq.php"

//32.医院主页
#define kHospital_MainUrl @"http://service.min-fo.com/quanmei/api/one/hospital/Main.php"

//33.医院详情
#define kHospital_DetailUrl @"http://service.min-fo.com/quanmei/api/one/hospital/Detail.php"

//34.医院医生
#define kHospital_DoctorUrl @"http://service.min-fo.com/quanmei/api/one/hospital/Doctor.php"

//35.特惠预定
#define kOrder_addUrl @"http://service.min-fo.com/quanmei/api/one/order/AddOrder.php"
//支付宝
#define kOrder_zfbUrl @"http://service.min-fo.com/quanmei/api/one/zfb/notify_url.php"
//支付详情页
#define kWaiDetailUrl @"http://service.min-fo.com/quanmei/api/one/order/WaitDetail.php"
//支付方式
#define kBeforePayUrl @"http://service.min-fo.com/quanmei/api/one/order/Before_pay.php"

//36.评论的回复列表
#define kMorePLList @"http://service.min-fo.com/quanmei/api/one/wenzhang/MorePlList.php"

//37.我的日记/帖子列表
#define kMyDiaryUrl @"http://service.min-fo.com/quanmei/api/one/user/WzList.php"

//38.我的回复列表
#define kMyreply @"http://service.min-fo.com/quanmei/api/one/user/HfList.php"

//39.搜索
#define kSearchUrl @"http://service.min-fo.com/quanmei/api/one/public/Choice.php"

//40.搜索特惠
#define  kSearchTehuiUrl @"http://service.min-fo.com/quanmei/api/one/tehui/ChoiceTh.php"

//41.搜素文章
#define  kSearchWenzhangUrl @"http://service.min-fo.com/quanmei/api/one/wenzhang/ChoiceWz.php"

//42.退出登录
#define kGetOut_Url @"http://service.min-fo.com/quanmei/api/one/public/GetOut.php"

//43.文章删除
#define kDel_wenzhangUrl @"http://service.min-fo.com/quanmei/api/one/user/DelWz.php"

//44.回复删除
#define kDel_hfUrl @"http://service.min-fo.com/quanmei/api/one/user/DelHf.php"

//45.密码重设
#define kPassword_csUrl @"http://service.min-fo.com/quanmei/api/one/user/EditPsw.php"

//46.个人主页（带加入小组)
#define kUser_moreUrl @"http://service.min-fo.com/quanmei/api/one/user/MainMore.php"

//47.我的被回复列表
#define kUser_bhfUrl @"http://service.min-fo.com/quanmei/api/one/user/BhfList.php"

//48.我的被赞列表
#define kUser_bzanUrl @"http://service.min-fo.com/quanmei/api/one/user/BzanList.php"

//49.订单列表
#define kUserOrderUrl @"http://service.min-fo.com/quanmei/api/one/order/UserOrder.php"
#define kUserOrderDetailUrl @"http://service.min-fo.com/quanmei/api/one/order/OrderDetail.php"
#define kBack_moneyUrl @"http://service.min-fo.com/quanmei/api/one/order/BackOrder.php"

//50.评价
#define kOrderPjUrl @"http://service.min-fo.com/quanmei/api/one/order/AddPj.php"

//51.绑定手机号
#define kBand_telUrl @"http://service.min-fo.com/quanmei/api/one/user/BandTel.php"

//52.医院评价列表
#define kHospital_pjUrl @"http://service.min-fo.com/quanmei/api/one/hospital/PjList.php"

//53.删除待支付订单
#define kOrder_DelUrl @"http://service.min-fo.com/quanmei/api/one/order/DelOrder.php"

//54.添加收藏
#define kSc_addUrl @"http://service.min-fo.com/quanmei/api/one/user/AddSc.php"

//55.收藏列表
#define kSc_listUrl @"http://service.min-fo.com/quanmei/api/one/user/ScList.php"

//56.修改背景
#define kEditBgImgUrl @"http://service.min-fo.com/quanmei/api/one/user/EditBgImg.php"

//57.教师列表
#define kteacher_listUrl @"http://service.min-fo.com/quanmei/api/one/course/TeacherList.php"

//58.教师详情
#define kteacher_introUrl @"http://service.min-fo.com/quanmei/api/one/course/CourseDetail.php"

//59.课程订单
#define kteacher_orderUrl @"http://service.min-fo.com/quanmei/api/one/course/AddOrder.php"

//60.课程订单
#define kMy_lessonUrl @"http://service.min-fo.com/quanmei/api/one/user/CourseList.php"

//61.特惠预订获取微信订单信息
#define kWX_payReqUrl @"http://service.min-fo.com/quanmei/api/one/weixin/PayReq.php"

//62.特惠预订订单结果查询
#define kWX_payNotifyUrl @"http://service.min-fo.com/quanmei/api/one/weixin/PayNotify.php"

//63.课程预订获取微信订单信息
#define kWX_payUrl @"http://service.min-fo.com/quanmei/api/one/course/PayReq.php"

//64.保险列表
#define kBX_listUrl @"http://service.min-fo.com/quanmei/api/one/baoxian/List.php"

//65.检查用户能否签到
#define kCheck_QDUrl @"http://service.min-fo.com/quanmei/api/one/user/QdStatus.php"

//66.签到
#define kQD_Url @"http://service.min-fo.com/quanmei/api/one/user/Qd.php"

//67.获取积分列表
#define kGet_jfUrl @"http://service.min-fo.com/quanmei/api/one/user/PointList.php"

#import "MBProgressHUD+EBUsHUD.h"

#define kErrorDes @"当前网络连接异常"
#define kServerDes @"服务器繁忙"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kTextColor [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f]
#define kLeftColor [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f]
#define kRightColor [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
#define kLineColor [UIColor colorWithRed:227.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f]

#import "UIColor+DDQColorTool.h"
#import "Masonry.h"
#import "PostData.h"
#import "NSString+MD5Addition.h"
#import "SpellParameters.h"
#import "DDQSingleModel.h"
#import "DDQLoginSingleModel.h"
#import "UIImageView+WebCache.h"
#import <SMS_SDK/SMSSDK.h>
#import "Alg.h"
#import "SBJson.h"
#import "DDQPOSTEncryption.h"
#import "CheckNetWork.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Singleton.h"
#import "MBProgressHUD.h"
#import "DDQNetUtils.h"
#import "DDQPOSTEncryption+DDQQuanMeiEncryption.h"
#import "UICKeyChainStore.h"
#import "DDQNetWork.h"
#import "MBProgressHUD+EBUsHUD.h"
#import "APService.h"
#import "NSString+DDQStringRect.h"
//10-29
#import "DDQPublic.h"

#define kShardAppKey @"118c985b6c97e"
#define kShardSecret @"7b73f76ed2630d16233f9f36086b1e39"

#define kQQAppKey @"1105019688"

#define kWeChatKey @"wx719c1e4eebfb3fb7"
#define kWeChatSecret @"b931d772cbf4ad7d1330779dc054108d"
#define kWeChatPartner @"1311715801"
#define kWeiBoKey @"3430399716"
#define kWeiBoSecret @"a71b8291b30319140e8edfe2e6a2820e"

#ifndef TARGET_OS_IOS

#define TARGET_OS_IOS TARGET_OS_IPHONE

#endif

#ifndef TARGET_OS_WATCH

#define TARGET_OS_WATCH 0

#endif
#endif
