//
//  RegistrationViewContoller.m
//  Fulcrum
//
//  Created by Keagan Long on 1/20/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationViewController.h"
#import "FulcrumAPIFacade.h"
#import "AlertFactory.h"
#import <Parse/Parse.h>

@implementation RegistrationViewController

-(id)init{
    self = [super init];
    if(self){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];

        
        self.view.backgroundColor = [UIColor whiteColor];
        self.emailTextField = [self textFieldWithFrame:CGRectMake(20,100,250,30)];
        self.emailTextField.placeholder = @"Email Address";
        self.passwordTextField = [self textFieldWithFrame:CGRectMake(20,150,250,30)];
        self.passwordTextField.placeholder = @"Password";
        self.passwordConfirmTextField = [self textFieldWithFrame:CGRectMake(20,200,250,30)];
        self.passwordConfirmTextField.placeholder = @"Confirm Password";
        
        self.passwordTextField.secureTextEntry = YES;
        self.passwordConfirmTextField.secureTextEntry = YES;
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.passwordTextField];
        [self.view addSubview:self.passwordConfirmTextField];
        
        
        UIButton* registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [registerButton setTitle:@"Register" forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(onTouchUpInsideRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        registerButton.frame = CGRectMake(80,300,60,60);
        [self.view addSubview:registerButton];
    }
    return self;
}

-(IBAction)onTouchUpInsideRegisterButton:(id)sender{
    NSString* email = [self.emailTextField text];
    NSString* password = [self.passwordTextField text];
    NSString* confirmPassword = [self.passwordConfirmTextField text];
    if([self validateEmail:email password:password andConfirmPassword:confirmPassword]){
        [self registerAccountWithEmail:email andPassword:password];
    }
}

-(BOOL)validateEmail:(NSString*)email password:(NSString*)password andConfirmPassword:(NSString*)confirmPassword{
    if(![password isEqualToString:confirmPassword]){
        return NO;
    }
    if([password length] < 6){
        return NO;
    }
    return YES;
}

-(void)registerAccountWithEmail:(NSString*)email andPassword:(NSString*)password{
    PFUser* newUser = [PFUser user];
    newUser.username = email;
    newUser.password = password;
    newUser.email = email;
    
    [FulcrumAPIFacade registerAccountWithUsername:email andPassword:password withCallback:^(NSError* error) {
        if(!error){
            dispatch_async(dispatch_get_main_queue(),
                ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
        }
        else{
            dispatch_async(dispatch_get_main_queue(),
                ^{
                    UIAlertController* confirmationAlertController = [AlertFactory alertWithMessage:@"Error occured."];
                    [self presentViewController:confirmationAlertController animated:YES completion:^(void) {}];
                });
        }
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(UITextField*)textFieldWithFrame:(CGRect)frame{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return textField;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end