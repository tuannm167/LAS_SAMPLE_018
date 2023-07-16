//
//  HomeVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import MediaPlayer

class HomeVC: UIViewController {
    //MARK: - properties
    var albums: [AlbumModel] = []
    var artists: [AlbumModel] = []
    var playlists:[AlbumModel] = []
    var musicService: MusicService = MusicService()
    var musics: [String] = []
    
    //MARK: - outlets
    @IBOutlet weak var homeTableView: UITableView!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //MARK: - private
    private func setupUI() {
        homeTableView.register(UINib(nibName: HomeItemCell.cellId, bundle: nil), forCellReuseIdentifier: HomeItemCell.cellId)
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    
    private func loadData() {
        //load music local
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.musicService.getAlbum(songCategory: .album)
                self.artists = self.musicService.getAlbum(songCategory: .artist)
                self.playlists = self.musicService.getAlbum(songCategory: .playlist)
                self.musics = self.musicService.getAllMusic()
                DispatchQueue.main.async {
                    print("albums: \(self.albums.count)")
                    print("artists: \(self.artists.count)")
                    print("playlists: \(self.playlists.count)")
                    print("musics: \(self.musics.count)")
                    self.homeTableView.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }))
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeItemCell.cellId) as! HomeItemCell
        cell.musicId = musics[indexPath.row]
        return cell
    }
    
    
}
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeItemCell.height
    }
}
