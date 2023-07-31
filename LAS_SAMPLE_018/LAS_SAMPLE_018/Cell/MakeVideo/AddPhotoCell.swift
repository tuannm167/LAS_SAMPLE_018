//
//  AddPhotoCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    var onAddPhoto:(()-> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
    }

    @IBAction func addPhotoClick(_ sender: Any) {
        onAddPhoto?()
    }
}
