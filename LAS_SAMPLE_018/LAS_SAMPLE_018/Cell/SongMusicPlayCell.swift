//
//  SongMusicPlayCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 14/08/2023.
//

import UIKit

class SongMusicPlayCell: UITableViewCell {
    @IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var timeOfSong: UILabel!
    @IBOutlet weak var nameOfSong: UILabel!
    @IBOutlet weak var avatarSongs: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarSongs.layer.cornerRadius = avatarSongs.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var songID: String? {
        didSet {
            if songID != nil {
                guard let song = MusicService().getItem(songId: songID!) else { return }
                avatarSongs.image = song.getThumb
                nameOfSong.text = song.songTitle
                timeOfSong.text = song.time
            }
        }
    }
}
