//
//  PhotoCollectionVC.swift
//  PhotoFilter
//
//  Created by Neven Hsu on 2019/8/13.
//  Copyright © 2019 Neven Hsu. All rights reserved.
//

import UIKit
import Photos
import RxSwift

private let reuseIdentifier = "PhotoCollectionViewCell"

class PhotoCollectionVC: UICollectionViewController {
    
    private var images = [PHAsset]()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhoto()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("No Photo cell")
        }
        
        // Configure the cell
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.photoImage?.image = image
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.images[indexPath.row]
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            
            // guard let info = info, image = image
            
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    private func populatePhoto () {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if (status == .authorized) {
                // access photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects({ (object, index, stop) in
                    self?.images.append(object)
                })
                
                self?.images.reverse()
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            }
        }
        
    }

}
