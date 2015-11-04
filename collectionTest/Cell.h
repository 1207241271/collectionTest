//
//  Cell.h
//  
//
//  Created by yangxu on 15/10/31.
//
//

#import <UIKit/UIKit.h>

@class Cell;
@protocol CellDelegate <NSObject>

-(void)handlePan:(UIPanGestureRecognizer*)gesture;

@end

@interface Cell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel *label;
@property (weak, nonatomic) id<CellDelegate>  delegate;
@end
