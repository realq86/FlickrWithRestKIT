//
//  ParentCollectionViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "ParentCollectionViewController.h"
#import "ParentCollectionViewCell.h"
#import "ParentCollectionViewCell.h"

@interface ParentCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation ParentCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //Init common properties for all childs
    self.uiImageDictionary = [[NSMutableDictionary alloc] init];
    self.collectionView.pagingEnabled = NO;


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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.uiImageDictionary.count;
}

- (ParentCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ParentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParentCollectionViewCellID" forIndexPath:indexPath];
    
    // Set the uiImage inside the cell from the uiImageDictionary
    UIImage *image = [self.uiImageDictionary objectForKey:@(indexPath.row)];
    cell.imageView.image = image;
    NSLog(@"cellForItemAtIndexPath: imageView is %@", cell.imageView.image.description);
    [cell layoutSubviews];
    
    return cell;
}

#pragma UICollectionViewFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

//Set Size of Collection View Cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    UIImage *image = [self.uiImageDictionary objectForKey:@(indexPath.row)];
    CGSize cellBounds;
    CGSize parentSize = self.collectionView.bounds.size;

    //if image is portrit
    if(image.size.height > image.size.width){
        cellBounds.width = (parentSize.width-60)/2;
        cellBounds.height = cellBounds.width*1.7;
    } // if image is landscape
    else if( image.size.width > image.size.height){
        cellBounds.width = parentSize.width-40;
        cellBounds.height = cellBounds.width*0.6;
    }// if image is square
    else if( image.size.width == image.size.height){
        cellBounds.width = (parentSize.width-60)/2;
        cellBounds.height = cellBounds.width;
        
    }
    NSLog(@"collectionViewLayout sizeForItemAtIndexPath: imageView is %@", image.description);

    [self.collectionView layoutSubviews];
    
    return cellBounds;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    //Set CollectionView's active range to full screen within NavigationBar
    return UIEdgeInsetsMake(0, 20, 20, 20);
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
