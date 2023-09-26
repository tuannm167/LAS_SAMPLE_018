//
//  WallpaperItemCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 26/09/2023.
//

import UIKit

class WallpaperItemCell: UICollectionViewCell {
    
    var imageUrl: URL? {
        didSet {
           //    posterImage.sd_setImage(with: imageUrl, placeholderImage: .original("image_thumb"), options: .retryFailed, context: nil)
            
            posterImage.sd_setImage(with: URL(string: imageUrl?.absoluteString ?? "" ), completed: { (image, error, type, url) in
                self.posterImage.image = image
                    
                 })
        }
    }
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 10
    }

}
