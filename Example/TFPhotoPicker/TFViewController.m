//
//  TFViewController.m
//  TFPhotoPicker
//
//  Created by 1005052145@qq.com on 03/12/2019.
//  Copyright (c) 2019 1005052145@qq.com. All rights reserved.
//

#import "TFViewController.h"
#import "TFPickPhotoViewController.h"

@interface TFViewController ()

@end

@implementation TFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TFPickPhotoViewController *pickVc = [TFPickPhotoViewController new];
    [self presentViewController:pickVc animated:YES completion:nil];
}

@end
