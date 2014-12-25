//
//  AlbumTitleReusableView.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 25/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import UIKit

class AlbumTitleReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}
