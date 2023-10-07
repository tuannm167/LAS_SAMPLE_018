//
//  NoDataCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 06/10/2023.
//

import UIKit

class NoDataCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10
    }

}
