//
//  AddCardViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()
- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *cardHolderName;
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *cardDate;

@end

@implementation AddCardViewController

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

- (IBAction)cancelPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		//yay
	}];
}

- (IBAction)savePressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		//yay
	}];
}
@end
