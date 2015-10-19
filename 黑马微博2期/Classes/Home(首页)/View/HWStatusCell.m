//
//  HWStatusCell.m
//  黑马微博2期
//
//  Created by wujie on 15/10/14.
//  Copyright © 2015年 heima. All rights reserved.
//

#import "HWStatusCell.h"
#import "HWStatus.h"
#import "HWUser.h"
#import "HWPhoto.h"
#import "HWStautsFrame.h"
#import "UIImageView+WebCache.h"

@interface HWStatusCell()
@property (nonatomic,weak) UIView * originalView ;

@property (nonatomic,weak) UIImageView * iconView ;

@property (nonatomic,weak) UIImageView  * vipView ;

@property (nonatomic,weak) UIImageView * photoView ;

@property (nonatomic,weak) UILabel * nameLabel ;

@property (nonatomic,weak) UILabel * timeLabel ;

@property (nonatomic,weak) UILabel * sourceLable ;

@property (nonatomic,weak) UILabel * contentLabel;


@end

@implementation HWStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    HWStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[HWStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIView * originalView = [[UIView alloc]init] ;
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        UIImageView * iconView = [[UIImageView alloc]init] ;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UIImageView  * vipView = [[UIImageView alloc]init] ;
        [self.contentView addSubview:vipView];
        self.vipView = vipView;
        
        UIImageView * photoView = [[UIImageView alloc]init] ;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        UILabel * nameLabel = [[UILabel alloc]init] ;
        nameLabel.font = HWStatusCellNameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel * timeLabel = [[UILabel alloc]init] ;
        timeLabel.font = HWStatusCellTimeFont;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel * sourceLable = [[UILabel alloc]init] ;
        sourceLable.font = HWStatusCellSourceFont;
        [self.contentView addSubview:sourceLable];
        self.sourceLable = sourceLable;
        
        UILabel * contentLabel= [[UILabel alloc]init] ;
        contentLabel.font = HWStatusCellContentFont;
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        

    }
    return self;

}

- (void)setStatusFrame:(HWStautsFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    HWStatus * status = statusFrame.status;
    HWUser * user = status.user;
    
    self.originalView.frame = statusFrame.orginViewF;
    
    self.iconView.frame = statusFrame.iconViewF;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avater_default_small"]];
    
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    
    }
    if (status.pic_urls.count) {
        self.photoView.frame = statusFrame.photoViewF;
        HWPhoto *photo = [status.pic_urls firstObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic ] placeholderImage:[UIImage imageNamed: @"timeline_image_placeholder"]];
        self.photoView.hidden = NO;
    }else{
        self.photoView.hidden = YES;
    }
   
    
    
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    self.sourceLable.text = status.source;
    self.sourceLable.frame = statusFrame.sourceLabelF;
    
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    
    
    


}


@end
