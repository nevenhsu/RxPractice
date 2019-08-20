//
//  FilterService.swift
//  PhotoFilter
//
//  Created by Neven Hsu on 2019/8/20.
//  Copyright © 2019 Neven Hsu. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage),
           let filter = filter
            {

            filter.setValue(sourceImage, forKey: kCIInputImageKey)

                if let cgImage = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                    let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                        completion(processedImage)
                }
            
        }
    }
    
    
    
}
