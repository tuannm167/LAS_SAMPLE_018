//
//  AddAudioCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 20/09/2023.
//

import UIKit

class AddAudioCell: UITableViewCell {
    
    var onAddAudio: (()->Void)?

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addView.backgroundColor = UIColor(rgb: 0xE0EDFF)
        addView.layer.cornerRadius = 10
        posterImage.layer.cornerRadius = posterImage.bounds.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addAudioClick(_ sender: Any) {
        onAddAudio?()
    }
}
