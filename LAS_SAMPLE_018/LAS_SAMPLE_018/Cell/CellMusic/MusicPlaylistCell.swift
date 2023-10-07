//
//  MusicPlaylistCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 26/07/2023.
//

import UIKit
import MediaPlayer

class MusicPlaylistCell: UICollectionViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewStyleBorder: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var avatarMusic: UIImageView!
    @IBOutlet weak var viewFavourite: UIView!
    @IBOutlet weak var imageFavourite: UIImageView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var numberSongs: UILabel!
    @IBOutlet weak var lbNamePlaylist: UILabel!
    
    var musicIDs: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarMusic.layer.cornerRadius = avatarMusic.frame.height/2
        viewStyleBorder.clipsToBounds = true
        viewStyleBorder.layer.cornerRadius = 25
        viewStyleBorder.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewCenter.backgroundColor = .clear
    }
    
    var data: Any? {
        didSet {
            if let album = data as? AlbumModel {
                lbNamePlaylist.text = album.albumTitle
                avatarMusic.image = album.getThumb
                numberSongs.text = album.songTotalStr
            }
        }
    }
    
    var musicName: String?  {
        didSet {
            if musicName != nil {
                guard let song = MusicService().getItem(songId: musicName!) else { return }
                lbNamePlaylist.text = song.songTitle
                avatarMusic.image = song.getThumb
                isSelectFavourite = self.checkFavourite(songID: musicName!)
            }
        }
    }
    
    var onFavourite:((_ songID: String)-> Void)?
    
    var isSelectFavourite: Bool = false {
        didSet {
            if isSelectFavourite {
                imageFavourite.image = UIImage(named: "ic_favourive")
            }
            else  {
                imageFavourite.image = UIImage(named: "ico_heart")
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
    
    @IBAction func clickBtnFavourtite(_ sender: UIButton) {
        guard let songID = musicName else { return }
        addSongToF(songID: songID)
    }
}
