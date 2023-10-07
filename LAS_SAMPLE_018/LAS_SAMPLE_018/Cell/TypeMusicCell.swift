//
//  TypeMusicCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 25/07/2023.
//

import UIKit

enum HomeCategoryType: Int {
    case playlist = 1
    case album = 2
    case allSong = 3
}

protocol TypeMusicCellDelegate: AnyObject {
    func homeCategoryType(type: HomeCategoryType)
}

class TypeMusicCell: UITableViewCell {
    //MARK: - properties
    static let height: CGFloat = 65

    //MARK: - outlets
    @IBOutlet weak var icAllSong: UIImageView!
    @IBOutlet weak var icAlbum: UIImageView!
    @IBOutlet weak var icPlaylist: UIImageView!
    @IBOutlet weak var viewTypeMusic: UIView!
    
    weak var delegate: TypeMusicCellDelegate?
    
    //MARK: - life cycle
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
    
    //MARK: - action
    @IBAction func btnPlaylist(_ sender: UIButton) {
        self.delegate?.homeCategoryType(type: .playlist)
        icPlaylist.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = false
        icAlbum.isHidden = true
        icAllSong.isHidden = true
    }
    @IBAction func btnAlbum(_ sender: UIButton) {
        self.delegate?.homeCategoryType(type: .album)
        icAlbum.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = true
        icAlbum.isHidden = false
        icAllSong.isHidden = true
    }
    @IBAction func btnAllMusic(_ sender: UIButton) {
        self.delegate?.homeCategoryType(type: .allSong)
        icAllSong.image = UIImage(named: "ic_arrow_down")
        icPlaylist.isHidden = true
        icAlbum.isHidden = true
        icAllSong.isHidden = false
    }
    
}
