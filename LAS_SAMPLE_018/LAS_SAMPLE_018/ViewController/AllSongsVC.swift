//
//  AllSongsVC.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 05/08/2023.
//

import UIKit
import AVFoundation

class AllSongsVC: BaseVC {
    
    var album: AlbumModel? {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
            
        }
    }
    
    var realmModel: RealmModel? {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
            
        }
    }
    
    var musicService: MusicService = MusicService()
    var musicIDs: [String] = []
    @IBOutlet weak var titleSongs: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var tableView: UITableView!
    var time: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButton.layer.cornerRadius = 25
        musicIDs = album?.songIDs ?? []
        setupUI()
        time = musicService.getTimeMusicAll()
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
}
extension AllSongsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.cellId) as! MusicCell
        cell.selectionStyle = .none
        cell.songID = musicIDs[indexPath.row]
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

