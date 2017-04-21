//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Tony on 4/6/17.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var store: PhotoStore!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    // New code for favorites
    @IBOutlet var switchFavorite: UISwitch!
    
    @IBAction func switchTapped(_ sender: Any) {
        if switchFavorite.isOn == true
        {
            photo.favorite = true
        }
        else
        {
            photo.favorite = false
        }
        store.saveContextIfNeeded()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (photo.favorite == true)
        {
            switchFavorite.setOn(true, animated: true)
        }
        else
        {
            switchFavorite.setOn(false,animated: true)
        }
        
        imageView.accessibilityLabel = photo.title
        
        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
            }
        
        // code added for view count
        photo.viewCount += 1
        
        store.saveContextIfNeeded()
        
        //testing for saving favorited status
        print("This image's favorite status is: \(photo.favorite)")
        
        let label = UILabel()
        if (photo.viewCount == 1)
        {
            label.text = "\(photo.viewCount) view"
        }
        else
        {
           label.text = "\(photo.viewCount) views"
        }
        
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -12).isActive = true
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags"?:
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
}
