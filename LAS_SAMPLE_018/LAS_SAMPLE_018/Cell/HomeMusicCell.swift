//
//  HomeMusicCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 26/07/2023.
//

import UIKit
import MediaPlayer

class HomeMusicCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categorySelected: HomeCategoryType = .album {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var cellColors = ["RGBB5BAFA","RGB6E79F4","RGBBFE8FD","RGBC3FDBD"]
    var cellColors1 = ["RGBC3FDBD","RGBB5BAFA","RGB6E79F4","RGBBFE8FD"]
    
    var playlists: [AlbumModel] = []
    
    var sourceAlbum: [AlbumModel] = []
    
    var sourceSongs: [String] = []
    
    var selectItem: ((_ item: AlbumModel) -> Void)?
    var selectItemSong:((_ songID: String)->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor(rgb: 0xF3F8FF)
        setupUI()
    }
    
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MusicPlaylistCell.cellId, bundle: nil), forCellWithReuseIdentifier: MusicPlaylistCell.cellId)
        collectionView.register(UINib(nibName: AlbumCell.cellId, bundle: nil), forCellWithReuseIdentifier: AlbumCell.cellId)
        collectionView.register(UINib(nibName: MusicCollectionCell.cellId, bundle: nil), forCellWithReuseIdentifier: MusicCollectionCell.cellId)
        collectionView.register(UINib(nibName: NoDataCell.cellId, bundle: nil), forCellWithReuseIdentifier: NoDataCell.cellId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func addSongToFavourite (musicID: String) {
        guard let realm = RealmService.shared.realmObj() else { return }
        guard let favouriteFolder = RealmService.shared.favouriteFolder() else { return }
        if let index = favouriteFolder.musicIDs.firstIndex(where: { $0 == musicID }) {
            try? realm.write({
                favouriteFolder.musicIDs.remove(at: index)
            })
        }
        else {
            try? realm.write({
                favouriteFolder.musicIDs.append(musicID)
            })
        }
        
    }
    
}
extension HomeMusicCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch categorySelected {
            
        case .playlist:
            if playlists.count == 0 {
                return 1
            } else {
                return playlists.count
            }
        case .album:
            if sourceAlbum.count == 0 {
                return 1
            } else {
                return sourceAlbum.count
            }
        case .allSong:
            if sourceSongs.count == 0 {
                return 1
            } else {
                return sourceSongs.count
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch categorySelected {
            
        case .playlist:
            if playlists.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCell.cellId, for: indexPath) as! NoDataCell
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicPlaylistCell.cellId, for: indexPath) as! MusicPlaylistCell
                cell.viewStyleBorder.backgroundColor = UIColor(named: cellColors[indexPath.row % cellColors.count])
                if playlists.count < 5 {
                    cell.viewBackground.backgroundColor = UIColor(named: cellColors[indexPath.row % cellColors.count])
                } else {
                    if indexPath.row == 0 {
                        cell.viewBackground.backgroundColor = .clear
                    } else {
                        cell.viewBackground.backgroundColor = UIColor(named: cellColors1[indexPath.row % cellColors.count])
                    }
                }
                cell.viewCenter.backgroundColor = .clear
                cell.data = playlists[indexPath.row]
                cell.btnFavourite.isHidden = true
                cell.viewFavourite.isHidden = true
                return cell
            }
        case .album:
            if sourceAlbum.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCell.cellId, for: indexPath) as! NoDataCell
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
                cell.data = sourceAlbum[indexPath.row]
                return cell
            }
        case .allSong:
            if sourceSongs.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCell.cellId, for: indexPath) as! NoDataCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionCell", for: indexPath) as! MusicCollectionCell
                cell.songID = sourceSongs[indexPath.row]
                cell.onFavourite = {[weak self] musicID in
                    self?.addSongToFavourite(musicID: musicID)
                }
                return cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch categorySelected {
            
        case .playlist:
            if playlists.count > 0 {
                selectItem?(playlists[indexPath.row])
            }
        case .album:
            if sourceAlbum.count > 0 {
                selectItem?(sourceAlbum[indexPath.row])
            }
        case .allSong:
            if sourceSongs.count > 0 {
                selectItemSong?(sourceSongs[indexPath.row])
            }
        }
        
    }
}
extension HomeMusicCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch categorySelected {
            
        case .playlist:
            return 0
        case .album:
            return 20
        case .allSong:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch categorySelected {
        case .playlist:
            return 0
        case .album:
            return 20
        case .allSong:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch categorySelected {
        case .playlist:
            if playlists.count == 0 {
                return CGSize(width: collectionView.frame.size.width - 60 , height: 215)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: 100)
            }
        case .album:
            if sourceAlbum.count == 0 {
                let width = collectionView.frame.size.width - 60
                return CGSize(width: width, height: 215)
            } else {
                let width = (collectionView.frame.size.width - 60) / 2
                return CGSize(width: width, height: 215)
            }
        case .allSong:
            if sourceSongs.count == 0 {
                return CGSize(width: collectionView.frame.size.width - 60 , height: 215)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: 100)
            }
        }
        
    }
}
