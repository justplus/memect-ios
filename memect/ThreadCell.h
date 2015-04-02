//
//  ThreadCell.h
//  memect
//
//  Created by zhaoliang on 15/3/23.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemectThread.h"

@interface ThreadCell : UITableViewCell<UITextViewDelegate>

// thread
@property(nonatomic, strong)MemectThread *thread;
// height
@property(nonatomic, assign)int height;

@end
