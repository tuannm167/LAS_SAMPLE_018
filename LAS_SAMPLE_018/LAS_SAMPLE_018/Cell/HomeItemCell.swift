//
//  HomeItemCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit

class HomeItemCell: UITableViewCell {
    static let height: CGFloat = 50
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var musicId: String?  {
        didSet {
            if musicId != nil {
                guard let song = MusicService().getItem(songId: musicId!) else { return }
                titleLabel.text = song.songTitle
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
