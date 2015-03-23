//
//  ThreadCell.m
//  memect
//
//  Created by zhaoliang on 15/3/23.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "ThreadCell.h"
#import "MEImageGrid.h"

@interface ThreadCell()
// 分享者头像
@property(nonatomic, strong)UIImageView *userAvatar;
// 分享内容
@property(nonatomic, strong)UITextView *status;
// 原分享内容
@property(nonatomic, strong)UITextView *retweetStatus;
// 分享配图
@property(nonatomic, strong)MEImageGrid *thumbnails;
// 分享者信息
@property(nonatomic, strong)UILabel *shareInfo;
// 标签

@end

@implementation ThreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - init UI and add constraints
- (void)setupViews {
    [self.contentView addSubview:self.userAvatar];
    [self.contentView addSubview:self.status];
    [self.contentView addSubview:self.retweetStatus];
    [self.contentView addSubview:self.thumbnails];
    [self.contentView addSubview:self.shareInfo];
    // add constraints for all subviews
    
}


#pragma mark - lazy load view
- (UIImageView *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = [UIImageView new];
        _userAvatar.backgroundColor = [UIColor clearColor];
        _userAvatar.layer.cornerRadius = _userAvatar.frame.size.width / 2;
        _userAvatar.layer.masksToBounds = YES;
        _userAvatar.layer.borderWidth = 1.0f;
        _userAvatar.layer.borderColor = [UIColor grayColor].CGColor;
        _userAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userAvatar;
}

- (UITextView *)status {
    if (!_status) {
        _status = [UITextView new];
        [_status setEditable:NO];
        [_status setScrollEnabled:NO];
        _status.font = [UIFont systemFontOfSize:14.0f];
        _status.contentInset = UIEdgeInsetsZero;
        _status.textContainerInset = UIEdgeInsetsZero;
        _status.textContainer.lineFragmentPadding = 0;
        _status.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _status;
}

- (UITextView *)retweetStatus {
    if (!_retweetStatus) {
        _retweetStatus = [UITextView new];
        [_retweetStatus setEditable:NO];
        [_retweetStatus setScrollEnabled:NO];
        _retweetStatus.font = [UIFont systemFontOfSize:14.0f];
        _retweetStatus.textColor = [UIColor grayColor];
        _retweetStatus.contentInset = UIEdgeInsetsZero;
        _retweetStatus.textContainerInset = UIEdgeInsetsZero;
        _retweetStatus.textContainer.lineFragmentPadding = 0;
        _retweetStatus.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _retweetStatus;
}

- (MEImageGrid *)thumbnails {
    if (!_thumbnails) {
        _thumbnails = [MEImageGrid new];
        _thumbnails.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _thumbnails;
}

- (UILabel *)shareInfo {
    if (!_shareInfo) {
        _shareInfo = [UILabel new];
        _shareInfo.numberOfLines = 1;
        _shareInfo.font = [UIFont systemFontOfSize:10.0f];
        _shareInfo.textColor = [UIColor grayColor];
        _shareInfo.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _shareInfo;
}
@end
