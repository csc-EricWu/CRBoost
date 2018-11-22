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
    
    if (@available(iOS 11.0, *))
    {
        CRLog(@"safeAreaInsets :%@", NSStringFromUIEdgeInsets(CRSharedApp.keyWindow.safeAreaInsets));
    }
    else
    {
    }
    CRLog(@"CRNavigationH: %f", CRNaviationHeight());
    ULOG(@"%@", [@"40" removeDecimalLastZeros]);
}

@end
