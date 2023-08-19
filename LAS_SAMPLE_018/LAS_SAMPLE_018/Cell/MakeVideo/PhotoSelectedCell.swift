//
//  PhotoSelectedCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit
import Photos

protocol PhotoSelectedCellDelegate: NSObject {
    func addOrRemove(_ imageItem: UIImage)
    func isExists(_ imageItem: UIImage) -> Bool
}



class PhotoSelectedCell: UICollectionViewCell {
    
    weak var delegate: PhotoSelectedCellDelegate?
    
    private var selectedImage = UIImageView(image: UIImage(named: "image_thumb"))
    
    var isEdit: Bool = false {
        didSet {
            checkButton.isHidden = !isEdit
        }
    }

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var imageAsset: PHAsset! {
        didSet {
            posterImage.image = imageAsset.getImageThumb
            selectedImage.image = imageAsset.getImageThumb
        }
    }
    
    var image: UIImage! {
        didSet {
            posterImage.image = image
            selectedImage.image = image
        }
    }
    

    @IBAction func checkClick(_ sender: Any) {
        delegate?.addOrRemove(selectedImage.image!)
        checkButton.isSelected = delegate?.isExists(selectedImage.image!) ?? false
    }
}
