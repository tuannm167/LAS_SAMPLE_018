//
//  AlbumCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 01/08/2023.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var viewAlbum: UIView!
    @IBOutlet weak var avatarAlbum: UIImageView!
    @IBOutlet weak var lbNameAlbums: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarAlbum.layer.cornerRadius = 20
        viewAlbum.layer.cornerRadius = 20
      //  viewAlbum.backgroundColor = UIColor(rgb: 0xF3F8FF)
    }
    
    var nameAlbums: String?  {
        didSet {
            if nameAlbums != nil {
                guard let albums = MusicService().getItem(songId: nameAlbums!) else { return }
                lbNameAlbums.text = albums.albumTitle
                avatarAlbum.image = albums.getThumb
            }
        }
    }
    
    var data: Any? {
        didSet {
            if let album = data as? AlbumModel {
                lbNameAlbums.text = album.albumTitle
                avatarAlbum.image = album.getThumb
                
            }
        }
    }
    
}
