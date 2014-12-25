//
//  CollectionViewController.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 23/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    @IBOutlet var photoAlbumLayout:PhotoAlbumLayout?
    var thumbnailQueue:NSOperationQueue!
    
    var albums:[Album] = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var patternImage = UIImage(named: "concrete_wall")
        self.collectionView?.backgroundColor = UIColor(patternImage: patternImage!)

        self.collectionView?.registerNib(UINib(nibName: "AlbumTitleReusableView", bundle: nil), forSupplementaryViewOfKind: PhotoAlbumLayoutAlbumTitleKind, withReuseIdentifier: "AlbumTitle")
        
        var urlPrefix = NSURL(string: "https://raw.githubusercontent.com/ShadoFlameX/PhotoCollectionView/master/Photos/")
        var photoIndex = 0
        for var a = 0; a < 12; a++ {
            var album = Album()
            album.name = "Photo Album \(a+1)"
            
            var photoCount = Int(arc4random() % 4 + 2)
            for var p = 0; p < photoCount; p++ {
                var photoFileName = "thumbnail\(photoIndex % 25).jpg"
                var photoURL = urlPrefix?.URLByAppendingPathComponent(photoFileName)
                var photo = Photo(imageURL: photoURL!)
                album.addPhoto(photo)
                photoIndex++
            }
            
            self.albums.append(album)
        }
        
        self.thumbnailQueue = NSOperationQueue()
        self.thumbnailQueue.maxConcurrentOperationCount = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.albums.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.albums[section].photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as AlbumPhotoCell
    
        var photo = self.albums[indexPath.section].photos[indexPath.row]
        var operation = NSBlockOperation { () -> Void in
            let imageData = NSData(contentsOfURL: photo.imageURL!)
            var image = UIImage(data: imageData!, scale: UIScreen.mainScreen().scale)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let visibleIndexPaths = self.collectionView?.indexPathsForVisibleItems() as? [NSIndexPath] {
                    if find(visibleIndexPaths, indexPath) != nil {
                        var cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as AlbumPhotoCell
                        cell.imageView.image = image
                    }
                }
            })
        }
        operation.queuePriority = (indexPath.item == 0) ? NSOperationQueuePriority.High : NSOperationQueuePriority.Normal
        self.thumbnailQueue.addOperation(operation)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var titleView = collectionView.dequeueReusableSupplementaryViewOfKind(PhotoAlbumLayoutAlbumTitleKind, withReuseIdentifier: "AlbumTitle", forIndexPath: indexPath) as AlbumTitleReusableView
        var album = self.albums[indexPath.section]
        titleView.titleLabel.text = album.name
        
        return titleView
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            self.photoAlbumLayout?.numberOfColumns = 3
            
            var sideInset = CGFloat(UIScreen.mainScreen().preferredMode.size.width == 1136.0 ? 45.0 : 25.0)
            self.photoAlbumLayout?.itemInsets = UIEdgeInsetsMake(22, sideInset, 13, sideInset)
        } else {
            self.photoAlbumLayout?.numberOfColumns = 2
            self.photoAlbumLayout?.itemInsets = UIEdgeInsetsMake(22, 22, 13, 22)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
