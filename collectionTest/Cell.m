//
//  Cell.m
//  
//
//  Created by yangxu on 15/10/31.
//
//

#import "Cell.h"

@implementation Cell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 130)];
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(54, 130, 42, 20)];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}


@end
