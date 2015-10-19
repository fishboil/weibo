//
//  HWUser.h
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>

@interface HWUser : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

// >2 as a member
@property (nonatomic,assign) int mbtype;
// member level
@property (nonatomic,assign) int mbrank;

@property (nonatomic,assign,getter=isVip) BOOL vip;

+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
