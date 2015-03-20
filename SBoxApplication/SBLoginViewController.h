//
//  SBLoginViewController.h
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShow.h"
#import "ScrollerMovingText.h"
#import "SBApplicationModel.h"


/**
 The login controller handles FB,Twitter and register login. Further it manages the login-process and its visual layer. 
 #Note: Its could be separated later into single viewcontroller, for prototyping reason its all put together into one controller to save time.
 */

@interface SBLoginViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong)IBOutlet SlideShow *slideShow;
@property (nonatomic, strong)IBOutlet ScrollerMovingText *movingText;
@property (nonatomic, strong)IBOutlet ScrollerMovingText *movingText1;

@property (nonatomic, strong)IBOutlet UIButton *facebookButton;
@property (nonatomic, strong)IBOutlet UIButton *twitterButton;
@property (nonatomic, strong)IBOutlet UIButton *registerButton;

@property (nonatomic, strong)IBOutlet UIView *registerLabel;
@property (nonatomic, strong)IBOutlet UIView *backgroundScrollerView;

// Enter-Name Dialog
@property (nonatomic, strong)IBOutlet UIView *nameView;
@property (nonatomic, strong)IBOutlet UILabel *firstNameLabel;
@property (nonatomic, strong)IBOutlet UILabel *secondNameLabel;
@property (nonatomic, strong)IBOutlet UITextField *firstName;
@property (nonatomic, strong)IBOutlet UITextField *secondName;

// Email
@property (nonatomic, strong)IBOutlet UIView *emailView;
@property (nonatomic, strong)IBOutlet UITextField *emailTextField;
@property (nonatomic, strong)IBOutlet UILabel *emailLabel;

// Gender
@property (nonatomic, strong)IBOutlet UIView *genderView;
@property (nonatomic, strong)IBOutlet UIPickerView *genderPicker;
@property (nonatomic, strong)IBOutlet UILabel *genderLabel;

// Birthdate
@property (nonatomic, strong)IBOutlet UIView *birthdateView;
@property (nonatomic, strong)IBOutlet UIDatePicker *birthdayPicker;
@property (nonatomic, strong)IBOutlet UILabel *birthdayLabel;

// Size
@property (nonatomic, strong)IBOutlet UIView *sizeView;
@property (nonatomic, strong)IBOutlet UIPickerView *sizePicker;
@property (nonatomic, strong)IBOutlet UILabel *sizeLabel;

// Size
@property (nonatomic, strong)IBOutlet UIView *weightView;
@property (nonatomic, strong)IBOutlet UIPickerView *weightPicker;
@property (nonatomic, strong)IBOutlet UILabel *weightLabel;

// General dialog values
@property (nonatomic, strong)IBOutlet UIButton *next;
@property (nonatomic) BOOL *validated;
@property (nonatomic, strong) SBApplicationModel *model;



- (IBAction)loginWithFacebook:(id)sender;
- (IBAction)loginWithTwitter:(id)sender;
- (IBAction)loginWithRegister:(id)sender;

@end
