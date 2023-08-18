//
//  PlayerMusic.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 06/08/2023.
//

import UIKit
import AVFoundation
import MediaPlayer

struct Constant {
    static let loadTimeRangedKey = "loadedTimeRanges"
}

protocol CPlayerDelegate: NSObject {
    func preparePlay(currentItem: String?)
    func readyToPlay(currentItem: String?)
    func onConfigAVPlayerTrigger(layer: AVPlayerLayer?, currentItem: String?)
    func onTimeObserverTrigger(currentTime: Float64, duration: Float64)
    func onLoadedTimeRangedChanged(bufferTimeValue: Float)
}

class CPlayer: NSObject {
    
    enum PlaybackState {
        case play
        case pause
        case stop
    }
    
    enum ShuffleOption: Int {
        case off
        case on
    }
    
    enum Repeat: Int {
        case off
        case all
    }
    
    var position: Int = 0
    var playlist: [String] = []
    var currentItem: String? {
        if playlist.count > 0 && position < playlist.count {
            return playlist[position]
        }
        return nil
    }
    var songService: MusicService = MusicService()
    
    var state: PlaybackState = .stop
    
    var repeatState: Repeat {
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "repeat_state")
            UserDefaults.standard.synchronize()
        }
        get {
            return Repeat(rawValue: UserDefaults.standard.integer(forKey: "repeat_state")) ?? .off
        }
    }
    
    weak var delegate: CPlayerDelegate?
    
    static let shared: CPlayer = CPlayer()
    
    // MARK: - properties
    private var _player: AVPlayer?
    private var _playerLayer: AVPlayerLayer?
    var playerLayer: AVPlayerLayer? {
        return _playerLayer
    }
    
    private var _timeObserver: Any?
    private var _appRunningBackground: Bool = false
    var appRunningBackground: Bool {
        return _appRunningBackground
    }
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - observers
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        // fix video auto pause when the app's enter background
//        // https://developer.apple.com/documentation/avfoundation/media_playback/creating_a_basic_video_player_ios_and_tvos/playing_audio_from_a_video_asset_in_the_background
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        //
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        guard let player = _player, let durationCMTimeFormat = player.currentItem?.asset.duration else {
            return
        }
        
        let duration = CMTimeGetSeconds(durationCMTimeFormat)
        
        // time observer
        _timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateInfoCenter()
            self?.delegate?.onTimeObserverTrigger(currentTime: CMTimeGetSeconds(time),
                                                  duration: Double(duration))
        }
        
        // add KVO
        player.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status),
                                        options: .new, context: nil)
        
        player.currentItem?.addObserver(self, forKeyPath: Constant.loadTimeRangedKey,
                                        options: .new, context: nil)
        
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
        
        if let timeObserver = _timeObserver {
            _player?.removeTimeObserver(timeObserver)
            _player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            _player?.currentItem?.removeObserver(self, forKeyPath: Constant.loadTimeRangedKey)
            self._timeObserver = nil
        }
    }
    
    // MARK: - private
    private func prepareToPlay() {
        guard let currentItem = currentItem else { return }
        
        guard let url = songService.getSongURL(songId: currentItem) else { return }
        
        let item = AVPlayerItem(url: url)
        _player = AVPlayer(playerItem: item)
        
        if _player != nil {
            _playerLayer = AVPlayerLayer(player: _player!)
            _playerLayer?.videoGravity = .resizeAspect
        }
        
        addObservers()
        
        delegate?.onConfigAVPlayerTrigger(layer: _playerLayer, currentItem: currentItem)
        delegate?.preparePlay(currentItem: currentItem)
    }
    
    func getUrl() -> URL {
        guard let currentItem = currentItem else { return URL(fileURLWithPath: "")}
        guard let url = songService.getSongURL(songId: currentItem) else { return URL(fileURLWithPath: "")}
        return url
    }
    
    // MARK: - public
    func initSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setPlaylist(_ list: [String], currentItem: String) {
        self.playlist = list
        // update position
        updatePosition(currentItem)
        stop()
        resetAVPlayerLayer()
        
        // prepare play
        prepareToPlay()
        
        updateStateNextOrPreviousCenter()
    }
    
    func setNextPlay(currentItem: String) {
        self.playlist.insert(currentItem, at: self.position + 1)
        delegate?.preparePlay(currentItem: currentItem)
        updateStateNextOrPreviousCenter()
    }
    
    
    func updatePosition(_ songID: String) {
        if let index = self.playlist.firstIndex(of: songID) {
            self.position = index
        }
    }
    
    func setPlaylistShuffle(_ list: [String]) {
        guard let currentItem = currentItem else { return }
        
        self.playlist = list
        
        // update position
        if let index = self.playlist.firstIndex(of: currentItem) {
            self.position = index
        }
    }
    
    func play() {
        if _player == nil {
            prepareToPlay()
            updateStateNextOrPreviousCenter()
            
            return
        }
        
        if isPlaying() == false {
            _player?.play()
        }
    }
    
    func canNext() -> Bool {
        return playlist.count > 0 && position < playlist.count - 1
    }
    
    private func playCurrentItem() {
        
        self.prepareToPlay()
        
        self.updateStateNextOrPreviousCenter()
        
    }
    
    func playNext() {
        if canNext() {
            position += 1
            
            resetAVPlayerLayer()
            stop()
            
            playCurrentItem()
        }
    }
    
    func canPrevious() -> Bool {
        return playlist.count > 0 && position > 0
    }
    
    func playPrevious() {
        if canPrevious() {
            position -= 1
            
            resetAVPlayerLayer()
            stop()
            
            playCurrentItem()
        }
    }
    
    func pause() {
        _player?.pause()
    }
    
    func stop() {
        removeObservers()
        
        _player?.pause()
        _player = nil
    }
    
    func resetAVPlayerLayer() {
        _playerLayer?.player = nil
        _playerLayer?.removeFromSuperlayer()
        _playerLayer = nil
    }
    
    // MARK: - sliding, information music (duration, current time,...)
    func seekToTime(seconds: Float64) {
        let targetTime = CMTimeMakeWithSeconds(seconds, preferredTimescale: Int32(NSEC_PER_SEC))
        _player?.currentItem?.seek(to: targetTime, completionHandler: { success in
            // don't nothing
        })
    }
    
    func currentTime() -> Float64 {
        let currentTime = _player?.currentItem?.currentTime() ?? .zero
        return CMTimeGetSeconds(currentTime)
    }
    
    func duration() -> Float64 {
        let duration = _player?.currentItem?.asset.duration ?? .zero
        return CMTimeGetSeconds(duration)
    }
    
    func isPlaying() -> Bool {
        return (_player?.rate ?? 0) > 0
    }
    
    func isEmpty() -> Bool {
        return playlist.count == 0 || currentItem == nil
    }
    
    // MARK: - remote system control media
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { event in
            self.pause()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.playNext()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.playPrevious()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            guard let avPlayer = self._player else { return .commandFailed }
            guard let eventPosition = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            
            let timeIntervalChanged = CMTime(seconds: eventPosition.positionTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            avPlayer.currentItem?.seek(to: timeIntervalChanged, completionHandler: { success in
                // don't nothing
            })
            
            return .success
        }
    }
    
    func updateStateNextOrPreviousCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = canNext()
        commandCenter.previousTrackCommand.isEnabled = canPrevious()
    }
    
    func updateInfoCenter() {
        guard let avPlayer = _player else { return }
        guard let currentItem = currentItem else { return }
        guard let song = MusicService().getItem(songId: currentItem) else { return }
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.songTitle
        nowPlayingInfo[MPMediaItemPropertyArtist] = song.artistName
        
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] = song.artWork
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime()
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = avPlayer.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // MARK: KVO Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            var status: AVPlayerItem.Status = .unknown
            if let statusNumber = change?[.newKey] as? NSNumber,
               let newStatus = AVPlayerItem.Status(rawValue: statusNumber.intValue) {
                status = newStatus
            }
            switch status {
            case .readyToPlay:
                delegate?.readyToPlay(currentItem: currentItem)
                
                _player?.play()
                
                self.updateInfoCenter()
                
            case .failed:
                if let item = object as? AVPlayerItem, let error = item.error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                    print(error)
                    print(underlyingError)
                }
            default:
                break
            }
        } else if keyPath == Constant.loadTimeRangedKey {
            guard let duration = _player?.currentItem?.duration else { return }
            
            if let ch = change, let timeRanges = ch[.newKey] as? [CMTimeRange], timeRanges.count > 0 {
                let timeRange = timeRanges[0]
                let bufferTimeValue: Float = Float(CMTimeGetSeconds(timeRange.duration) / CMTimeGetSeconds(duration))
                let value = bufferTimeValue > 0.95 ? 1 : bufferTimeValue
                delegate?.onLoadedTimeRangedChanged(bufferTimeValue: value)
            }
        }
    }
    
    // MARK: - events
    @objc func playerDidFinish(_ notification: NSNotification) {
        if notification.object as? AVPlayerItem != _player?.currentItem {
            return
        }
        
        updateStateNextOrPreviousCenter()
        
        switch repeatState {
        case .off:
            // next music if exists
            playNext()
        case .all:
            if playlist.count > 0 && position == playlist.count - 1 {
                position = 0
                
                resetAVPlayerLayer()
                stop()
                
                prepareToPlay()
                
                updateStateNextOrPreviousCenter()
            }
            else {
                // next music if exists
                playNext()
            }
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: Notification) {
        _appRunningBackground = false
        if _player != nil {
            _playerLayer = AVPlayerLayer(player: _player!)
            _playerLayer?.videoGravity = .resizeAspect
            
            delegate?.onConfigAVPlayerTrigger(layer: _playerLayer, currentItem: currentItem)
        }
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        _appRunningBackground = true
        resetAVPlayerLayer()
    }
}
