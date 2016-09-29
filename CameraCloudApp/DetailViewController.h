//
//  DetailViewController.h
//  CameraCloudApp
//
//  Created by amir sankar on 8/17/16.
//  Copyright © 2016 amir sankar All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "DAO.h"
#import "DetailTableViewCell.h"

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *detailImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (nonatomic, strong) DAO *datamanager;

@property (strong, nonatomic) Photo *currentPhoto;
@property (strong, nonatomic) UIImage *imageToSet;

- (IBAction)tappedLike:(id)sender;
- (IBAction)tappedComment:(id)sender;
- (IBAction)tappedMore:(id)sender;

@end
