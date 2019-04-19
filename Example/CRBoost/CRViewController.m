//
//  CRViewController.m
//  CRBoost
//
//  Created by Eric Wu on 08/15/2018.
//  Copyright (c) 2018 Eric Wu. All rights reserved.
//

#import "CRViewController.h"
#import <CRBoost/CRBoost.h>

@interface CRViewController ()
@property (strong, nonatomic) UIView *progressView;

@end

@implementation CRViewController
{
    CAGradientLayer *gradientLayer;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fadeAinmation];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CRLog(@"CRNavigationH: %f", CRNaviationHeight());
    //    ULOG(@"%@", [@"40" removeDecimalLastZeros]);
    //    NSString *qr = @"BAIDUQRvin=LSGEM0000L0000060&baiduQrCode=cGFzc3BvcnQuYmFpZHUuY29tL3YyL2FwaS9xcmNvZGU/c2lnbj1hOGQ2ZWI5YmJiMDE0NGNhNmM2YzkwMDFmZGZiMmIxZSZ1YW9ubHk9JmNsaWVudF9pZD0mbHA9YXBwJmNsaWVudD1hbmRyb2lkJnFybG9naW5mcm9tPSZ3ZWNoYXQ9JnRyYWNlaWQ9JmFwcE5hbWU9JUU0JUI4JThBJUU2JUIxJUJEJUU5JTgwJTlBJUU3JTk0JUE4==";
    //    NSString *urlString = @"http://baidu.com";
    //    NSString *fullURL = [urlString URLStringByAppendingQueryString:qr];
    //    NSLog(@"%@",fullURL);
    //    NSURLComponents *cmp = [NSURLComponents componentsWithURL:CRURL(fullURL) resolvingAgainstBaseURL:NO];
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [cmp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [dict safeSetObject:obj.value forKey:obj.name];
    //    }];
    //    dict = CRJSONFromQuery(qr);
    //    NSLog(dict);
    NSLog(@"✅❎‼❌ Table View controller Will appear: %@", NSStringFromClass([self class]));
    
}
- (void)fadeAinmation
{
    UIView *progressView = [[UIView alloc] init];
    [self.view addSubview:progressView];
    _progressView = progressView;
    progressView.frame = CGRectMake(0, CRNaviationHeight() + 100, CRScreenSize().width, 30);
    progressView.backgroundColor = [UIColor orangeColor];
    progressView.layer.cornerRadius = progressView.frame.size.height * 0.5;
    
    if (gradientLayer) {
        [gradientLayer removeFromSuperlayer];
    }
    UIColor *startColor = [UIColor colorWithHex:@"5CA8FF"];
    UIColor *toColor = [UIColor colorWithHex:@"2B6FBC"];
    
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.locations = @[@0, @1];
    gradientLayer.anchorPoint = CGPointZero;
    //    gradientLayer.position = CGPointMake(10, 10);
    gradientLayer.cornerRadius = CGRectGetHeight(self.progressView.frame) * 0.5;
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)toColor.CGColor];
    gradientLayer.frame = CGRectMake(0, 0, 0.5 * self.progressView.width, self.progressView.height);
    [self.progressView.layer insertSublayer:gradientLayer atIndex:0];
    
    
    
    CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    fadeAinmation.repeatCount = HUGE_VALF;
    //    fadeAinmation.beginTime = CACurrentMediaTime();
    fadeAinmation.autoreverses = YES;//如果设置为YES,代表动画每次重复执行的效果会跟上一次相反
    fadeAinmation.fromValue = @(0);
    fadeAinmation.toValue = @(self.progressView.width);
    fadeAinmation.duration = 1.5;
    fadeAinmation.removedOnCompletion = NO;
    fadeAinmation.fillMode = kCAFillModeForwards;
    fadeAinmation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [gradientLayer addAnimation:fadeAinmation forKey:nil];
}
@end
