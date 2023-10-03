//
//  AllSongsVC.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 05/08/2023.
//

import UIKit
import AVFoundation

enum AllSongType: Int {
    case all = 0
    case favourite = 1
}


class AllSongsVC: BaseVC {
    
    var folderType: AllSongType = .all
    
    var album: AlbumModel? {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
            
        }
    }
    
    var favouriteFolder: RealmModel?
    
    var musicService: MusicService = MusicService()
    var musicIDs: [String] = []
    @IBOutlet weak var titleSongs: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var tableView: UITableView!
    var time: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButton.layer.cornerRadius = 25
        
        setupUI()
        time = musicService.getTimeMusicAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        switch folderType {
        case .all:
            musicIDs = album?.songIDs ?? []
        case .favourite:
            let favouriteFolder = RealmService.shared.favouriteFolder()
            musicIDs = Array(favouriteFolder!.musicIDs)
        }
        tableView.reloadData()
    }
    
    func setupUI() {
        titleSongs.text = album?.albumTitle
        tableView.register(UINib(nibName: MusicCell.cellId, bundle: nil), forCellReuseIdentifier: MusicCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func btnPlayAllAction(_ sender: UIButton) {
        if musicIDs.count > 0 {
            AppDelegate.shared.mainPlayer.setPlaylist(self.musicIDs, currentItem: musicIDs[0])
            UIWindow.keyWindow?.navigationTopMost?.present(AppDelegate.shared.mainPlayer, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension AllSongsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.cellId) as! MusicCell
        cell.selectionStyle = .none
        cell.songID = musicIDs[indexPath.row]
        cell.onFavourite = {[weak self] musicID in
            self?.addSongToFavourite(musicID: musicID)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.dataSource != nil {
            AppDelegate.shared.mainPlayer.setPlaylist(musicIDs, currentItem: musicIDs[indexPath.row])
            UIWindow.keyWindow?.navigationTopMost?.present(AppDelegate.shared.mainPlayer, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

