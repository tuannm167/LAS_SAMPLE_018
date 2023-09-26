//
//  AudioItemCell.swift
//  Wamthub
//
//  Created by Ben on 20/06/2023.
//

import UIKit
import MediaPlayer

protocol AudioItemCellDelegate: NSObject {
    func addOrRemove(_ audio: String)
    func isExists(_ audio: String) -> Bool
}



class AudioItemCell: UITableViewCell {
    
    weak var delegate: AudioItemCellDelegate?
    
    var musicId: String!  {
        didSet {
            guard let song = MusicService().getItem(songId: musicId!) else { return }
            audioLabel.text = song.songTitle
            durationLabel.text = song.duration
        }
    }
    
    
    
    var isEdit: Bool = false {
        didSet {
            checkButton.isHidden = !isEdit
        }
    }
    
    var onDelete:((_ audio: String)->Void)?
    
    //
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var audioLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.backgroundColor = UIColor(rgb: 0xE0EDFF)
        posterImage.layer.cornerRadius = posterImage.bounds.height/2
        durationLabel.textColor = UIColor(rgb: 0x9B9B9B)
        
        
        // bottomView.roundBottomRight(radius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        onDelete?(musicId)
    }
    
    @IBAction func checkAction(_ sender: Any) {
        delegate?.addOrRemove(musicId)
        checkButton.isSelected = delegate?.isExists(musicId) ?? false
    }

    
}
