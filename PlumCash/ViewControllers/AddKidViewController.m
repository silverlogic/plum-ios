//
//  AddKidViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "AddKidViewController.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "DBCameraLibraryViewController.h"
#import "DBCameraGridView.h"
#import "Kid.h"
#import "APIClient.h"
#import "UIViewController+Alert.h"
#import "NSObject+ProgressHUD.h"

@interface AddKidViewController () <DBCameraViewControllerDelegate>

@property (nonatomic, strong) Kid *kid;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *allowance;

@property (strong, nonatomic) IBOutlet UITextField *cardName;
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *cardExpirationDate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)editImagePressed:(id)sender;
- (IBAction)editCategoriesPressed:(id)sender;

@end

@implementation AddKidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.kid = [Kid new];
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // yay
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    self.kid.name = self.name.text;
    
    [self showProgressHudWithTitle:@"Saving kid..." message:nil];
    [APIClient createKid:self.kid success:^(Kid *kid) {
        [self hideAllHUDs];
        [self dismissViewControllerAnimated:YES completion:^{
            //yay
        }];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        [self hideAllHUDs];
        [self showMessage:error.localizedDescription withType:MessageTypeError];
    }];
}

- (IBAction)editImagePressed:(id)sender {
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setForceQuadCrop:YES];
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)editCategoriesPressed:(id)sender {
}

#pragma mark - DBCameraViewControllerDelegate
- (void) dismissCamera:(id)cameraViewController{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
    
    //if retaking image, don't cancel
    if (!self.kid.image) {
        [self cancel:nil];
    }
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    // set image
    self.kid.image = image;
    self.imageView.image = image;
    
    [cameraViewController restoreFullScreenMode];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
