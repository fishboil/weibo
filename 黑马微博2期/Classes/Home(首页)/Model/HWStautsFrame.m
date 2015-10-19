//
//  HWStautsFrame.m
//  黑马微博2期
//
//  Created by wujie on 15/10/14.
//  Copyright © 2015年 heima. All rights reserved.
//

#import "HWStautsFrame.h"
#import "HWStatus.h"
#import "HWUser.h"

#define  HWStatusCellBorderW 10

@implementation HWStautsFrame

- (CGSize) sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];

    attrs[NSFontAttributeName] = font;
    
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

/** */
- (CGSize) sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

- (void)setStatus:(HWStatus *)status
{
    _status = status;
    HWUser *user = status.user;
    
    //cell width
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    //原创微博
    
    CGFloat iconWH = 35;
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //nicheng
    //头像的最大的x 加上 margin
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) +HWStatusCellBorderW;
    
    CGFloat nameY = iconY;
    
    CGSize nameSize = [self sizeWithText:user.name font:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) +HWStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    //date
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF)+HWStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:HWStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    //source
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF)+HWStatusCellBorderW;
    CGFloat sourceY = timeY;

    CGSize sourceSize = [self sizeWithText:status.source font:HWStatusCellTimeFont];
    self.sourceLabelF = (CGRect){{sourceX,sourceY},sourceSize};
    
    //content
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF),CGRectGetMaxY(self.timeLabelF)+HWStatusCellBorderW);
    
    CGFloat maxW = cellW - 2*contentX;
    CGSize contentSize = [self sizeWithText:status.text font:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    
    //has image
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photoWH = 100;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF)+HWStatusCellBorderW;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH
                                     );
        originalH = CGRectGetMaxY(self.photoViewF)+HWStatusCellBorderW;
    }else{ //no image
        originalH = CGRectGetMaxY(self.contentLabelF)+HWStatusCellBorderW;
        
    }
    
    //the whole of orgin weibo
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
   
    self.orginViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    self.cellHeight = CGRectGetMaxY(self.orginViewF);
    
    
    
}
@end
 
