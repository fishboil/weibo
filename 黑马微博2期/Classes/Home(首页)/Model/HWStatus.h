//
//  HWStatus.h
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//  微博模型

#import <Foundation/Foundation.h>
@class HWUser;

@interface HWStatus : NSObject
/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) HWUser *user;

@property (nonatomic,copy) NSString * created_at ;

@property (nonatomic,copy) NSString * source ;

@property (nonatomic,strong) NSArray * pic_urls;

/**被转发的原微博 */
@property (nonatomic,strong) HWStatus   * retweeted_status;

@end
