//
//  DetailViewController.m
//  
//
//  Created by yangxu on 15/11/2.
//
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <AddressBook/AddressBook.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight)];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"add.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
    }];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 270, 50, 30)];
    nameLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    nameLabel.text=@"Name:";
    
    
    UILabel *phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 310, 50, 30)];
    phoneLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    phoneLabel.text=@"Phone:";
    
    UITextField *nameText=[[UITextField alloc] initWithFrame:CGRectMake(100, 270, 200, 30)];
    
    UITextField *phoneText=[[UITextField alloc] initWithFrame:CGRectMake(100,310,200,30)];
    
    ABRecordID personID=self.index+1;
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    ABRecordRef person=ABAddressBookGetPersonWithRecordID(addressBook, personID);
    
    
    NSString *firstName=CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    firstName=firstName!=nil?firstName:@"";
    NSString *lastName=CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    lastName=lastName!=nil?lastName:@"";
    nameText.text=[NSString stringWithFormat:@"%@  %@",firstName,lastName];
    
    ABMutableMultiValueRef phonesProperty=ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *phoneArray=CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phonesProperty));
    phoneText.text=[phoneArray objectAtIndex:0];
    
  //  nameText.text=
    
    
    [self.view addSubview:imageView];
    [self.view addSubview:nameLabel];
    [self.view addSubview:nameText];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:phoneText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
