//
//  DAO.m
//  CameraCloudApp
//
//  Created by amir sankar on 8/8/16.
//  Copyright © amir sankar All rights reserved.
//

#import "DAO.h"
#import "AFNetworking.h"

static DAO *dataManager = nil;

@implementation DAO


+ (instancetype)dataManager {
    static id dataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

-(instancetype) init {
    self = [super init];
    _photos = [[NSMutableArray alloc] init];
    return self;
}


- (void)createReferences {
   
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://camera-cloud-app.appspot.com"];
    self.stockPhotoRef = [self.storageRef child:@"StockPhotos"];
}



- (void)uploadToFirebaseStorageWithData: (NSData*) imageData fileName: (NSString*) fileName {
    
    FIRStorage *storage = [FIRStorage storage];
    self.storageRef = [storage referenceForURL:@"gs://camera-cloud-app.appspot.com"];
    self.imagesRef = [self.storageRef child:@"images"];
    FIRStorageReference *newImageRef = [self.imagesRef child:[NSString stringWithFormat:@"%@",fileName]];

    FIRStorageUploadTask *uploadTask = [newImageRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
    if (error != nil) {
        // Uh-oh, an error occurred!
        NSLog(@"%@", error.localizedDescription);
        } else {
        // Metadata contains file metadata such as size, content-type, and download URL.
        //            NSURL *downloadURL = metadata.downloadURL;
 
            
            NSString *myDownloadURL = metadata.downloadURL.absoluteString;
            [self loadPostDataIntoDB:myDownloadURL withStorageFilename:fileName];
    }
  }
                                        ];
     NSLog(@"uploadtask is %@",uploadTask);
}




-(void)loadPostDataIntoDB:(NSString*)downloadURL withStorageFilename:(NSString*) storFileName {
    

    NSString *url = @"https://camera-cloud-app.firebaseio.com/images.json";
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    NSNumber *likes = [NSNumber numberWithInteger:0];
    
    NSDictionary *parametersDictionary = @{@"downloadURL": downloadURL,@"comments":comments,@"likes":likes , @"storageFile":storFileName};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"great success!");
        
        NSString *imageKey =  [responseObject objectForKey:@"name"];
        Photo *newPhoto = [[Photo alloc]initWithImageKey:imageKey downloadURL:downloadURL comments:comments storageFile:storFileName andLikes:likes];
        
        [self.photos addObject:newPhoto];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:self];
        
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
              
          }];
}





-(void)populatePhotoArray{
    
    NSString *url = @"https://camera-cloud-app.firebaseio.com/images.json";
    
    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSLog(@"%@", (NSDictionary*)responseObject);
        NSDictionary *imageDict = (NSDictionary*)responseObject;
//        NSLog(@"%lu", (unsigned long)imageDict.count);
      
        
        NSMutableArray *tempImageKeyArray = [[NSMutableArray alloc]init];
        [self.photos removeAllObjects];
        
        if ([imageDict respondsToSelector:@selector(allKeys)]){
        
        tempImageKeyArray = [imageDict.allKeys mutableCopy]; 
        for(NSString *imageKey in tempImageKeyArray){
            
            NSString *downloadURL = [[imageDict objectForKey:imageKey]objectForKey:@"downloadURL"];
            
            NSString *storageFile = [[imageDict objectForKey:imageKey]objectForKey:@"storageFile"];
            
            NSMutableArray *comments = [[NSMutableArray alloc] initWithArray:[[imageDict objectForKey:imageKey]objectForKey:@"comments"]];
            
            NSNumber *likes = [[imageDict objectForKey:imageKey]objectForKey:@"likes"];
            
            Photo *photo = [[Photo alloc]initWithImageKey:imageKey downloadURL:downloadURL comments:comments storageFile:storageFile andLikes:likes];
            

            if(![photo.downloadURL isEqualToString:@""]){
                [self.photos addObject:photo];
                
            }
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:self];
        }
     
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error: %@", error);
             
         }];
    
}



- (void)updateLikesForPhoto: (Photo*) photo {
    NSString *url = [NSString stringWithFormat:@"https://camera-cloud-app.firebaseio.com/images/%@.json",photo.imageKey];
    
    NSDictionary *parametersDictionary = @{@"likes":(photo.noOfLikes)};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}



- (void)updateCommentsForPhoto: (Photo*) photo {
    NSString *url = [NSString stringWithFormat:@"https://camera-cloud-app.firebaseio.com/images/%@.json",photo.imageKey];
    
    NSDictionary *parametersDictionary = @{@"comments":photo.comments};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}

-(void)deletePhotowithImageKey:(NSString*)imageKey
            andStorageFileName:(NSString*)storFile {
    
    NSString *url = [NSString stringWithFormat:@"https://camera-cloud-app.firebaseio.com/images/%@.json",imageKey];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    
    //ASK MORE ABOUT UNDERSTANDING THIS NEXT LINE OF CODE
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
        if(!self.storageRef ) {
        self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://camera-cloud-app.appspot.com"];
    }

        NSString *storageFilePath = [NSString stringWithFormat:@"images/%@", storFile];
        FIRStorageReference *desertRef = [self.storageRef child:storageFilePath];
        // Delete the file
        [desertRef deleteWithCompletion:^(NSError *error){
            if (error != nil) {
                // Uh-oh, an error occurred!
                NSLog(@"error: %@", error.localizedDescription);
            } else {
                // File deleted successfully
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:self];
            }
        }];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}









@end
