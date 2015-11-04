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

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight)];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@"add.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
    }];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
