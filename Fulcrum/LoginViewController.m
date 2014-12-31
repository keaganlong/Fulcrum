//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@implementation LoginViewController

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.loginButton addTarget:self action:@selector(onLoginButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onLoginButtonTouchUpInside:(id)sender{
    MainViewController* mainViewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

@end
