//
//  Header.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/9/29.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#ifndef QuanMei_Header_h
#define QuanMei_Header_h

#define kBaseUrl @"http://quanmei.boyiyx.com/qm/api/"
#define BaseUrl @"http://quanmei.boyiyx.com/"
//#define kBaseUrl @"http://service.min-fo.com/quanmei/api/one/"

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
#define kGroup_join [kBaseUrl stringByAppendingString:@"group/In.php"]

//22.退出小组
#define kGroup_exit [kBaseUrl stringByAppendingString:@"group/Out.php"]

//23.文章评论点赞
#define kAddZan [kBaseUrl stringByAppendingString:@"wenzhang/AddZan.php"]

//24.文章/评论 评论
#define kPl_add [kBaseUrl stringByAppendingString:@"wenzhang/AddPl.php"]

//25.个人中心首页
#define kMyCenterMain [kBaseUrl stringByAppendingString:@"user/Main.php"]

//26.修改昵称
#define kEditNickName [kBaseUrl stringByAppendingString:@"user/EditName.php"]

//27.修改生日
#define kEditBrithday [kBaseUrl stringByAppendingString:@"user/EditAge.php"]

//28.修改头像
#define kEditIcon [kBaseUrl stringByAppendingString:@"user/EditImg.php"]

//29.取消赞
#define kDelZan [kBaseUrl stringByAppendingString:@"wenzhang/DelZan.php"]

//30.文章评论列表
#define KPLListUrl [kBaseUrl stringByAppendingString:@"wenzhang/PlList.php"]

//31.修改地区
#define kEditCity [kBaseUrl stringByAppendingString:@"user/EditDq.php"]

//32.医院主页
#define kHospital_MainUrl [kBaseUrl stringByAppendingString:@"hospital/Main.php"]

//33.医院详情
#define kHospital_DetailUrl [kBaseUrl stringByAppendingString:@"hospital/Detail.php"]

//34.医院医生
#define kHospital_DoctorUrl [kBaseUrl stringByAppendingString:@"hospital/Doctor.php"]

//35.特惠预定
#define kOrder_addUrl [kBaseUrl stringByAppendingString:@"order/AddOrder.php"]
//支付宝
#define kOrder_zfbUrl [kBaseUrl stringByAppendingString:@"zfb/notify_url.php"]
//支付详情页
#define kWaiDetailUrl [kBaseUrl stringByAppendingString:@"order/WaitDetail.php"]
//支付方式
#define kBeforePayUrl [kBaseUrl stringByAppendingString:@"order/Before_pay.php"]

//36.评论的回复列表
#define kMorePLList [kBaseUrl stringByAppendingString:@"wenzhang/MorePlList.php"]

//37.我的日记/帖子列表
#define kMyDiaryUrl [kBaseUrl stringByAppendingString:@"user/WzList.php"]

//38.我的回复列表
#define kMyreply [kBaseUrl stringByAppendingString:@"user/HfList.php"]

//39.搜索
#define kSearchUrl [kBaseUrl stringByAppendingString:@"public/Choice.php"]

//40.搜索特惠
#define  kSearchTehuiUrl [kBaseUrl stringByAppendingString:@"tehui/ChoiceTh.php"]

//41.搜素文章
#define  kSearchWenzhangUrl [kBaseUrl stringByAppendingString:@"wenzhang/ChoiceWz.php"]

//42.退出登录
#define kGetOut_Url [kBaseUrl stringByAppendingString:@"public/GetOut.php"]

//43.文章删除
#define kDel_wenzhangUrl [kBaseUrl stringByAppendingString:@"user/DelWz.php"]

//44.回复删除
#define kDel_hfUrl [kBaseUrl stringByAppendingString:@"user/DelHf.php"]

//45.密码重设
#define kPassword_csUrl [kBaseUrl stringByAppendingString:@"user/EditPsw.php"]

//46.个人主页（带加入小组)
#define kUser_moreUrl [kBaseUrl stringByAppendingString:@"user/MainMore.php"]

//47.我的被回复列表
#define kUser_bhfUrl [kBaseUrl stringByAppendingString:@"user/BhfList.php"]

//48.我的被赞列表
#define kUser_bzanUrl [kBaseUrl stringByAppendingString:@"user/BzanList.php"]

//49.订单列表
#define kUserOrderUrl [kBaseUrl stringByAppendingString:@"order/UserOrder.php"]
#define kUserOrderDetailUrl [kBaseUrl stringByAppendingString:@"order/OrderDetail.php"]
#define kBack_moneyUrl [kBaseUrl stringByAppendingString:@"order/BackOrder.php"]

//50.评价
#define kOrderPjUrl [kBaseUrl stringByAppendingString:@"order/AddPj.php"]

//51.绑定手机号
#define kBand_telUrl [kBaseUrl stringByAppendingString:@"user/BandTel.php"]

//52.医院评价列表
#define kHospital_pjUrl [kBaseUrl stringByAppendingString:@"hospital/PjList.php"]

