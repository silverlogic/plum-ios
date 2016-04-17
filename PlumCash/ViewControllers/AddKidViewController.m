//
//  AddKidViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "AddKidViewController.h"

@interface AddKidViewController ()
@property (strong, nonatomic) IBOutlet UITextField *name;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)editImagePressed:(id)sender;
- (IBAction)editCategoriesPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *cardName;
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *cardExpirationDate;
@property (strong, nonatomic) IBOutlet UITextField *allowance;

@end

@implementation AddKidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
		//yay
	}];
}

- (IBAction)save:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		//yay
	}];
}

- (IBAction)addCardPressed:(id)sender {
	[self performSegueWithIdentifier:@"addCardKidSegue" sender:self];

}
- (IBAction)editImagePressed:(id)sender {
}

- (IBAction)editCategoriesPressed:(id)sender {
}
@end
