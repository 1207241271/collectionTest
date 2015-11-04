//
//  waterfallView.h
//  
//
//  Created by yangxu on 15/10/31.
//
//

#import <UIKit/UIKit.h>
#import "Cell.h"


@interface waterfallView : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic, strong) UICollectionView * collectionView;

@end
