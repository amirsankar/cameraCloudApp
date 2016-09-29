//
//  MomentsViewController.h
//  CameraCloudApp
//
//  Created by amir sankar on 8/8/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "ImageCell.h"
#import "DetailViewController.h"

@import Firebase;

@interface MomentsViewController : UIViewController<UICollectionViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) DAO *datamanager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) DetailViewController *detailVC;



@end

