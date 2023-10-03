//
//  BaseVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit

class BaseVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
extension BaseVC {
    func openAllSong(album: AlbumModel){
        let allSongVC: AllSongsVC = UIStoryboard.createController()
        allSongVC.album = album
        self.navigationController?.pushViewController(allSongVC, animated: true)
    }
    
    func openAllSongF(folderType: AllSongType){
        let allSongVC: AllSongsVC = UIStoryboard.createController()
        allSongVC.folderType = folderType
        self.navigationController?.pushViewController(allSongVC, animated: true)
    }
    
    func openPlaySong(){
        let allSongVC = PlayMusicVC()
        //allSongVC.album = album
        self.navigationController?.pushViewController(allSongVC, animated: true)
    }
}
