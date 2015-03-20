/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#import "SBDebugViewController.h"
#import "MetaMenuTableViewController.h"
//#import "SBHealthStreamViewController.h"

@interface SBDebugViewController ()
@property (nonatomic, strong) UIViewController *workController;
@end

@implementation SBDebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor purpleColor];
    
    /* Test MetaMenu */
    self.workController = [[MetaMenuTableViewController alloc] initWithNibName:@"MetaMenuTableViewController" bundle:nil];
    
    //self.workController = [[SBHealthStreamViewController alloc] initWithNibName:@"SBHealthStreamViewController" bundle:nil];
    [self.view addSubview:self.workController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
