//
//  LoginViewController.m
//  memect
//
//  Created by zhaoliang on 15/3/22.
//  Copyright (c) 2015年 zhaoliang. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation LoginViewController

#pragma mark - init
- (void)loadView
{
    self.view = [UIView new];
    
    [self setupViews];
    [self setupConstraints];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@", OAUTH_URL, APP_KEY, REDIRECT_URL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setupViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.webView = [UIWebView new];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)setupConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
}


#pragma mark - authorize
- (void)authWithCode: (NSString *)code
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client_id"] = APP_KEY;
    param[@"client_secret"] = APP_SECRET;
    param[@"grant_type"] = @"authorization_code";
    param[@"code"] = code;
    param[@"redirect_uri"] = REDIRECT_URL;
    [MERequestTool POST:ACCESS_TOKEN_URL parameters:param response:@"plain" success:^(id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        Account *account = [[Account alloc] initWithString:result];
        // 将账号信息保存在本地，同时请求数据库保存
        NSMutableDictionary *userSaveParameters = [NSMutableDictionary dictionary];
        userSaveParameters[@"weibo_uid"] = @(account.uid);
        // 根据uid获取用户详细信息
        [MERequestTool GET:GET_USER_URL parameters:@{@"access_token": account.accessToken, @"uid": @(account.uid)} response:@"json" success:^(id responseObject) {
            //User *userInfo = [[User alloc] initWithDictionary:responseObject];
            account.userInfo = responseObject;
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            if(data){
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                userSaveParameters[@"user_info"] = jsonString;
                [MERequestTool POST:SAVE_USER_URL parameters:userSaveParameters response:@"json" success:^(id responseObject) {
                    if([responseObject intValueForKey:@"status"] == 1) {
                        [account saveAccount];
                        // 获取用户订阅列表并缓存
                        NSString *getMemectTypeUrl = [NSString stringWithFormat:@"%@%lld", GET_MEMECT_LIST, account.uid];
                        [MERequestTool GET:getMemectTypeUrl parameters:nil response:@"json" success:^(id responseObject) {
                            NSDictionary *result = (NSDictionary *)responseObject;
                            int status = [result intValueForKey:@"status"];
                            if (status == 1) {
                                NSDictionary *data = [result dictionaryValueForKey:@"data"];
                                //int total = [data intValueForKey:@"total"];
                                NSArray *types = [data arrayValueForKey:@"types"];
                                account.memectTypes = types;
                            }
                        } failure:^(NSError *error) {
                            NSLog(@"getMememType Error:%@", error);
                        }];
                        FrameViewController *frameViewController = [[FrameViewController alloc] init];
                        [self presentViewController:frameViewController animated:YES completion:^{
                            
                        }];
                    }
                    else {
                        [Util showExceptionDialog:@"出现未知异常..." view:self.view];
                        NSLog(@"saveUserToDB Error");
                    }
                } failure:^(NSError *error) {
                    [Util showExceptionDialog:@"服务器去开小差了, 稍后再试!" view:self.view];
                    NSLog(@"saveUser Error: %@", error);
                }];
            }
        } failure:^(NSError *error) {
            [Util showExceptionDialog:@"获取用户信息出现异常" view:self.view];
            NSLog(@"getUser Error:%@", error);
        }];
    } failure:^(NSError *error) {
        [Util showExceptionDialog:@"授权失败" view:self.view];
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view addSubview:self.hud];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrl = request.URL.absoluteString;
    NSRange range = [requestUrl rangeOfString:REDIRECT_URL];
    if (range.location == 0) {
        NSRange codeRange = [requestUrl rangeOfString:[REDIRECT_URL stringByAppendingString:@"/?code="]];
        unsigned long codeIndex = codeRange.length;
        NSString *code = [requestUrl substringFromIndex:codeIndex];
        [self authWithCode:code];
        return NO;
    }
    return YES;
}

#pragma mark - property
- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"请稍后...";
    }
    return _hud;
}
@end
