//
//  ArtistCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 25/07/2023.
//

import UIKit

class ArtistCell: UICollectionViewCell {

    @IBOutlet weak var avaterArtist: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaterArtist.layer.cornerRadius = 20
    }
    
    var data: Any? {
        didSet {
            if let album = data as? AlbumModel {
                lbName.text = album.albumTitle
                avaterArtist.image = album.getThumb
            }
        }
    }
}
