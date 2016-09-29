//
//  SecondViewController.m
//  CameraCloudApp
//
//  Created by amir sankar on 8/8/16.
//  Copyright © amir sankar All rights reserved.
//

#import "PhotoLibraryViewController.h"

@interface PhotoLibraryViewController ()

@end

@implementation PhotoLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataManager = [DAO dataManager];
    UITapGestureRecognizer *choosePhotoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleChoosePhotoTap:)];
    [self.choosePhotoView addGestureRecognizer:choosePhotoTap];
    UITapGestureRecognizer *takePhotoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTakePhotoTap:)];
    [self.takePhotoView addGestureRecognizer:takePhotoTap];
}


//The event handling method
- (void)handleChoosePhotoTap:(UITapGestureRecognizer *)recognizer {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)handleTakePhotoTap:(UITapGestureRecognizer *)recognizer {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1);
        [self.dataManager uploadToFirebaseStorageWithData:imageData fileName:[self uuidString]];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.tabBarController setSelectedIndex:0]; 
}

- (NSString *)uuidString {
    // Returns a universally unique identifier
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
