//
//  MiniPlayer.swift
//  TaunporPlayer
//
//  Created by HongNT on 12/02/2023.
//

import UIKit
import AVFoundation

class MiniPlayer: UIView {
    
    // MARK: - properties
    static let height: CGFloat = 82
    
    var onOpenMainPlayer: (() -> Void)?
    var musicId: String?  {
        didSet {
            if musicId != nil {
                guard let song = MusicService().getItem(songId: musicId!) else { return }
                nameLabel.text = song.songTitle
                artistLabel.text = song.artistName
                thumbnailImage.image = song.getThumb
            } else {
                nameLabel.text = ""
                artistLabel.text = ""
                thumbnailImage.image = UIImage(named: "")
            }
        }
    }
    
    // MARK: - outlets
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var minimumSlideView: UIView!
    @IBOutlet weak var maximumSlideView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - initial
    static func loadFromNib() -> MiniPlayer {
        let nib = UINib(nibName: "MiniPlayer", bundle: nil)
        let view = nib.instantiate(withOwner: self)[0] as! MiniPlayer
        return view
    }
    
    // MARK: - private
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.backgroundColor = .black
        bgView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        thumbnailImage.image = UIImage(named: "")
        nameLabel.text = ""
        artistLabel.text = ""
        
        minimumSlideView.frame = .zero
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideMainPlayer),
                                               name: .hide_main_player,
                                               object: nil)
    }
    
    // MARK: - public
    func setProgressBar(_ progress: CGFloat) {
        let height: CGFloat = maximumSlideView.frame.size.height
        let widthMax: CGFloat = maximumSlideView.frame.size.width
        
        minimumSlideView.frame = CGRect(x: 0, y: 0, width: progress * widthMax, height: height)
    }
    
    @IBAction func playClicked(_ sender: UIButton) {
        if CPlayer.shared.isEmpty() { return }
        if CPlayer.shared.isPlaying() {
            CPlayer.shared.pause()
            sender.isSelected = false
        }
        else {
            CPlayer.shared.play()
            sender.isSelected = true
        }
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        onOpenMainPlayer?()
    }
    
    @objc
    func hideMainPlayer() {
        guard let item = CPlayer.shared.currentItem else { return }
        guard let playerLayer = CPlayer.shared.playerLayer else { return }
        
        playerLayer.removeFromSuperlayer()
        
        guard let song = MusicService().getItem(songId: item) else { return }
        
        if song.songType == .audio {
            thumbnailImage.isHidden = false
        }
        else {
            thumbnailImage.isHidden = true
        }
        
        playerContainerView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0,
                                   width: playerContainerView.bounds.size.width,
                                   height: playerContainerView.bounds.height)
        
    }
    
   
    
}
