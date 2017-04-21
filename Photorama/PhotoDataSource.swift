//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Tony on 4/3/17.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                    for: indexPath) as! PhotoCollectionViewCell
        
        
        let photo = photos[indexPath.row]
        cell.photoDescription = photo.title
        
        
        
        return cell
        
    }
    
}
