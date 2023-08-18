//
//  MusicCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 26/07/2023.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var viewFavourite: UIView!
    @IBOutlet weak var timeOfSong: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var avatarSong: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarSong.layer.cornerRadius = avatarSong.frame.height/2
        viewCenter.backgroundColor = UIColor(named: "RGBE2ECFE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var songID: String? {
        didSet {
            if songID != nil {
                guard let song = MusicService().getItem(songId: songID!) else { return }
                avatarSong.image = song.getThumb
                nameSong.text = song.songTitle
                timeOfSong.text = song.time
            }
        }
    }
}
