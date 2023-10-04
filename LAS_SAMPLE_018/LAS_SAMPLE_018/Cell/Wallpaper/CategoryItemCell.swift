//
//  CategoryItemCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 26/09/2023.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {
    
    var categoryType: CategoryType = .animal {
        didSet {
            titleLabel.text = categoryType.title()
        }
    }
    
    var isItemSelected: Bool = false {
        didSet {
            if isItemSelected {
                choosedImage.isHidden = false
                titleLabel.textColor = UIColor.black
            } else {
                choosedImage.isHidden = true
                titleLabel.textColor = UIColor.black.withAlphaComponent(0.4)
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var choosedImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choosedImage.isHidden = true
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.4)
    }

}
