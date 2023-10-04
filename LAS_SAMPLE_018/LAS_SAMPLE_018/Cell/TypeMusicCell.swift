//
//  TypeMusicCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 25/07/2023.
//

import UIKit

protocol TypeMusicCellDelegate: AnyObject {
    func typeMusicAction(number: Int)
}

class TypeMusicCell: UITableViewCell {

    @IBOutlet weak var icAllSong: UIImageView!
    @IBOutlet weak var icAlbum: UIImageView!
    @IBOutlet weak var icPlaylist: UIImageView!
    @IBOutlet weak var viewTypeMusic: UIView!
    weak var delegate: TypeMusicCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewTypeMusic.clipsToBounds = true
        viewTypeMusic.layer.cornerRadius = 25
        viewTypeMusic.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        icPlaylist.isHidden = false
        icAlbum.isHidden = true
        icAllSong.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnPlaylist(_ sender: UIButton) {
        self.delegate?.typeMusicAction(number: 0)
        icPlaylist.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = false
        icAlbum.isHidden = true
        icAllSong.isHidden = true
    }
    @IBAction func btnAlbum(_ sender: UIButton) {
        self.delegate?.typeMusicAction(number: 1)
        icAlbum.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = true
        icAlbum.isHidden = false
        icAllSong.isHidden = true
    }
    @IBAction func btnAllMusic(_ sender: UIButton) {
        self.delegate?.typeMusicAction(number: 2)
        icAllSong.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = true
        icAlbum.isHidden = true
        icAllSong.isHidden = false
    }
    
}
enum MusicCate: Int, CaseIterable {
    case cate1 = 0
    case cate2 = 1
    case cate3 = 2
}
