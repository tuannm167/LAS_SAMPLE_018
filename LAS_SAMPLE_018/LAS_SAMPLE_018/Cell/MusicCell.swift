//
//  MusicCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 26/07/2023.
//

import UIKit

class MusicCell: UITableViewCell {
    
    var onFavourite: ((_ songId: String) -> Void)?

    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var timeOfSong: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var avatarSong: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarSong.layer.cornerRadius = avatarSong.frame.height/2
        viewCenter.backgroundColor = UIColor(named: "RGBE2ECFE")
        timeOfSong.textColor = UIColor(rgb: 0x9B9B9B)
        
        guard let songID = songID else { return }
        isSelectFavourite = self.checkFavourite(songID: songID)
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
                isSelectFavourite = self.checkFavourite(songID: songID!)
            }
        }
    }
    
    @IBAction func favouriteClick(_ sender: Any) {
        guard let songID = songID else { return }
        addSongToF(songID: songID)
    }
    
    var isSelectFavourite: Bool = false {
        didSet {
            if isSelectFavourite {
                favouriteButton.setImage(UIImage(named: "ic_favourite_black"), for: .normal)
            }
            else  {
                favouriteButton.setImage(UIImage(named: "ico_heart"), for: .normal)
            }
        }
    }
    
    private func addSongToF (songID: String) {
        guard let realm = RealmService.shared.realmObj() else { return }
        
        
        guard let favouriteFolder = RealmService.shared.favouriteFolder() else { return }
        
        
        if let index = favouriteFolder.musicIDs.firstIndex(where: { $0 == songID }) {
            try? realm.write({
                favouriteFolder.musicIDs.remove(at: index)
            })
        }
        else {
            try? realm.write({
                favouriteFolder.musicIDs.append(songID)
            })
        }
        
        isSelectFavourite = favouriteFolder.musicIDs.contains(where: { $0 == songID })
    }
    
    
    private func checkFavourite (songID: String) -> Bool{
        guard let favouriteFolder = RealmService.shared.favouriteFolder() else { return false}
        
        if  favouriteFolder.musicIDs.contains(where: { $0 == songID }){
            return true
        }
        else {
            return false
        }
    }
    
}
