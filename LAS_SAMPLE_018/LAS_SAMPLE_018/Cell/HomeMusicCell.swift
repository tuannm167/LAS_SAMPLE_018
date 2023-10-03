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
    
    var musicService: MusicService = MusicService()
    var isChoose = TypeMusicCell()
    var albumInfo: AlbumModel?
    var albums: [String] = []
    var songs: [String] = []
    var playlist: [String] = []
    var counts: [String] = []
    var times: [String] = []
    var url = ""
    var count = 0
    var cellColors = ["RGBB5BAFA","RGB6E79F4","RGBBFE8FD","RGBC3FDBD"]
    var cellColors1 = ["RGBC3FDBD","RGBB5BAFA","RGB6E79F4","RGBBFE8FD"]
    
    var source: [AlbumModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var sourceAlbum: [AlbumModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var sourceSongs: [String] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var selectItem: ((_ item: AlbumModel) -> Void)?
    var selectItemSong:((_ songID: String)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        counts = musicService.getAllPlaylist()
        times = musicService.getTimeMusicAll()
    }
    
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MusicPlaylistCell.cellId, bundle: nil), forCellWithReuseIdentifier: MusicPlaylistCell.cellId)
        collectionView.register(UINib(nibName: AlbumCell.cellId, bundle: nil), forCellWithReuseIdentifier: AlbumCell.cellId)
        collectionView.register(UINib(nibName: MusicCollectionCell.cellId, bundle: nil), forCellWithReuseIdentifier: MusicCollectionCell.cellId)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if count == 0 {
            return source.count
        } else if count == 1 {
            return sourceAlbum.count
        }
        return sourceSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicPlaylistCell", for: indexPath) as! MusicPlaylistCell
            cell.viewStyleBorder.backgroundColor = UIColor(named: cellColors[indexPath.row % cellColors.count])
            if source.count < 5 {
                cell.viewBackground.backgroundColor = UIColor(named: cellColors[indexPath.row % cellColors.count])
            } else {
                if indexPath.row == 0 {
                    cell.viewBackground.backgroundColor = .clear
                } else {
                    cell.viewBackground.backgroundColor = UIColor(named: cellColors1[indexPath.row % cellColors.count])
                }
            }
            cell.viewCenter.backgroundColor = .clear
            cell.data = source[indexPath.row]
            cell.btnFavourite.isHidden = true
            cell.viewFavourite.isHidden = true
            cell.numberSongs.text = "\(counts[indexPath.row]) Songs"
            return cell
        } else if count == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
            cell.data = sourceAlbum[indexPath.row]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if count == 0 {
            selectItem?(source[indexPath.row])
        } else if count == 1 {
            selectItem?(sourceAlbum[indexPath.row])
        } else {
            selectItemSong?(sourceSongs[indexPath.row])
        }
    }
}
extension HomeMusicCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if count == 0 {
            return 0
        } else if count == 1 {
            return 20
        } else {
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if count == 0 {
            return 0
        } else if count == 1 {
            return 20
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if count == 0 || count == 2 {
            return CGSize(width: collectionView.frame.size.width, height: 100)
        }
        
        let width = (collectionView.frame.size.width - 60) / 2
        return CGSize(width: width, height: 215)
    }
}
