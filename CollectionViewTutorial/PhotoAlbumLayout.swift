//
//  PhotoAlbumLayout.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 23/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import UIKit

public let PhotoAlbumLayoutPhotoCellKind:String = "PhotoCell"
public let PhotoAlbumLayoutAlbumTitleKind:String = "AlbumTitle"
public let PhotoAlbumLayoutEmblemKind:String = "Emblem"

let RotationCount = 32
let RotationStride = 3
let PhotoCellBaseZIndex = 100

class PhotoAlbumLayout: UICollectionViewLayout {
    private var layoutInfo:Dictionary<String,Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>>
        = Dictionary<String,Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>>()
    private var rotations:[CATransform3D] = [CATransform3D]()
    
    var itemInsets:UIEdgeInsets! {
        didSet {
            self.invalidateLayout()
        }
    }
    var itemSize:CGSize! {
        didSet {
            self.invalidateLayout()
        }
    }
    var interItemSpacingY:CGFloat!{
        didSet {
            self.invalidateLayout()
        }
    }
    var numberOfColumns:NSInteger!{
        didSet {
            self.invalidateLayout()
        }
    }
    var titleHeight:CGFloat! {
        didSet {
            self.invalidateLayout()
        }
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.registerNib(UINib(nibName: "EmblemView", bundle: nil), forDecorationViewOfKind: PhotoAlbumLayoutEmblemKind)
        
        self.itemInsets = UIEdgeInsetsMake(22, 22, 13, 22)
        self.itemSize = CGSizeMake(150, 150)
        self.interItemSpacingY = 20
        self.numberOfColumns = 2
        self.titleHeight = 26
        
        var percentage:Float = 0.0
        for var i = 0; i < RotationCount; i++ {
            var newPercentage:Float = 0.0
            do {
                newPercentage = Float(Int(arc4random() % 220) - 110) * 0.0001;
            } while fabsf(Float(newPercentage - percentage)) < 0.006
            percentage = newPercentage
            
            var angle = 2.0 * Float(M_PI) * (1.0 + percentage)
            var transform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
            self.rotations.append(transform)
        }
    }
    
    func transformForAlbumPhotoAtIndexPath(indexPath:NSIndexPath) -> CATransform3D {
        var offset = (indexPath.section * RotationStride + indexPath.item)
        return self.rotations[offset % RotationCount]
    }
    
    override func prepareLayout() {
        var newLayoutInfo = Dictionary<String,Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>>()
        var cellLayoutInfo = Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>()
        var titleLayoutInfo = Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>()
        
        var sectionCount = self.collectionView?.numberOfSections()
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        var emblemAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: PhotoAlbumLayoutEmblemKind, withIndexPath: indexPath)
        emblemAttributes.frame = self.frameForEmblem()
        newLayoutInfo[PhotoAlbumLayoutEmblemKind] = [indexPath: emblemAttributes]
        
        for(var section = 0; section < sectionCount; section++){
            var itemCount = self.collectionView?.numberOfItemsInSection(section)
            
            for(var item = 0; item < itemCount; item++){
                indexPath = NSIndexPath(forItem: item, inSection: section)
                
                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = self.frameForAlbumPhotoAtIndexPath(indexPath)
                itemAttributes.transform3D = self.transformForAlbumPhotoAtIndexPath(indexPath)
                itemAttributes.zIndex = PhotoCellBaseZIndex + itemCount! - item
                
                cellLayoutInfo[indexPath] = itemAttributes
                
                if indexPath.item == 0 {
                    var titleAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: PhotoAlbumLayoutAlbumTitleKind, withIndexPath: indexPath)
                    titleAttributes.frame = self.frameForAlbumTitleAtIndexPath(indexPath)
                    
                    titleLayoutInfo[indexPath] = titleAttributes
                }
            }
        }
        
        newLayoutInfo[PhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo
        newLayoutInfo[PhotoAlbumLayoutAlbumTitleKind] = titleLayoutInfo
        self.layoutInfo = newLayoutInfo
    }
    
    func frameForAlbumTitleAtIndexPath(indexPath:NSIndexPath) -> CGRect {
        var frame = self.frameForAlbumPhotoAtIndexPath(indexPath)
        frame.origin.y += frame.size.height
        frame.size.height = self.titleHeight
        
        return frame
    }
    
    func frameForAlbumPhotoAtIndexPath(indexPath:NSIndexPath) -> CGRect {
        var row = indexPath.section / self.numberOfColumns;
        var column = indexPath.section % self.numberOfColumns;
        
        var spacingX = self.collectionView!.bounds.size.width -
            self.itemInsets.left -
            self.itemInsets.right -
            (CGFloat(self.numberOfColumns) * self.itemSize.width);
        
        if self.numberOfColumns > 1 {
            spacingX = spacingX / CGFloat(self.numberOfColumns - 1)
        }
        
        var originX = floorf(Float(self.itemInsets.left + (self.itemSize.width + spacingX) * CGFloat(column)))
        
        var originY = floor(self.itemInsets.top + (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * CGFloat(row))
        
        return CGRectMake(CGFloat(originX), CGFloat(originY), self.itemSize.width, self.itemSize.height)
    }
    
    func frameForEmblem() -> CGRect {
        var size = EmblemView.defaultSize()
        var originX = floorf(Float(self.collectionView!.bounds.size.width - size.width) * Float(0.5))
        var originY = -size.height - 30.0
        
        return CGRectMake(CGFloat(originX), CGFloat(originY), size.width, size.height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var allAttributes = Array<AnyObject>()
        for (elementIdentifier, elementsInfo) in self.layoutInfo {
            for (indexPath, attributes) in elementsInfo {
                if CGRectIntersectsRect(rect, attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutInfo[PhotoAlbumLayoutPhotoCellKind]?[indexPath]
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutInfo[PhotoAlbumLayoutAlbumTitleKind]?[indexPath]
    }
    
    override func collectionViewContentSize() -> CGSize {
        var rowCount = self.collectionView!.numberOfSections() / self.numberOfColumns
        if self.collectionView!.numberOfSections() % self.numberOfColumns > 0 {
            rowCount++
        }
        
        var height = self.itemInsets.top + CGFloat(rowCount) * self.itemSize.height + CGFloat(rowCount - 1) * self.interItemSpacingY + CGFloat(rowCount) * self.titleHeight + self.itemInsets.bottom
        
        return CGSizeMake(self.collectionView!.bounds.size.width, height)
    }
    
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutInfo[PhotoAlbumLayoutEmblemKind]?[indexPath]
    }
}
