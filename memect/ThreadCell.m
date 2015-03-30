//
//  ThreadCell.m
//  memect
//
//  Created by zhaoliang on 15/3/23.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "ThreadCell.h"
#import "MEImageGrid.h"
#import "UIImageView+WebCache.h"
#import "DWTagList.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "METextView.h"

// 索引块大小
#define INDEX_SIZE 16
// 缩略图上下边距
#define THUMBNAIL_MARGIN 8
// 头像大小
#define USER_AVATAR_SIZE 20
// button高度
#define BUTTON_HEIGHT 27
// 按钮分割线宽度
#define BUTTON_SEPERATOR_WIDTH 0.5f
// 按钮背景颜色
#define BUTTON_BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]


@interface ThreadCell()
// 序号
@property(nonatomic, strong)UILabel *index;
// 分享者头像
@property(nonatomic, strong)UIImageView *userAvatar;
// 分享内容
@property(nonatomic, strong)METextView *status;
// 原分享内容
@property(nonatomic, strong)METextView *retweetStatus;
// 分享配图
@property(nonatomic, strong)MEImageGrid *thumbnails;
// 分享者信息
@property(nonatomic, strong)UILabel *shareInfo;
// 标签
@property(nonatomic, strong)DWTagList *tags;
// 评论按钮
@property(nonatomic, strong)UIButton *commentButton;
// 转发按钮
@property(nonatomic, strong)UIButton *retweetButton;
// 收藏按钮
@property(nonatomic, strong)UIButton *collectButton;
// 稍后阅读按钮
@property(nonatomic, strong)UIButton *laterReadButton;
// 按钮间隔线
@property(nonatomic, strong)UIView *buttonSeperator;
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
    [self.contentView addSubview:self.index];
    [self.contentView addSubview:self.userAvatar];
    [self.contentView addSubview:self.status];
    [self.contentView addSubview:self.shareInfo];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.retweetButton];
    [self.contentView addSubview:self.collectButton];
    [self.contentView addSubview:self.laterReadButton];
    [self.contentView addSubview:self.buttonSeperator];
    // add constraints for all subviews
    NSDictionary *vars = NSDictionaryOfVariableBindings(_index, _userAvatar, _status, _shareInfo, _commentButton, _retweetButton, _collectButton, _laterReadButton, _buttonSeperator);
    NSDictionary *metrics = @{@"indexSize":@INDEX_SIZE, @"userAvatarSize":@USER_AVATAR_SIZE,
                              @"buttonHeight":@BUTTON_HEIGHT, @"buttonSeperatorWidth":@BUTTON_SEPERATOR_WIDTH};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[_index(==indexSize)]-[_status]-(>=0)-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-[_index(==indexSize)]" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-(>=0)-[_status]-|" options:0 metrics:0 views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[_userAvatar(==userAvatarSize)]-[_shareInfo]-(>=0)-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-(>=0)-[_userAvatar(==userAvatarSize)]-[_commentButton(==buttonHeight)]-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-(>=0)-[_shareInfo(==userAvatarSize)]-[_commentButton]-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[_retweetButton(==buttonHeight)]-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[_collectButton(==buttonHeight)]-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[_laterReadButton(==buttonHeight)]-|" options:0 metrics:metrics views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-[_status]-(>=0)-[_userAvatar]" options:0 metrics:0 views:vars]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_commentButton]-(==buttonSeperatorWidth)-[_retweetButton(==_commentButton)]-(==buttonSeperatorWidth)-[_collectButton(==_commentButton)]-(==buttonSeperatorWidth)-[_laterReadButton(==_commentButton)]-|" options:0 metrics:metrics views:vars]];
    
}

