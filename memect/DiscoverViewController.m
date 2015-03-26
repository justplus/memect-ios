//
//  DiscoverViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MERequestTool.h"
#import "NSDictionary+Json.h"
#import "METypeCell.h"

#define MEMECT_TYPE_URL      @"http://memect.sinaapp.com/api/types"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

#pragma mark - init ui
- (void)viewDidLoad {
    [self setupView];
    [self setupData];
}

- (void)setupView {
    self.navigationItem.title = @"订阅";
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupData {
    [MERequestTool GET:MEMECT_TYPE_URL parameters:nil response:@"json" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        int status = [result intValueForKey:@"status"];
        if (status == 1) {
            NSDictionary *data = [result dictionaryValueForKey:@"data"];
            // int total = [data intValueForKey:@"total"];
            int index = 0;
            float frameX, frameY;
            for (NSDictionary *dict in [data arrayValueForKey:@"types"]) {
                if (index % 2 == 0) {
                    frameX = 0;
                }
                else {
                    frameX = self.view.frame.size.width/2;
                }
                frameY = index/2*160;
                index++;
                METypeCell *cell = [[METypeCell alloc] initWithFrame:CGRectMake(frameX, frameY + 60, self.view.frame.size.width/2, 160)];
                MemectType *type = [[MemectType alloc] initWithDictionary:dict];
                cell.type = type;
                [self.view addSubview:cell];
            }
        }
        else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
