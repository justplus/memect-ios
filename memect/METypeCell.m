//
//  METypeCell.m
//  memect
//
//  Created by zhaoliang on 15/3/26.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "METypeCell.h"
#import "UIImageView+WebCache.h"

@interface METypeCell()
{
    UIImageView *_typeIcon;
    UILabel *_typeName;
    UIButton *_subscribeButton;
}
@end

@implementation METypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 50, 20, 80, 80)];
        _typeIcon.backgroundColor = [UIColor clearColor];
        _typeIcon.layer.cornerRadius = _typeIcon.frame.size.width/2;
        _typeIcon.layer.masksToBounds = YES;
        _typeIcon.layer.borderWidth = 0.5f;
        _typeIcon.layer.borderColor = [UIColor grayColor].CGColor;
        
        _typeName = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, frame.size.width, 20)];
        _typeName.font = [UIFont systemFontOfSize:16.0f];
        _typeName.textAlignment = NSTextAlignmentCenter;
        _typeName.numberOfLines = 1;
        
        _subscribeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _subscribeButton.frame = CGRectMake(10, 130, frame.size.width - 20, 30);
        _subscribeButton.backgroundColor = [UIColor orangeColor];
        [_subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_subscribeButton setTitle:@"添加订阅" forState:UIControlStateNormal];
        
        [self addSubview:_typeIcon];
        [self addSubview:_typeName];
        [self addSubview:_subscribeButton];
    }
    return self;
}

- (void)setType:(MemectType *)type {
    [_typeIcon sd_setImageWithURL:[NSURL URLWithString:type.icon] placeholderImage:[UIImage imageNamed:@"common_image_loading"]];
    [_typeName setText:type.name];
}

@end