#pragma mark - setting and calculate height for each thread
- (void)setThread:(MemectThread *)thread {
    // for reuse the cell, MUST remove the mutable view
    [self.retweetStatus removeFromSuperview];
    [self.thumbnails removeFromSuperview];
    [self.tags removeFromSuperview];
    
    self.height = 8;
    [self.index setText:[NSString stringWithFormat:@"%d", thread.index]];
    [self.status setText:thread.weiboContent.text];
    self.status.delegate = self;
    CGFloat weiboContentWidth = self.contentView.frame.size.width - INDEX_SIZE - 3*8;
    CGSize weiboContentSize = [self.status sizeThatFits:CGSizeMake(weiboContentWidth, CGFLOAT_MAX)];
    self.height += weiboContentSize.height + 1;
    
    if (thread.weiboContent.retweetedStatus) {
        [self.contentView addSubview:_retweetStatus];
        // add constraints
        NSDictionary *vars = NSDictionaryOfVariableBindings(_status, _retweetStatus);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"V:[_status]-[_retweetStatus]" options:0 metrics:0 views:vars]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                          @"H:|-(>=0)-[_retweetStatus]-|" options:0 metrics:0 views:vars]];
        [self.retweetStatus setText:thread.weiboContent.retweetedStatus.text];
        CGSize retweetedWeiboContentSize = [self.retweetStatus sizeThatFits:CGSizeMake(weiboContentWidth, CGFLOAT_MAX)];
        self.height += retweetedWeiboContentSize.height + 1;
    }
    
    NSMutableArray *thumbnailPics = [[NSMutableArray alloc] init];
    if ([thread.weiboContent.thumbnailPics count] > 0) {
        thumbnailPics = [thread.weiboContent.thumbnailPics copy];
    }
    else if ([thread.weiboContent.retweetedStatus.thumbnailPics count] > 0) {
        thumbnailPics = [thread.weiboContent.retweetedStatus.thumbnailPics copy];
    }
    if ([thumbnailPics count] > 0) {
        //如果不设置为nil, 会复用之前的数据；因此为了重新初始化，必须设置为nil
        self.thumbnails = nil;
        [self.contentView addSubview:self.thumbnails];
        self.thumbnails.imageUrls = thumbnailPics;
        
        self.height += THUMBNAIL_MARGIN;
        // add constraints
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnails attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.status attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnails attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.status attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnails attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:self.height]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.thumbnails attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.thumbnails.height]];
        
        self.height += self.thumbnails.height;
    }
    
    if ([thread.tags count] > 0) {
        self.tags = nil;
        self.tags = [[DWTagList alloc] initWithFrame:CGRectMake(8 + INDEX_SIZE + 8, self.height + THUMBNAIL_MARGIN,
                                                                self.contentView.frame.size.width - 24 - INDEX_SIZE, 0.0f)];
        [self.contentView addSubview:self.tags];
        [self.tags setTags:[[NSArray alloc] initWithArray:thread.tags]];
        CGSize tagsSize = self.tags.fittedSize;
        self.height += tagsSize.height + THUMBNAIL_MARGIN;
    }
    
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:thread.weiboContent.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"tabbar_profile"]];
    NSString  *dtFormat = @"%Y-%m-%d %H:%M";
    NSString *info = [NSString stringWithFormat:@"%@ 分享于%@", thread.weiboContent.user.screenName,
                      [self dateInFormat:thread.weiboContent.createTime format:dtFormat]];
    [self.shareInfo setText:info];
    self.height += USER_AVATAR_SIZE;
    
    self.height = self.height + 8*2 + BUTTON_HEIGHT;
}

- (NSString *)dateInFormat:(time_t)dateTime format:(NSString*)stringFormat
{
    char buffer[80];
    const char *format = [stringFormat UTF8String];
    struct tm * timeinfo;
    timeinfo = localtime(&dateTime);
    strftime(buffer, 80, format, timeinfo);
    return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString *tapedString = [textView.text substringWithRange:characterRange];
    NSRange topicRange = [tapedString rangeOfString:@"#"];
    if (topicRange.location != NSNotFound && topicRange.location == 0) {
        // 话题
        return NO;
    }
    NSRange atRange = [tapedString rangeOfString:@"@"];
    if (atRange.location != NSNotFound && atRange.location == 0) {
        // at
        return NO;
    }
    if ([[URL scheme] isEqualToString:@"http"]) {
        // 链接
        return NO;
    }
    return YES;
}


#pragma mark - lazy load view
- (UILabel *)index {
    if (!_index) {
        _index = [UILabel new];
        _index.numberOfLines = 1;
        _index.font = [UIFont systemFontOfSize:12.0f];
        _index.textColor = [UIColor grayColor];
        _index.textAlignment = NSTextAlignmentCenter;
        UIColor * indexColor = [UIColor colorWithRed:29.0/255.0
                                               green:173.0/255.0
                                                blue:234.0/255.0
                                             alpha:1.0];
        _index.backgroundColor = indexColor;
        _index.textColor = [UIColor whiteColor];
        _index.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _index;
}

- (UIImageView *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = [UIImageView new];
        _userAvatar.backgroundColor = [UIColor clearColor];
        _userAvatar.layer.cornerRadius = USER_AVATAR_SIZE/2;
        _userAvatar.layer.masksToBounds = YES;
        _userAvatar.layer.borderWidth = 0.5f;
        _userAvatar.layer.borderColor = [UIColor grayColor].CGColor;
        _userAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _userAvatar;
}

- (METextView *)status {
    if (!_status) {
        _status = [METextView new];
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

- (METextView *)retweetStatus {
    if (!_retweetStatus) {
        _retweetStatus = [METextView new];
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

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton new];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _commentButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _commentButton;
}

- (UIButton *)retweetButton {
    if (!_retweetButton) {
        _retweetButton = [UIButton new];
        [_retweetButton setTitle:@"转发" forState:UIControlStateNormal];
        [_retweetButton setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [_retweetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_retweetButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _retweetButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _retweetButton;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton new];
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectButton setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [_collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_collectButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _collectButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _collectButton;
}

- (UIButton *)laterReadButton {
    if (!_laterReadButton) {
        _laterReadButton = [UIButton new];
        [_laterReadButton setTitle:@"稍后阅读" forState:UIControlStateNormal];
        [_laterReadButton setBackgroundColor:BUTTON_BACKGROUND_COLOR];
        [_laterReadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_laterReadButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _laterReadButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _laterReadButton;
}

- (UIView *)buttonSeperator {
    if (!_buttonSeperator) {
        _buttonSeperator = [UIView new];
        [_buttonSeperator setBackgroundColor:[UIColor grayColor]];
        _buttonSeperator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _buttonSeperator;
}

@end
