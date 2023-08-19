//
//  PhotoItemCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
    var onDelete:((_ image: UIImage)->Void)?
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var image: UIImage! {
        didSet {
            photoImage.image = image
        }
    }
    @IBAction func deleteAction(_ sender: Any) {
        onDelete?(image)
    }

}
