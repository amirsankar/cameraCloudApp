//
//  DAO.h
//  CameraCloudApp
//
//  Created by Jesse Sahli on 8/8/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
@import Firebase;

@interface DAO : NSObject

@property FIRStorage *storage;
@property FIRStorageReference *storageRef;
@property FIRStorageReference *stockPhotoRef;
@property FIRStorageReference *imagesRef;
@property NSMutableArray *photos;

+ (id)dataManager;
- (void)createReferences;
- (void)populatePhotoArray;
- (void)uploadToFirebaseStorageWithData: (NSData*) imageData fileName: (NSString*) fileName;
- (void)updateLikesForPhoto: (Photo*) photo;
- (void)updateCommentsForPhoto: (Photo*) photo;
- (void)deletePhotowithImageKey:(NSString*)imageKey
             andStorageFileName:(NSString*)storFile;


@end
