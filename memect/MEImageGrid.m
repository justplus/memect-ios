//
//  KGImageGallary.m
//  konggu
//
//  Created by zhaoliang on 15/3/15.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "MEImageGrid.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define kWidth 80
#define kHeight 80
#define kMargin 5

@interface MEImageGrid()
@property(nonatomic, copy)NSMutableArray *imageViews;
@end

@implementation MEImageGrid


- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = [imageUrls copy];
    CGFloat startX = 0;
    CGFloat startY = 0;
    //创建UIImageView
    for (int i=0; i<[_imageUrls count]; i++) {
        UIImageView *imageView = [UIImageView new];
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
        
        int row = i / 3;
        int col = i % 3;
        
        CGFloat x = startX + col * (kWidth + kMargin);
        CGFloat y = startY + row * (kHeight + kMargin);
        imageView.frame = CGRectMake(x, y, kWidth, kHeight);
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrls[i]] placeholderImage:[UIImage imageNamed:@"common_loading"]];
        imageView.clipsToBounds = YES;
        imageView.contentMode =UIViewContentModeScaleAspectFill;
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    }
    int rows = ((int)[_imageUrls count] - 1) / 3 + 1;
    self.height = startY + rows * kHeight + (rows - 1) * kMargin;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = (int)[self.imageUrls count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.imageUrls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


@end
