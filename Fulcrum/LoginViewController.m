//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "FulcrumAPIFacade.h"

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
//    NSString* email = @"sam@CCC.edu";//[self.emailTextField text];
//    NSString* password = @"eCCCCCC:0";//[self.passwordTextField text];
//    [FulcrumAPIFacade loginWithUsername:email andWithPassword:password withCallback:^(NSString * token) {
//        if(token!=nil){
//            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:token forKey:@"access_token"];
//            
//            dispatch_async(dispatch_get_main_queue(),
//                           ^{
//                               MainViewController* mainViewController = [[MainViewController alloc]init];
//                               [self.navigationController pushViewController:mainViewController animated:YES];
//                           });
//        }
//        else{
//            
//        }
//    }];
    MainViewController* mainViewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

@end
