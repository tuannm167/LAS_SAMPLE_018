//
//  PlayMusicVC.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 06/08/2023.
//

import UIKit
import AVFAudio
import AVFoundation
import MediaPlayer

class PlayMusicVC: UIViewController {
    
    //MARK: - properties
    var playlist: [String] = []
    fileprivate var currentItem: String!
    
    fileprivate var isShowing: Bool = false
    fileprivate var isSeeking: Bool = false
    
    
    var musicService: MusicService = MusicService()
    var time: [String] = []
    var isPlay: Bool = false

    //MARK: - outlets

    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeartButton: UIButton!
    
    @IBOutlet weak var tableViewSongs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowing = true
        isPlay = true
        
        setupUI()
        
        setupObservers()
        
        CPlayer.shared.setupRemoteTransportControls()
        CPlayer.shared.delegate = self
        
        if currentItem != nil {
            CPlayer.shared.setPlaylist(playlist, currentItem: currentItem)
            UIWindow.keyWindow?.tabbar?.showMiniPlayerIfNeed()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewSongs.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isShowing = true
        self.onConfigAVPlayerTrigger(layer: CPlayer.shared.playerLayer, currentItem: CPlayer.shared.currentItem)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for ly in playerView.layer.sublayers ?? [] {
            if let avlayer = ly as? AVPlayerLayer {
                avlayer.frame = CGRect(x: 0, y: 0,
                                       width: playerView.bounds.size.width,
                                       height: playerView.bounds.height)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isShowing = false
    }
    
    func setupUI() {
        defaultImageView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        playerView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        nameSong.text = ""
        nameArtist.text = ""
        
        switch CPlayer.shared.repeatState {
        case .off:
            repeartButton.setImage(UIImage(named: "ic_repeat"), for: .normal)
        case .all:
            repeartButton.setImage(UIImage(named: "ic_repeat_click"), for: .normal)
        }
        
        shuffleButton.isSelected = false
        
        let thumbImage = UIImage(named: "ic_slider")
        seekSlider.minimumTrackTintColor = UIColor(rgb: 0x8B5CE6)
        seekSlider.maximumTrackTintColor = UIColor(rgb: 0xD8D8D8)
        seekSlider.thumbTintColor = UIColor(rgb: 0x8B5CE6)
        seekSlider.setThumbImage(thumbImage, for: .normal)
        seekSlider.setThumbImage(thumbImage, for: .highlighted)
        seekSlider.addTarget(self, action: #selector(playheadChanged(with:)), for: .valueChanged)
        seekSlider.addTarget(self, action: #selector(seekingEnd), for: .touchUpInside)
        seekSlider.addTarget(self, action: #selector(seekingEnd), for: .touchUpOutside)
        seekSlider.addTarget(self, action: #selector(seekingStart), for: .touchDown)
        
        
        tableViewSongs.register(UINib(nibName: SongMusicPlayCell.cellId, bundle: nil), forCellReuseIdentifier: SongMusicPlayCell.cellId)
        tableViewSongs.delegate = self
        tableViewSongs.dataSource = self

    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: .show_main_player, object: nil, queue: .main) { _ in
            self.isShowing = true
            self.onConfigAVPlayerTrigger(layer: CPlayer.shared.playerLayer, currentItem: CPlayer.shared.currentItem)
            
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIBarButtonItem) {
       
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        isShowing = false
        dismiss(animated: true)
        NotificationCenter.default.post(name: .hide_main_player, object: nil)
    }

    @IBAction func btnRepeatAction(_ sender: UIButton) {
        switch CPlayer.shared.repeatState {
        case .off:
            CPlayer.shared.repeatState = .all
            repeartButton.setImage(UIImage(named: "ic_repeat_click"), for: .normal)
        case .all:
            CPlayer.shared.repeatState = .off
            repeartButton.setImage(UIImage(named: "ic_repeat"), for: .normal)
        }
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        CPlayer.shared.playNext()
    }
    @IBAction func previousBtnAction(_ sender: Any) {
        CPlayer.shared.playPrevious()
    }
    
    func setPlaylist(_ playlist: [String], currentItem: String) {
        if isViewLoaded {
            self.playlist = playlist
            
            var newPlaylist = self.playlist
            if shuffleButton.isSelected {
                newPlaylist.shuffle()
                if let index = newPlaylist.firstIndex(where: { $0 == currentItem }) {
                    newPlaylist.swapAt(0, index)
                }
            }
            CPlayer.shared.setPlaylist(newPlaylist, currentItem: currentItem)
        }
        else {
            self.playlist = playlist
            self.currentItem = currentItem
        }
    }
    
    @IBAction func seekingStart(sender: Any? = nil) {
        isSeeking = true
    }
    
    @IBAction func seekingEnd(sender: Any? = nil) {
        isSeeking = false
    }
    
    @IBAction open func playheadChanged(with sender: UISlider) {
        isSeeking = true
        CPlayer.shared.seekToTime(seconds: Float64(sender.value))
        tableViewSongs.reloadData()
    }
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        shuffleButton.isSelected = !shuffleButton.isSelected
        if shuffleButton.isSelected {
            self.playlist.shuffle()
            if let index = playlist.firstIndex(where: { $0 == currentItem }) {
                playlist.swapAt(0, index)
            }
            CPlayer.shared.setPlaylistShuffle(playlist)
        }
        else {
            CPlayer.shared.setPlaylistShuffle(self.playlist)
        }
        tableViewSongs.reloadData()
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if sender.isSelected {
            isPlay = false
            CPlayer.shared.pause()
            sender.isSelected = false
            tableViewSongs.reloadData()
        } else {
            isPlay = true
            CPlayer.shared.play()
            sender.isSelected = true
            tableViewSongs.reloadData()
        }
    }
    
}


extension PlayMusicVC: CPlayerDelegate {
    private func fillDataToView(_ songID: String) {
        guard let song = MusicService().getItem(songId: songID) else { return }
        
        nameSong.text = song.songTitle
        nameArtist.text = song.artistName
        
        btnNext.isEnabled = CPlayer.shared.canNext()
        btnPrevious.isEnabled = CPlayer.shared.canPrevious()
        
    }
    
    func preparePlay(currentItem: String?) {
        guard let item = currentItem else { return }
        self.currentItem = item
        self.fillDataToView(item)
        
        // mini player
        if let tabbar = UIWindow.keyWindow?.tabbar {
            tabbar.miniPlayer.musicId = item
            tabbar.miniPlayer.setProgressBar(0)
        }
    }
    
    func readyToPlay(currentItem: String?) {
        seekSlider.value = 0
        seekSlider.minimumValue = 0
        seekSlider.maximumValue = Float(CPlayer.shared.duration())
        tableViewSongs.reloadData()
    }
    
    func onConfigAVPlayerTrigger(layer: AVPlayerLayer?, currentItem: String?) {
        if CPlayer.shared.appRunningBackground {
            return
        }
        
        // handle mini player is showing
        if !self.isShowing {
            if let tabbar = UIWindow.keyWindow?.tabbar {
                tabbar.miniPlayer.hideMainPlayer()
            }
            return
        }
        
        guard let playerLayer = layer else { return }
        guard let item = currentItem else { return }
        
        guard let song = MusicService().getItem(songId: item) else { return }
        
        if song.songType == .audio {
            playerView.backgroundColor = UIColor(rgb: 0x181818)
            defaultImageView.isHidden = false
        }
        else {
            playerView.backgroundColor = .clear
            defaultImageView.isHidden = true
        }
        
        playerLayer.removeFromSuperlayer()
        playerView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0,
                                   width: playerView.bounds.size.width,
                                   height: playerView.bounds.height)
        
    }
    
    func onTimeObserverTrigger(currentTime: Float64, duration: Float64) {
        if CPlayer.shared.appRunningBackground {
            return
        }
        
        // main player
        btnPlay.isSelected = CPlayer.shared.isPlaying()
        
        if !isSeeking {
            seekSlider.value = Float(currentTime)
        }
        
        // mini player
        if let tabbar = UIWindow.keyWindow?.tabbar {
            tabbar.miniPlayer.playButton.isSelected = CPlayer.shared.isPlaying()
            tabbar.miniPlayer.setProgressBar(CGFloat(currentTime / duration))
        }
    }
    
    func onLoadedTimeRangedChanged(bufferTimeValue: Float) {
        
    }
}
extension PlayMusicVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CPlayer.shared.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongMusicPlayCell.cellId) as! SongMusicPlayCell
        cell.songID = playlist[indexPath.row]
        if cell.nameOfSong.text == nameSong.text && isPlay {
            cell.viewPlay.isHidden = false
        } else {
            cell.viewPlay.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CPlayer.shared.setPlaylist(self.playlist, currentItem: CPlayer.shared.playlist[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
