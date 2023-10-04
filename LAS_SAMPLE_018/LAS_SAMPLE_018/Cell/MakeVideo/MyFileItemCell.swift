//
//  MyFileItemCell.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 21/09/2023.
//

import UIKit
import AVFoundation

class MyFileItemCell: UITableViewCell {
    
    static let height: CGFloat = 120
    
    var titleVideo: String = "" {
        didSet {
            titleLabel.text = titleVideo
            guard let path = URL.videoEditorFolder()?.appendingPathComponent(titleVideo) else {return}
            
            posterImage.image = generateThumbnail(path: path)
            durationLabel.text = videoDuration(path: path)
        }
    }
    
    var onShare:(()->Void)?

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        durationLabel.textColor = UIColor(rgb: 0x9B9B9B)
        posterImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
    }
    
    @IBAction func shareAction(_ sender: Any) {
        onShare?()
    }
    
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func videoDuration(path: URL) -> String {
        let asset = AVAsset(url:path)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        let s: Int = Int(durationTime) % 60
        let m: Int = Int(durationTime) / 60
        let formattedDuration = String(format: "%02d:%02d", m, s)
        return formattedDuration
    }
}
