//
//  ViewController.swift
//  PhotoFilter
//
//  Created by Neven Hsu on 2019/8/13.
//  Copyright © 2019 Neven Hsu. All rights reserved.
//

import UIKit
import RxSwift

class PhotoFilterVC: UIViewController {
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
            let photoCVC = navC.viewControllers.first as? PhotoCollectionVC
            else {
                fatalError("Segue desitnation is not found")
        }
        
        photoCVC.selectedPhoto.subscribe(onNext: { [weak self] (image) in
            
            DispatchQueue.main.async {
                self?.updateUI(with: image)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @IBAction func applyFilterButtonPressed() {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage) { (filterImage) in
            DispatchQueue.main.async {
                self.photoImageView.image = filterImage
            }
        }
    }
 
}

