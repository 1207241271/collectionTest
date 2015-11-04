//
//  waterfallView.m
//  
//
//  Created by yangxu on 15/10/31.
//
//

#import "waterfallView.h"
#import "Cell.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import <AddressBook/AddressBook.h>

@implementation waterfallView{
    NSInteger loadNumb;
    NSInteger currentIndex;
    NSArray *arrayImage;
    NSArray *arrayUrl;
    NSInteger times;
    NSArray *listContacts;
}

#define debug 1
#define CellHeight 150

#pragma mark - Data
-(void)setupData{
    loadNumb=6;
    times=0;
    NSString *imageFile=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"image.plist"];
    arrayImage=[[NSArray alloc] initWithContentsOfFile:imageFile];
    NSString *urlFile=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Url.plist"];
    arrayUrl=[[NSArray alloc] initWithContentsOfFile:urlFile];
    
    
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            listContacts=CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
        }
    });
    CFRelease(addressBook);
}


#pragma mark - View
-(void)initView{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    //init collection
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, fDeviceWidth, fDeviceHeight) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    //refresh api
        __weak waterfallView *weakSelf=self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        if (times==0) {
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
            times=1;
        }else{
        [weakSelf refreshData];
        }
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertData];
    }];
}

-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }

    [super viewDidLoad];
    [self setupData];
    [self initView];

}

- (void)viewDidAppear:(BOOL)animated {
    // refresh api
    [self.collectionView triggerPullToRefresh];
}

#pragma mark - UICollection Delegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    return loadNumb;
}



-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    static NSString * cellIdentifier=@"Cell";
    Cell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    NSURL *imageUrl=[NSURL URLWithString:[[arrayUrl objectAtIndex:indexPath.row] objectAtIndex:indexPath.section%6]];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"add.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@",imageURL);
        //cell.imageView.image=image;
    }];
    
    ABRecordRef person=CFBridgingRetain([listContacts objectAtIndex:indexPath.section]);
    NSString *firstName=CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    firstName=firstName!=nil?firstName:@"";
    NSString *lastName=CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    lastName=lastName!=nil?lastName:@"";
    
    cell.label.text=[NSString stringWithFormat:@"%@  %@",firstName,lastName];

    CFRelease(person);
    return cell;
}

#pragma mark - Refresh Func
-(void)refreshData{
    __weak waterfallView *weakSelf=self;
    int64_t delayInSecond=2.0;
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, delayInSecond * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        loadNumb=6;
        NSMutableArray *arrayTemp=[NSMutableArray arrayWithArray:arrayUrl];
        [arrayTemp exchangeObjectAtIndex:0 withObjectAtIndex:1];
        NSLog(@"%@",arrayUrl);
        arrayUrl=nil;
        arrayUrl=[NSArray arrayWithArray:arrayTemp];
        NSLog(@"%@",arrayUrl);
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
    });
}




-(void)insertData{
    __weak waterfallView *weakSelf=self;
    int64_t delayInSecond=2.0;
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, delayInSecond * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (loadNumb==listContacts.count) {
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            return ;
        }
        else loadNumb+=3;
        if (loadNumb>listContacts.count) {
            loadNumb=listContacts.count;
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    });
}

#pragma mark - Action

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    DetailViewController *detailViewController=[[DetailViewController alloc]init];
    detailViewController.imageUrl=[[arrayUrl objectAtIndex:indexPath.row] objectAtIndex:indexPath.section%6];
    detailViewController.index=indexPath.section;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - cellController
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,0,0,0};
    return top;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"%f",(kDeviceHeight-88-49)/4.0);
    return CGSizeMake(150,150);
}
@end
