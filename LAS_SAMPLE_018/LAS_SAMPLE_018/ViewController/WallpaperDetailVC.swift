//
//  WallpaperDetailVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 27/09/2023.
//

import UIKit

class WallpaperDetailVC: UIViewController {
    
    var wallpaperUrl: URL?
    
    @IBOutlet weak var wallpaperImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wallpaperImage.sd_setImage(with: URL(string: wallpaperUrl?.absoluteString ?? "" ), completed: { (image, error, type, url) in
            self.wallpaperImage.image = image
            
        })
    }
    
    
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveImageClick(_ sender: Any) {
        guard let selectedImage = wallpaperImage.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(self.finishWriteImage), nil)

    }
    
    @objc private func finishWriteImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            self.view.displayToast("Save photo error!")
        } else {
            self.view.displayToast("Save photo success!")
        }
    }
}
