//
//  SBLoginViewController.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 24.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "SBLoginViewController.h"
#import "Animation.h"
#import "ApplicationManager.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "Log.h"
#import "SlimboxServices.h"


@interface SBLoginViewController ()
@property (nonatomic, strong) PUser *user;
@end

@implementation SBLoginViewController

/**
 */
- (void)initMetaBar
{
    
}

/**
 Login screen with animations.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.slideShow.imageNames = @[@"#log#pic#01.png", @"#log#pic#02.png", @"#log#pic#03.png", @"#log#pic#04.png", @"#log#pic#05.png"];
    self.movingText1.strings = [@[@"", @"Bewusst", @"Einfach", @"Ein langes", @"Gesund"] mutableCopy];
    self.movingText.strings = [@[@"SLIM BOX", @"LEBEN", @"ABNEHMEN", @"LEBEN", @"AUSSEHEN"] mutableCopy];
    [self.movingText setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:50] color:[UIColor whiteColor]];
    
    [self.slideShow start];
    [self.movingText start];
    
    self.movingText.duration = 3;
    [self.movingText setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:50] color:[UIColor whiteColor]];
    [self.movingText1 start];
    
    self.movingText1.duration = 4;
    [self.movingText1 setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:35] color:[ApplicationManager colorWithHexString:@"008CCA"]];
    
    [Animation moveX:self.facebookButton duration:1 from:600 to:-20 delegate:self animationID:@""];
    [Animation moveX:self.twitterButton duration:2 from:600 to:-20 delegate:self animationID:@""];
    [Animation moveX:self.registerButton duration:3 from:600 to:-20 delegate:self animationID:@""];
    [Animation moveX:self.registerLabel duration:2 from:600 to:0 delegate:self animationID:@""];
    [Animation moveX:self.backgroundScrollerView duration:1 from:-1000 to:0 delegate:self animationID:@""];
    
    self.model = [ApplicationManager model];
}

#pragma mark - Social Media Login Actions

/**
 Login in with Facebook.
 */
- (IBAction)loginWithFacebook:(id)sender
{
    RACSignal *loginSignal = [[[SlimboxServices instance] loginWithFacebook]
                              then:^RACSignal*{
        return [[SlimboxServices instance] facebookGetUserData];
    }];

    [loginSignal subscribeNext:^(id value)
    {
        Log(10, [ApplicationManager translate:@"LogInSuccess"],@"");
        [self removeLoginButttons];
        [self showEnterNameDialog];
    }];
 }

/**
 Animate the buttons out of the screen.
 */
- (void)removeLoginButttons
{
    [Animation moveX:self.facebookButton duration:1 from:-20 to:-[ApplicationManager getScreenWidth]*2 delegate:self animationID:@""];
    [Animation moveX:self.twitterButton duration:2 from:-20 to:-[ApplicationManager getScreenWidth]*2 delegate:self animationID:@""];
    [Animation moveX:self.registerButton duration:3 from:-20 to:-[ApplicationManager getScreenWidth]*2 delegate:self animationID:@""];
    [Animation moveX:self.registerLabel duration:2 from:-20 to:-[ApplicationManager getScreenWidth]*2 delegate:self animationID:@""];
}

// #t: To be implemented the way Facebook is implemented.
- (IBAction)loginWithTwitter:(id)sender
{
    RACSignal *loginTwitter = [SlimboxServices loginWithTwitter];
    [loginTwitter subscribeNext:^(id x) {
        Log(10, [ApplicationManager translate:@"Twitter LogInSuccess"],@"");
        [self removeLoginButttons];
        [self showEnterNameDialog];
    }];
    
    [loginTwitter subscribeError:^(NSError *error) {
        [[ApplicationManager instance]systemError:@"Twitter Error" error:error option:0 completionBlock:nil];
    }];
}

/**
 Register with Email.
 */
- (IBAction)loginWithRegister:(id)sender
{
    [self removeLoginButttons];
    [self.model createObjectRegisterWith:kSBRegisterWithEmail];
    [self showEnterNameDialog];
}

#pragma mark - Enter Name Dialog

/**
 Loads and shows the dialog for enter the name. 
 */
- (void)showEnterNameDialog
{
    self.user = [ApplicationManager model].currentUser;
    
    [ApplicationManager getNib:@"SBLoginNameView" owner:self];
    UIView *dialog = self.nameView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterNameNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = false;
    self.firstName.text = self.model.currentUser.name;
    self.secondName.text = self.model.currentUser.surname;
 }

/**
 Validate and next.
 */
