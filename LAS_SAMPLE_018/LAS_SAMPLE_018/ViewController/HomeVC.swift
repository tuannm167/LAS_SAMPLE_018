//
//  HomeVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import MediaPlayer

class HomeVC: BaseVC, TypeMusicCellDelegate {
    func typeMusicAction(number: Int) {
        numbers = number
        homeTableView.reloadData()
    }
    
    
    //MARK: - properties
    var albums: [AlbumModel] = []
    var artists: [AlbumModel] = []
    var playlists:[AlbumModel] = []
    var musicService: MusicService = MusicService()
    var musics: [String] = []
    var musicIDs:[String] = []
    var favouriteFolder: RealmModel?
    var numbers = 0
    let heightPlaylist = 100
    let heightAlbum = 250
    var data = [HomeSection.HomeTop, HomeSection.HomeSearch, HomeSection.HomeTopArtist,
                HomeSection.HomeCate]
    //MARK: - outlets
    @IBOutlet weak var viewPlayMusic: UIView!
    @IBOutlet weak var avatarSongs: UIImageView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var artistsName: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    var homevc = AllSongsVC()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        viewPlayMusic.clipsToBounds = true
        viewPlayMusic.layer.cornerRadius = 25
        viewPlayMusic.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        avatarSongs.layer.cornerRadius = avatarSongs.frame.height/2
        viewPlayMusic.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CPlayer.shared.isPlaying() {
            viewPlayMusic.isHidden = false
        } else {
            viewPlayMusic.isHidden = true
        }
        loadData()
    }
    
    //MARK: - private
    private func setupUI() {
        homeTableView.register(UINib(nibName: HomeItemCell.cellId, bundle: nil), forCellReuseIdentifier: HomeItemCell.cellId)
        homeTableView.register(UINib(nibName: HomeSearchCell.cellId, bundle: nil), forCellReuseIdentifier: HomeSearchCell.cellId)
        homeTableView.register(UINib(nibName: HomePopularCell.cellId, bundle: nil), forCellReuseIdentifier: HomePopularCell.cellId)
        homeTableView.register(UINib(nibName: TypeMusicCell.cellId, bundle: nil), forCellReuseIdentifier: TypeMusicCell.cellId)
        homeTableView.register(UINib(nibName: HomeMusicCell.cellId, bundle: nil), forCellReuseIdentifier: HomeMusicCell.cellId)
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
    
    @IBAction func clickShowPlayMusic(_ sender: UIButton) {
        AppDelegate.shared.mainPlayer.setPlaylist(self.musics, currentItem: musicName ?? "")
        UIWindow.keyWindow?.navigationTopMost?.present(AppDelegate.shared.mainPlayer, animated: true)
    }
    @IBAction func clickFavourite(_ sender: UIButton) {
        self.openAllSongF()
    }
    
    var musicName: String?  {
        didSet {
            if musicName != nil {
                guard let song = MusicService().getItem(songId: musicName!) else { return }
                nameSong.text = song.songTitle
                avatarSongs.image = song.getThumb
                artistsName.text = song.artistName
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
        case .HomeSearch:
            return 1
        case .HomeTopArtist:
            return 1
        case .HomeCate:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch data[indexPath.section] {
        case .HomeTop:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchCell.cellId) as! HomeSearchCell
            cell.tappedHideKeyboard(view: self.view)
            return cell
        case .HomeSearch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePopularCell.cellId) as! HomePopularCell
            cell.source = artists
            cell.selectItem = { album in
                self.openAllSong(album: album)
            }
            return cell
        case .HomeTopArtist:
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeMusicCell.cellId) as! TypeMusicCell
            cell.delegate = self
            return cell
        case .HomeCate:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeMusicCell.cellId) as! HomeMusicCell
            cell.source = playlists
            cell.sourceSongs = musics
            cell.sourceAlbum = albums
            cell.selectItem = { album in
                if self.numbers == 0 || self.numbers == 1 {
                    self.openAllSong(album: album)
                }
            }
            cell.selectItemSong = { songId in
                AppDelegate.shared.mainPlayer.setPlaylist(self.musics, currentItem: songId)
                UIWindow.keyWindow?.navigationTopMost?.present(AppDelegate.shared.mainPlayer, animated: true)
                self.musicName = songId
            }
            cell.count = numbers
            cell.collectionView.reloadData()
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
            if numbers == 0 {
                hei = heightPlaylist * playlists.count
                return CGFloat(hei)
            } else if numbers == 1 {
                let numbes = (Double(albums.count) / 2) + 0.5
                hei = heightAlbum * Int(numbes)
                return CGFloat(hei + 10)
            } else {
                hei = heightPlaylist * musics.count
                return CGFloat(hei)
            }
        } else if indexPath.section == 2 {
            return 70
        }
        return UITableView.automaticDimension
    }
}

enum HomeSection {
    case HomeTop
    case HomeSearch
    case HomeTopArtist
    case HomeCate
}
