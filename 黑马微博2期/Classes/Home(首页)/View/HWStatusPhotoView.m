//
//  HWStatusPhotoView.m
//  黑马微博2期
//
//  Created by wujie on 15/10/15.
//  Copyright © 2015年 heima. All rights reserved.
//

#import "HWStatusPhotoView.h"
#import "HWPhoto.h" 
#import "UIImageView+WebCache.h"


@interface HWStatusPhotoView ()

@property (nonatomic,weak) UIImageView * gifView ;

@end

@implementation HWStatusPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return _gifView;
}

- (void)setPhoto:(HWPhoto *)photo
{
    _photo = photo;
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;

}





@end
