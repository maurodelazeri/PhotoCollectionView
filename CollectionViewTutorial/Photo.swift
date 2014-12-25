//
//  Photo.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 24/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import Foundation
import UIKit

class Photo: Equatable {
    var imageURL:NSURL?
    
    init(imageURL:NSURL){
        self.imageURL = imageURL
    }
}

func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.imageURL == rhs.imageURL
}