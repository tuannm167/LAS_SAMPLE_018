//
//  AudioCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 20/09/2023.
//

import UIKit

class AudioCell: UITableViewCell {
    
    var onDelete: ((_ musicId: String)-> Void)?
    
    var musicId: String!  {
        didSet {
                guard let song = MusicService().getItem(songId: musicId) else { return }
                titleLabel.text = song.songTitle
                durationLabel.text = song.duration
                posterImage.image = song.getThumb
        }
    }

    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        audioView.backgroundColor = UIColor(rgb: 0xE0EDFF)
        posterImage.layer.cornerRadius = posterImage.bounds.height/2
        durationLabel.textColor = UIColor(rgb: 0x9B9B9B)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        onDelete?(musicId)
    }
}
