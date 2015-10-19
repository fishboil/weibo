//
//  HWStautsFrame.h
//  黑马微博2期
//
//  Created by wujie on 15/10/14.
//  Copyright © 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
//昵称字体
#define  HWStatusCellNameFont [UIFont systemFontOfSize:15]
//时间字体
#define  HWStatusCellTimeFont [UIFont systemFontOfSize:12]
//来源字体
#define  HWStatusCellSourceFont [UIFont systemFontOfSize:15]
//正文字体
#define  HWStatusCellContentFont [UIFont systemFontOfSize:14]

@class  HWStatus;
@interface HWStautsFrame : NSObject

/** 微博*/
@property (nonatomic,strong) HWStatus   * status;
/** 原创微博整体*/
@property (nonatomic,assign) CGRect    orginViewF;
/** 头像*/
@property (nonatomic,assign) CGRect    iconViewF;
/** 会员图标*/
@property (nonatomic,assign) CGRect    vipViewF;
/** 配图*/
@property (nonatomic,assign) CGRect    photoViewF;
/** 昵称*/
@property (nonatomic,assign) CGRect    nameLabelF;
/** 时间*/
@property (nonatomic,assign) CGRect    timeLabelF;
/** 正文*/
@property (nonatomic,assign) CGRect    sourceLabelF;

/** cell的高度*/
@property (nonatomic,assign) CGRect    contentLabelF;



@property (nonatomic,assign) CGFloat    cellHeight;
@end