- (IBAction)enterNameNext:(id)sender
{
    // Validation
    self.validated = (self.firstName.text.length > 0 && self.secondName.text.length > 0) ? true : false;
    
    // Store and execute next
    if (self.validated)
    {
        self.model.currentUser[@"name"] = self.firstName.text;
        self.model.currentUser[@"surname"] = self.secondName.text;
        
        UIView *dialog = self.nameView;
        [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
        [self showEnterEmailDialog];
    }
    else
    {
        [[ApplicationManager instance] systemError:[ApplicationManager translate:@"Bitte füllen Sie die Felder richtig aus um fortzufahren."] error:nil option:nil completionBlock:nil];
    }
}


#pragma mark - Enter Email Dialog

/**
 Loads and shows the dialog for enter the name.
 */
- (void)showEnterEmailDialog
{
    [ApplicationManager getNib:@"SBLoginEmail" owner:self];
    UIView *dialog = self.emailView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterEmailNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = true;
    self.emailTextField.text = self.model.currentUser[@"email"];
}

/**
 Validate and next.
 */
- (IBAction)enterEmailNext:(id)sender
{
    // Validation
    self.validated = [ApplicationManager NSStringIsValidEmail:self.emailTextField.text];
    
    // Store, execute
    if (self.validated)
    {
        self.model.currentUser[@"email"] = self.emailTextField.text;

        UIView *dialog = self.emailView;
        [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
        [self showEnterGenderDialog];
    }
    else
    {
        [[ApplicationManager instance] systemError:[ApplicationManager translate:@"Bitte füllen Sie die Felder richtig aus um fortzufahren."] error:nil option:nil completionBlock:nil];
    }
}


#pragma mark - Enter Gender

/**
 Loads and shows the dialog for enter the name.
 */
- (void)showEnterGenderDialog
{
    [ApplicationManager getNib:@"SBLoginGenderView" owner:self];
    UIView *dialog = self.genderView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterGenderlNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = true;
    int gender = ([self.model.currentUser.gender isEqualToString:@"Male"])?1:0;
    [self.genderPicker selectRow:1 inComponent:gender animated:YES];
}

/**
 No Validation, execute next.
 */
- (IBAction)enterGenderlNext:(id)sender
{
    if (self.validated)
    {
        self.model.currentUser.gender = ([self.genderPicker selectedRowInComponent:0]==0)?@"Female":@"Male";
        UIView *dialog = self.genderView;
        [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
        [self showEnterBirthdateDialog];
    }
}


#pragma mark - Enter Birthdate

/**
 Loads and shows the dialog for enter the name.
 */
- (void)showEnterBirthdateDialog
{
    [ApplicationManager getNib:@"SBLoginBirthdateView" owner:self];
    UIView *dialog = self.birthdateView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterBirthdaylNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = true;
    [self.birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    [self.birthdayPicker setDate:self.model.currentUser.birthdate];
}

/**
 Brithday Next
 */
- (IBAction)enterBirthdaylNext:(id)sender
{
    // Validation, nope cant only be some date.
    self.model.currentUser.birthdate= [self.birthdayPicker date];
    UIView *dialog = self.birthdateView;
    [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self showEnterSizeDialog];
}

#pragma mark - Enter Size

/**
 Loads and shows the dialog for enter the name.
 */
- (void)showEnterSizeDialog
{
    [ApplicationManager getNib:@"SBLoginSize" owner:self];
    UIView *dialog = self.sizeView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterSizeNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = true;
    self.sizePicker.delegate = self;
    [self.sizePicker selectRow:[self.model.currentUser.bodysize integerValue] inComponent:0 animated:YES];
}

/**
 */
- (IBAction)enterSizeNext:(id)sender
{
    // No vlidation
    self.model.currentUser.bodysize = @([self.sizePicker selectedRowInComponent:0]);
    UIView *dialog = self.sizeView;
    [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self showEnterWeightDialog];
}

#pragma mark - Enter Weight

/**
 Loads and shows the dialog for enter the name.
 */
- (void)showEnterWeightDialog
{
    [ApplicationManager getNib:@"SBLoginBodyweight" owner:self];
    UIView *dialog = self.weightView;
    dialog.frame = CGRectMake(0, 0, [ApplicationManager getScreenWidth], dialog.frame.size.height);
    [self.view addSubview:dialog];
    [Animation fadeIn:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [self.next addTarget:nil action:@selector(enterWeightlNext:) forControlEvents:UIControlEventTouchUpInside];
    self.validated = true;
    [self.weightPicker selectRow:[self.model.currentUser.bodyweight integerValue] inComponent:0 animated:YES];
}

/**
 Weight Data, save and start Healthstream.
 */
- (IBAction)enterWeightlNext:(id)sender
{
    self.model.currentUser.bodyweight = @([self.weightPicker selectedRowInComponent:0]);
    [self.model.currentUser save];
    UIView *dialog = self.weightView;
    [Animation fadeOut:dialog duration:3 completionBlock:^(POPAnimation *anim, BOOL finished){}];
    [[ApplicationManager instance] execute:@"Healthstream"];
}

# pragma mark - PickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.genderPicker)
    {
        if (row == 0)
        {
            return [ApplicationManager translate:@"Woman"];
        }
        if (row == 1)
        {
            return [ApplicationManager translate:@"Men"];
        }
    }

    if (pickerView == self.sizePicker && component == 0)
    {
        return [NSString stringWithFormat:@"%ld", (long)row];
    }

    if (pickerView == self.sizePicker && component == 1)
    {
        if (row == 0)
        {
            return [ApplicationManager translate:@"cm"];
        }
    }
    
    if (pickerView == self.weightPicker && component == 0)
    {
        return [NSString stringWithFormat:@"%ld", (long)row];
    }
    
    if (pickerView == self.weightPicker && component == 1)
    {
        if (row == 0)
        {
            return [ApplicationManager translate:@"kg"];
        }
    }
    
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.genderPicker)
    {
        return 1;
    }
    
    if (pickerView == self.sizePicker)
    {
        return 2;
    }
    
    if (pickerView == self.weightPicker)
    {
        return 2;
    }
    
    return 0;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.genderPicker)
    {
        return 2;
    }
    
    if (pickerView == self.sizePicker && component == 0)
    {
        return 250;
    }

    if (pickerView == self.sizePicker && component == 1)
    {
        return 1;
    }
    
    if (pickerView == self.weightPicker && component == 0)
    {
        return 150;
    }
    
    if (pickerView == self.weightPicker && component == 1)
    {
        return 1;
    }
    
    return 0;
}


#pragma mark - Global Delegate Methods

/**
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstName) {
        [self.secondName becomeFirstResponder];
    }
    if (textField == self.secondName)
    {
        [self.next becomeFirstResponder];
    }
    
    return YES;
}


@end


