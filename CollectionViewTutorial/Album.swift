//
//  Album.swift
//  CollectionViewTutorial
//
//  Created by Sebastien Arbogast on 24/12/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

import Foundation

class Album {
    var name:String = ""
    var photos:[Photo] = [Photo]()
    
    init() {
        
    }
    
    func addPhoto(photo:Photo) {
        self.photos.append(photo)
    }
    
    func removePhoto(photo:Photo) -> Bool {
        var index = find(self.photos, photo)
        if index == nil {
            return false
        } else {
            self.photos.removeAtIndex(index!)
            return true
        }
    }
}