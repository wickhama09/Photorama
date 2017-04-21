//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Tony on 3/28/17.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    let photoDataSource = PhotoDataSource()
    var store: PhotoStore!
    
    
    
    
    @IBOutlet var segcontrolFavorites: UISegmentedControl!
    
    // Added code for favorites
    @IBAction func segcontrolFavoritesToggled(_ sender: UISegmentedControl) {
        if segcontrolFavorites.selectedSegmentIndex == 0 {
            print("All is selected")
        }
        else
        {
            print("Favorites is selected")
        }
        updateDataSource()
    }
   
    // Added code for favorites
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDataSource()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segcontrolFavorites.selectedSegmentIndex = 0
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            self.updateDataSource()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo) {
            (result) -> Void in
            
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            
            
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
                    
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            // When the request finishes, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
                
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    // edited code for favorites
    private func updateDataSource() {
        
        
        if (segcontrolFavorites.selectedSegmentIndex == 0)
        {
            store.fetchAllPhotos {
                (photosResult) in
                
                switch photosResult {
                case let .success(photos):
                    self.photoDataSource.photos = photos
                case .failure:
                    self.photoDataSource.photos.removeAll()
                    
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
        else
        {
            store.fetchFavoritePhotos {
                (photosResult) in
                
                switch photosResult {
                case let .success(photos):
                    self.photoDataSource.photos = photos
                case .failure:
                    self.photoDataSource.photos.removeAll()
                    
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
        
        
    }
    
    
    
    
    
    
}



extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Set row count to 4 and size relative to view width
        let collectionViewWidth = collectionView.bounds.size.width
        let numberOfItemsPerRow: CGFloat = 4
        let itemWidth = collectionViewWidth / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // reload when screen transitions to landscape
        collectionView.reloadData()
    }
}
