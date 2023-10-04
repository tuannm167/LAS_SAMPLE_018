//
//  PopularCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 25/07/2023.
//

import UIKit

class PopularCell: UICollectionViewCell {

    @IBOutlet weak var topLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topLabel.textColor = UIColor(rgb: 0x9B9B9B)
    }

}
