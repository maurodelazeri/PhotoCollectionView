//
//  EmblemView.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 25/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import UIKit

class EmblemView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func defaultSize() -> CGSize {
        return UIImage(named: "emblem")!.size
    }
}
