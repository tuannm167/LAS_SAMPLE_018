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

class PlayMusicVC: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var imageShuffle: UIImageView!
    @IBOutlet weak var repeatImg: UIImageView!
    @IBOutlet weak var imagePlayMusic: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var tableViewSongs: UITableView!
    var playlist: [String] = []
    fileprivate var currentItem: String!
    fileprivate var isShowing: Bool = false
    fileprivate var isSeeking: Bool = false
    var musicService: MusicService = MusicService()
    var time: [String] = []
    var isPlay: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowing = true
        setupUI()
        CPlayer.shared.delegate = self
        if currentItem != nil {
            CPlayer.shared.setPlaylist(playlist, currentItem: currentItem)
        }
        time = musicService.getTimeMusicAll()
        isPlay = true
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isShowing = false
    }
    
    func setupUI() {
        tableViewSongs.register(UINib(nibName: SongMusicPlayCell.cellId, bundle: nil), forCellReuseIdentifier: SongMusicPlayCell.cellId)
        tableViewSongs.delegate = self
        tableViewSongs.dataSource = self
        shuffleButton.isSelected = false
        switch CPlayer.shared.repeatState {
        case .off:
            repeatImg.image = UIImage(named: "ic_repeat")
        case .all:
            repeatImg.image = UIImage(named: "ic_repeat_click")
        }
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
    }
    
    private let documentInteractionController = UIDocumentInteractionController()

        private func showDocumentInteractionController(url: URL) {
           documentInteractionController.url = url
           documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
           documentInteractionController.delegate = self
        }
    
    @IBAction func shareBtnAction(_ sender: UIBarButtonItem) {
        showDocumentInteractionController(url: CPlayer.shared.getUrl())
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        isShowing = false
        dismiss(animated: true)
    }

    @IBAction func btnRepeatAction(_ sender: UIButton) {
        switch CPlayer.shared.repeatState {
        case .off:
            CPlayer.shared.repeatState = .all
            repeatImg.image = UIImage(named: "ic_repeat_click")
        case .all:
            CPlayer.shared.repeatState = .off
            repeatImg.image = UIImage(named: "ic_repeat")
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
            var newPlaylist = self.playlist
            newPlaylist.shuffle()
            if let index = newPlaylist.firstIndex(where: { $0 == currentItem }) {
                newPlaylist.swapAt(0, index)
            }
            imageShuffle.image = UIImage(named: "ic_shuffle_click")
            CPlayer.shared.setPlaylistShuffle(newPlaylist)
        }
        else {
            imageShuffle.image = UIImage(named: "ic_shuffle")
            CPlayer.shared.setPlaylistShuffle(self.playlist)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if sender.isSelected {
            isPlay = false
            CPlayer.shared.pause()
            imagePlayMusic.image = UIImage(named: "ic_pause_music")
            sender.isSelected = false
            tableViewSongs.reloadData()
        } else {
            isPlay = true
            CPlayer.shared.play()
            imagePlayMusic.image = UIImage(named: "ic_play_musics")
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
    }
    
    func readyToPlay(currentItem: String?) {
        seekSlider.value = 0
        seekSlider.minimumValue = 0
        seekSlider.maximumValue = Float(CPlayer.shared.duration())
        tableViewSongs.reloadData()
    }
    
    func onConfigAVPlayerTrigger(layer: AVPlayerLayer?, currentItem: String?) {
        
    }
    
    func onTimeObserverTrigger(currentTime: Float64, duration: Float64) {
        if CPlayer.shared.appRunningBackground {
            return
        }
        btnPlay.isSelected = CPlayer.shared.isPlaying()
        
        if !isSeeking {
            seekSlider.value = Float(currentTime)
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
extension URL {
    var uti: String {
        return (try? self.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier ?? "public.data"
    }

}
