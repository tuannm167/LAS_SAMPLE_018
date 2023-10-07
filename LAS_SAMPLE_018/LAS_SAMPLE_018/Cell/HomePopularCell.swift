//
//  HomePopularCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 19/07/2023.
//

import UIKit

class HomePopularCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var musicService: MusicService = MusicService()
    var artist: [String] = []
    var source: [AlbumModel] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
            
        }
    }
    var selectItem: ((_ item: AlbumModel) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        //artist = musicService.getAllArtist()
    }
    
    
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PopularCell.cellId, bundle: nil), forCellWithReuseIdentifier: PopularCell.cellId)
        collectionView.register(UINib(nibName: ArtistCell.cellId, bundle: nil), forCellWithReuseIdentifier: ArtistCell.cellId)
        collectionView.register(UINib(nibName: NoDataCell.cellId, bundle: nil), forCellWithReuseIdentifier: NoDataCell.cellId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension HomePopularCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if source.count == 0 {
                return 1
            } else {
                return source.count
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCell.cellId, for: indexPath) as! PopularCell
            return cell
        } else {
            if source.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCell.cellId, for: indexPath) as! NoDataCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.cellId, for: indexPath) as! ArtistCell
                cell.data = source[indexPath.row]
                return cell
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            if source.count > 0 {
                selectItem?(source[indexPath.row])
            }
            
        }
        
    }
}
extension HomePopularCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 150, height: 130)
        } else {
            if source.count == 0 {
                return CGSize(width: UIScreen.main.bounds.width - 170, height: 130)
            } else {
                return CGSize(width: 85, height: 130)
            }
            
        }
        
    }
}
