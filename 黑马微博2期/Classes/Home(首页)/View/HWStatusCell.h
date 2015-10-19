//
//  HWStatusCell.h
//  黑马微博2期
//
//  Created by wujie on 15/10/14.
//  Copyright © 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  HWStautsFrame;
@interface HWStatusCell : UITableViewCell

+ (instancetype) cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) HWStautsFrame    * statusFrame;
@end
