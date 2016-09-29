//
//  MomentsViewController.m
//  CameraCloudApp
//
//  Created by amir sankar on 8/8/16.
//  Copyright © 2016 amir sankar All rights reserved.
//

#import "MomentsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MomentsViewController ()

@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.datamanager = [DAO dataManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"refresh" object:nil];
    [self.datamanager populatePhotoArray];
    }

-(void)viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

-(void)populateCollectionView {
    [self.datamanager populatePhotoArray];
}

-(void)receiveNotification: (NSNotification*) notification {
    if ([[notification name] isEqualToString:@"refresh"]) {
        [self.collectionView reloadData];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.datamanager.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *tempURL = (NSString*)[[self.datamanager.photos objectAtIndex:indexPath.row]downloadURL];
    

    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempURL]] placeholderImage:[UIImage imageNamed:@"hourGlass"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.imageView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

   [cell.backgroundView addSubview:cell.imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *currentCell = (ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.detailVC.currentPhoto = [self.datamanager.photos objectAtIndex:indexPath.row];
    self.detailVC.imageToSet = currentCell.imageView.image;
    
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.detailVC = [segue destinationViewController];
//    self.detailVC.detailImage.image = self.selectedImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
