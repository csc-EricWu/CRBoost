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
    ULOG(@"%@",@"ddd");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