//53.删除待支付订单
#define kOrder_DelUrl [kBaseUrl stringByAppendingString:@"order/DelOrder.php"]

//54.添加收藏
#define kSc_addUrl [kBaseUrl stringByAppendingString:@"user/AddSc.php"]
//删除收藏
#define kSc_delUrl [kBaseUrl stringByAppendingString:@"user/CancelSC.php"]
//举报文章
#define kReportArticleUrl [kBaseUrl stringByAppendingString:@"wenzhang/ReportWz.php"]

//55.收藏列表
#define kSc_listUrl [kBaseUrl stringByAppendingString:@"user/ScList.php"]

//56.修改背景
#define kEditBgImgUrl [kBaseUrl stringByAppendingString:@"user/EditBgImg.php"]

//57.教师列表
#define kteacher_listUrl [kBaseUrl stringByAppendingString:@"course/TeacherList.php"]

//58.教师详情
#define kteacher_introUrl [kBaseUrl stringByAppendingString:@"course/CourseDetail.php"]

//59.课程订单
#define kteacher_orderUrl [kBaseUrl stringByAppendingString:@"course/AddOrder.php"]

//60.课程订单
#define kMy_lessonUrl [kBaseUrl stringByAppendingString:@"user/CourseList.php"]

//61.特惠预订获取微信订单信息
#define kWX_payReqUrl [kBaseUrl stringByAppendingString:@"weixin/PayReq.php"]

//62.特惠预订订单结果查询
#define kWX_payNotifyUrl [kBaseUrl stringByAppendingString:@"weixin/PayNotify.php"]

//63.课程预订获取微信订单信息
#define kWX_payUrl [kBaseUrl stringByAppendingString:@"course/PayReq.php"]

//64.保险列表
#define kBX_listUrl [kBaseUrl stringByAppendingString:@"baoxian/List.php"]

//65.检查用户能否签到
#define kCheck_QDUrl [kBaseUrl stringByAppendingString:@"user/QdStatus.php"]

//66.签到
#define kQD_Url [kBaseUrl stringByAppendingString:@"user/Qd.php"]

//67.获取积分列表
#define kGet_jfUrl [kBaseUrl stringByAppendingString:@"user/PointList.php"]

//68.修改性别
#define kEdit_sexUrl [kBaseUrl stringByAppendingString:@"user/EditSex.php"]

#define KUser_policy [BaseUrl stringByAppendingString:@"quanmei/upload/user_policy.html"]
#define KUser_security [BaseUrl stringByAppendingString:@"quanmei/upload/user_security.html"]

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
#import "DDQLoginViewController.h"
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

#define kAlipayPartner @"2088121000537625"
#define kAlipaySeller @"846846@qq.com"
#define kAlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWuQ1WaXHjQcp3EOEfWhIezMJ0006VIsYNaaEyle4MoooWhk00vctcBYTdd6VQjIIeQdk2u5oDJCPAG a0fL0mesdF31dlw4l6zUoDS5eSA5wVYtNkFeYcKt972XClaeBivjdZA6ZghfstKEYz+d4WTn2gOvChB5Zm6iWlfVUqQTAgMBAAECgYB75sbTf8XX/6bnVdaEyGMW/uxI jJTfcxm4H9FhwRMSWUTMh0JhTY0oT/gUEOuvTbkU3yoXdLmLHPZaI1vYi1sbfcXb F/FotGmkfSKoQSk/lokQxfcW8i4LOJLOfyKoEQhqhAedG5Q96TMiaHAbOPdwq6oC 7tuN4sw1zqnRTmxoUQJBAP95kdPuq0TDt3egirBaUUf7UenCwySPtifKJduMlcDg S2dIIkss3Sm1D5++dzOrAtFb2lYC1zteP5+2AK7ocakCQQDGFkg/F6tujNy1yBuj I8bpl8DMvB+oJJeF8oRrTosQL8hdGlh4NgmEUs7uIDnj6rn+C79CBBJbgOD75qt+wHVbAkBN2LuI+tcRcxn6x9668iqGZpyFQKW6BFibM0vp5KLVTQNtC1v30EnsJZIH OUCVa+zF4tlbEC6JlqSIhCsdIRNRAkBsa7/JgMwda05W1RuDdM6oBp7JsOJm5vhk oXQnQ8tL5ct2YjgwO+uDmMuYfN0SyeRZj9Z0bMQbf3QljIErlG3nAkEAo0bBRYWJ NDT7qYbLI5zaMDthr9E+K9/x8fLBRlTd38ghUxlzfg2i1fwoGUgCLtMBcjG8RuGI Q7/yxavY7RuJMQ=="

#ifndef TARGET_OS_IOS

#define TARGET_OS_IOS TARGET_OS_IPHONE

#endif

#ifndef TARGET_OS_WATCH

#define TARGET_OS_WATCH 0

#endif
#endif
