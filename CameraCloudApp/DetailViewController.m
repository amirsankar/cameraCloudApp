//
//  DetailViewController.m
//  CameraCloudApp
//
//  Created by amir sankar on 8/17/16.
//  Copyright © 2016 amir sankar All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.currentPhoto.noOfLikes];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *cellNib = [UINib nibWithNibName:@"DetailTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
//    self.detailImage.image = [UIImage imageNamed:@"mapicon"];
    self.detailImage.image = self.imageToSet;
    self.datamanager = [DAO dataManager];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentPhoto.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    DetailTableViewCell *cell = (DetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // set the UITABLEVIEWCELLSTYLE to subtitle
               cell = [[DetailTableViewCell alloc] init];//WithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    // Configure the cell...
    NSString *comment = self.currentPhoto.comments[indexPath.row];
//    cell.textLabel.text = @"JFAEZ";
//    cell.detailTextLabel.numberOfLines = 0;
//    cell.detailTextLabel.text = comment;
    cell.commentLabel.text = comment;
    cell.commentAuthorLabel.text = @"JFAEZ";
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString *cellString =self.currentPhoto.comments[indexPath.row];
//    CGFloat cellHeight = (float)(0.2 * cellString.length);
//    
//    return 70;
//}


- (IBAction)tappedLike:(id)sender {
    
    NSLog(@"LIKED!");
    self.currentPhoto.noOfLikes = [NSNumber numberWithInteger:([self.currentPhoto.noOfLikes integerValue] + 1)];
    self.likeLabel.text = [NSString stringWithFormat:@"%@", self.currentPhoto.noOfLikes];
    [self.likeLabel sizeToFit];
    [self.datamanager updateLikesForPhoto:self.currentPhoto];
   
}

- (IBAction)tappedComment:(id)sender {
    
    
        NSString *title = NSLocalizedString(@"Say something about this photo", nil);
//        NSString *message = NSLocalizedString(@"optional subtitle.", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"Post", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Add the text field for text entry.
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // If you need to customize the text field, you can do so here.
        }];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Text Entry\" alert's cancel action occured.");
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"The \"Text Entry\" alert's other action occured.");
            [self.currentPhoto.comments addObject:alertController.textFields[0].text];
            [self.tableView reloadData];
            [self.datamanager updateCommentsForPhoto:self.currentPhoto];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)tappedMore:(id)sender {
    NSString *deletePhotoTitle = NSLocalizedString(@"Delete Photo", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:deletePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"Other\" alert action sheet's destructive action occured.");
        [self.datamanager deletePhotowithImageKey:self.currentPhoto.imageKey andStorageFileName:self.currentPhoto.storageFile];
        [self.datamanager.photos removeObject:self.currentPhoto];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Other\" alert action sheet's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:destructiveAction];
    [alertController addAction:otherAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];

    NSLog(@"More");
}
@end
