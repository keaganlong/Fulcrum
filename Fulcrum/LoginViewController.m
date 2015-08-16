//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
#import <FlatUIKit/FlatUIKit.h>
#import "FUIButton.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "FulcrumAPIFacade.h"
#import "RegistrationViewController.h"
#import "AlertFactory.h"
#import <Parse/Parse.h>

@implementation LoginViewController


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self initEmailLabel];
    [self initPasswordLabel];
    [self initLoginButton];
    [self initEmailTextField];
    [self initPasswordTextField];
    self.emailTextField.text = @"zxc@zxc.com";
    self.passwordTextField.text = @"zxczxc";
    [super viewWillAppear:animated];
}

-(CGRect)boundsWithXCenterOffset:(int)xOffset YCenterOffset:(int)yOffset width:(int)width height:(int)height{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    bounds.origin.x = bounds.size.width/2-width/2+xOffset;
    bounds.origin.y = bounds.size.height/2-height/2+yOffset;
    bounds.size.width = width;
    bounds.size.height = height;
    return bounds;
}

-(void)initEmailLabel{
    CGRect bounds = [self boundsWithXCenterOffset:0 YCenterOffset:-60 width:44 height:40];
    UILabel* emailLabel = [[UILabel alloc] initWithFrame:bounds];
    //emailLabel.backgroundColor = [UIColor redColor];
    emailLabel.text = @"Email";
    emailLabel.font = [UIFont flatFontOfSize:18];
    self.emailLabel = emailLabel;
    [self.view addSubview:self.emailLabel];
}

-(void)initPasswordLabel{
    CGRect bounds = [self boundsWithXCenterOffset:0 YCenterOffset:50 width:77 height:40];
    UILabel* passwordLabel = [[UILabel alloc] initWithFrame:bounds];
    //passwordLabel.backgroundColor = [UIColor redColor];
    passwordLabel.text = @"Password";
    passwordLabel.font = [UIFont flatFontOfSize:18];
    self.passwordLabel = passwordLabel;
    [self.view addSubview:self.passwordLabel];
}

-(void)initLoginButton{
    CGRect bounds = [self boundsWithXCenterOffset:0 YCenterOffset:170 width:120 height:40];
    FUIButton* loginButton = [[FUIButton alloc] initWithFrame:bounds];
    [loginButton setTitle:@"Start Balancing" forState:UIControlStateNormal];
    
    loginButton.buttonColor = [UIColor peterRiverColor];
    loginButton.shadowColor = [UIColor belizeHoleColor];
    loginButton.shadowHeight = 3.0f;
    loginButton.cornerRadius = 6.0f;
    loginButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.loginButton = loginButton;
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(onLoginButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initEmailTextField{
    CGRect bounds = [self boundsWithXCenterOffset:0 YCenterOffset:-15 width:200 height:40];
    FUITextField* myTextField = [[FUITextField alloc] initWithFrame:bounds];
    myTextField.font = [UIFont flatFontOfSize:16];
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    myTextField.textFieldColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.1];
    myTextField.borderColor = [UIColor peterRiverColor];
    myTextField.borderWidth = 2.0f;
    myTextField.cornerRadius = 5.0f;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.textAlignment = UITextAlignmentCenter;
    self.emailTextField = myTextField;
    [self.view addSubview:self.emailTextField];
}

-(void)initPasswordTextField{
    CGRect bounds = [self boundsWithXCenterOffset:0 YCenterOffset:90 width:200 height:40];
    FUITextField* myTextField = [[FUITextField alloc] initWithFrame:bounds];
    myTextField.font = [UIFont flatFontOfSize:16];
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    myTextField.textFieldColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.1];
    myTextField.borderColor = [UIColor peterRiverColor];
    myTextField.borderWidth = 2.0f;
    myTextField.cornerRadius = 5.0f;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.textAlignment = UITextAlignmentCenter;
    self.passwordTextField = myTextField;
    [self.view addSubview:self.passwordTextField];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.signUpLink addTarget:self action:@selector(onSignUpLinkTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:tap];
    
    //[self.emailTextField setText:@"kolkol@kol.com"];
    //[self.passwordTextField setText:@"kolkol"];
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
    self.loginButton.enabled = NO;
    NSString* email = [self.emailTextField text];
    NSString* password = [self.passwordTextField text];
    
    
    [FulcrumAPIFacade loginWithUsername:email andWithPassword:password withCallback:^(NSError* error) {
        if(!error){
            dispatch_async(dispatch_get_main_queue(),
               ^{
                   MainViewController* mainViewController = [[MainViewController alloc]init];
                   [self.navigationController setViewControllers:@[mainViewController] animated:YES];
               });
        }
        else{
            dispatch_async(dispatch_get_main_queue(),
                ^{
                    NSString* errorMessage = @"Incorrect username or password.";
                    UIAlertController* confirmationAlertController = [AlertFactory alertWithMessage:errorMessage];
                    [self presentViewController:confirmationAlertController animated:YES completion:^(void) {}];
                    self.loginButton.enabled = YES;
                });
        }
    }];
}



@end
