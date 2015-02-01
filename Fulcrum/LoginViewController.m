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
#import "RegistrationViewController.h"
#import "AlertFactory.h"

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
    [self.signUpLink addTarget:self action:@selector(onSignUpLinkTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:tap];
    
    [self.emailTextField setText:@"w@w.com"];
    [self.passwordTextField setText:@"wwwwww"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onSignUpLinkTouchUpInside:(id)sender{
    RegistrationViewController* registrationViewController = [[RegistrationViewController alloc]init];
    [self.navigationController pushViewController:registrationViewController animated:YES];
}

-(IBAction)onLoginButtonTouchUpInside:(id)sender{
    NSString* email = [self.emailTextField text];
    NSString* password = [self.passwordTextField text];
    [FulcrumAPIFacade loginWithUsername:email andWithPassword:password withCallback:^(NSString * token, NSString* errorMessage) {
        if(token!=nil){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"access_token"];
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               MainViewController* mainViewController = [[MainViewController alloc]init];
                               [self.navigationController setViewControllers:@[mainViewController] animated:YES];
                           });
        }
        else{
            UIAlertController* confirmationAlertController = [AlertFactory alertWithMessage:errorMessage];
            [self presentViewController:confirmationAlertController animated:YES completion:^(void) {}];
        }
    }];
}

@end
