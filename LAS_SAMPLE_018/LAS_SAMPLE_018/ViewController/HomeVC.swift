//
//  HomeVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import AVFAudio
import AVFoundation
import MediaPlayer
import KRProgressHUD

class HomeVC: BaseVC {
    
    //MARK: - properties
    var albums: [AlbumModel] = []
    var artists: [AlbumModel] = []
    var playlists:[AlbumModel] = []
    var musicService: MusicService = MusicService()
    var musics: [String] = []
    var musicIDs:[String] = []
    var favouriteFolder: RealmModel?
    
    fileprivate var heightMiniPlayer: CGFloat = 0
    
    var categorySelected: HomeCategoryType = .playlist
    fileprivate var currentItem: String!
    let heightPlaylist = 100
    let heightAlbum = 250
    var data = [HomeSection.HomeTop, HomeSection.HomePopular, HomeSection.HomeTypeMusic,
                HomeSection.HomeCate]
    //MARK: - outlets
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var artistsName: UILabel!
    var name = ""
    var homevc = AllSongsVC()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupObserver()
        loadData()
        
    }
    
    //MARK: - private
    private func setupUI() {
        homeTableView.register(UINib(nibName: HomeItemCell.cellId, bundle: nil), forCellReuseIdentifier: HomeItemCell.cellId)
        homeTableView.register(UINib(nibName: HomeSearchCell.cellId, bundle: nil), forCellReuseIdentifier: HomeSearchCell.cellId)
        homeTableView.register(UINib(nibName: HomePopularCell.cellId, bundle: nil), forCellReuseIdentifier: HomePopularCell.cellId)
        homeTableView.register(UINib(nibName: TypeMusicCell.cellId, bundle: nil), forCellReuseIdentifier: TypeMusicCell.cellId)
        homeTableView.register(UINib(nibName: HomeMusicCell.cellId, bundle: nil), forCellReuseIdentifier: HomeMusicCell.cellId)
        homeTableView.separatorStyle = .none
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: .show_mini_player, object: nil, queue: .main) { notification in
            if let height = notification.object as? CGFloat {
                self.heightMiniPlayer = height
                self.homeTableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .hide_mini_player, object: nil, queue: .main) { _ in
            self.heightMiniPlayer = 0
            self.homeTableView.reloadData()
        }
    }
    
    private func loadData() {
        //load music local
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                DispatchQueue.main.async {
                    KRProgressHUD.show()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    KRProgressHUD.dismiss()
                    self.albums = self.musicService.getAlbum(songCategory: .album)
                    self.artists = self.musicService.getAlbum(songCategory: .artist)
                    self.playlists = self.musicService.getAlbum(songCategory: .playlist)
                    self.musics = self.musicService.getAllMusic()
                    
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
    
    @IBAction func clickShowPlayMusic(_ sender: UIButton) {
        self.present(AppDelegate.shared.mainPlayer, animated: true)
    }
    @IBAction func clickFavourite(_ sender: UIButton) {
        self.openAllSongF(folderType:.favourite)
    }
    
    var musicName: String?  {
        didSet {
            if musicName != nil {
                guard let song = MusicService().getItem(songId: musicName!) else { return }
                
            }
        }
    }
}

extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch data[section] {
        case .HomeTop:
            return 1
        case .HomePopular:
            return 1
        case .HomeTypeMusic:
            return 1
        case .HomeCate:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch data[indexPath.section] {
        case .HomeTop:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchCell.cellId) as! HomeSearchCell
            cell.selectionStyle = .none
            cell.tappedHideKeyboard(view: self.view)
            return cell
        case .HomePopular:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePopularCell.cellId) as! HomePopularCell
            cell.selectionStyle = .none
            cell.source = artists
            cell.selectItem = { album in
                self.openAllSong(album: album)
            }
            return cell
        case .HomeTypeMusic:
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeMusicCell.cellId) as! TypeMusicCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .HomeCate:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeMusicCell.cellId) as! HomeMusicCell
            cell.selectionStyle = .none
            cell.playlists = playlists
            cell.sourceSongs = musics
            cell.sourceAlbum = albums
            cell.categorySelected = categorySelected
            
            cell.selectItem = { album in
                if self.categorySelected == .playlist || self.categorySelected == .album {
                    self.openAllSong(album: album)
                }
            }
            cell.selectItemSong = { songId in
                AppDelegate.shared.mainPlayer.setPlaylist(self.musics, currentItem: songId)
                UIWindow.keyWindow?.navigationTopMost?.present(AppDelegate.shared.mainPlayer, animated: true)
            }
            
            return cell
        }
    }
}
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 200
        } else if indexPath.section == 3 {
            var hei = 0
            switch categorySelected {
            case .playlist:
                if playlists.count == 0 {
                    return 250
                }
                else {
                    hei = heightPlaylist * (playlists.count + 1)
                    return CGFloat(hei)
                }
            case .album:
                if albums.count == 0 {
                    return 250
                }
                else {
                    let numbes = (Double(albums.count) / 2) + 0.5
                    hei = heightAlbum * Int(numbes)
                    return CGFloat(hei + 10)
                }
            case .allSong:
                if musics.count == 0 {
                    return 250
                } else {
                    hei = heightPlaylist * (musics.count + 1)
                    return CGFloat(hei)
                }
            }
            
        } else if indexPath.section == 2 {
            return TypeMusicCell.height
        }
        return UITableView.automaticDimension
    }
}

enum HomeSection {
    case HomeTop
    case HomePopular
    case HomeTypeMusic
    case HomeCate
}

extension HomeVC : TypeMusicCellDelegate {
    func homeCategoryType(type: HomeCategoryType) {
        categorySelected = type
        homeTableView.reloadData()
    }
    
}
