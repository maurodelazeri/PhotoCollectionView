//
//  AlbumPhotoCell.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 23/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import UIKit

class AlbumPhotoCell: UICollectionViewCell {
    @IBOutlet var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 3
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSizeMake(0, 2)
        self.layer.shadowOpacity = 0.5
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.shouldRasterize = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
