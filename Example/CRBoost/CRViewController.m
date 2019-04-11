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

@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CRLog(@"CRNavigationH: %f", CRNaviationHeight());
    ULOG(@"%@", [@"40" removeDecimalLastZeros]);
    NSString *qr = @"BAIDUQRvin=LSGEM0000L0000060&baiduQrCode=cGFzc3BvcnQuYmFpZHUuY29tL3YyL2FwaS9xcmNvZGU/c2lnbj1hOGQ2ZWI5YmJiMDE0NGNhNmM2YzkwMDFmZGZiMmIxZSZ1YW9ubHk9JmNsaWVudF9pZD0mbHA9YXBwJmNsaWVudD1hbmRyb2lkJnFybG9naW5mcm9tPSZ3ZWNoYXQ9JnRyYWNlaWQ9JmFwcE5hbWU9JUU0JUI4JThBJUU2JUIxJUJEJUU5JTgwJTlBJUU3JTk0JUE4==";
    NSString *urlString = @"http://baidu.com";
    NSString *fullURL = [urlString URLStringByAppendingQueryString:qr];
    NSLog(@"%@",fullURL);
    NSURLComponents *cmp = [NSURLComponents componentsWithURL:CRURL(fullURL) resolvingAgainstBaseURL:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [cmp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict safeSetObject:obj.value forKey:obj.name];
    }];
    dict = CRJSONFromQuery(qr);
    NSLog(dict);
}

@end
