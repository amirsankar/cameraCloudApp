//
//  PhotoLibraryViewController.h
//  CameraCloudApp
//
//  Created by amir sankar on 8/8/16.
//  Copyright © amir sankar All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface PhotoLibraryViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *choosePhotoView;
@property (weak, nonatomic) IBOutlet UIView *takePhotoView;
@property (weak, nonatomic) DAO *dataManager;

@end

