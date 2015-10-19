//
//  HWLoadMoreFooter.m
//  黑马微博2期
//
//  Created by wujie on 15/10/12.
//  Copyright © 2015年 heima. All rights reserved.
//

#import "HWLoadMoreFooter.h"

@implementation HWLoadMoreFooter
+ (instancetype)footer
{
    return [[[NSBundle mainBundle]loadNibNamed:@"HWLoadMoreFooter" owner:nil options:nil]lastObject];
}
@end
