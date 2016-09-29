//
//  Photo.h
//  CameraCloudApp
//
//  Created by amir sankar on 8/15/16.
//  Copyright © 2016 amir sankar All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *downloadURL;
@property (strong, nonatomic) NSMutableArray<NSString*> *comments;
@property NSNumber *noOfLikes;
@property (nonatomic,strong) NSString *imageKey;
@property (nonatomic, strong) NSString *storageFile;

- (instancetype)initWithImageKey:(NSString*)imageKey
                     downloadURL:(NSString*)downloadURL
                        comments:(NSMutableArray*)commentsArray
                     storageFile:(NSString*)storFile
                        andLikes:(NSNumber*)likes;

@end
