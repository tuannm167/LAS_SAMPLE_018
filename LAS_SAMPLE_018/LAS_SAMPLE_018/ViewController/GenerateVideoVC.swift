//
//  GenerateVideoVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit
import Photos

class GenerateVideoVC: UIViewController {
    //MARK: - properties
    fileprivate var photos: [UIImage] = []
    fileprivate var audios: [String] = []
    fileprivate var audiosURL:[URL] = []
    
    //MARK: - outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var audioView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        saveButton.backgroundColor = UIColor(rgb: 0x329CFF)
        saveButton.layer.cornerRadius = 18
        
        audioView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        audioView.backgroundColor = UIColor(rgb: 0xF3F8FF)
        
        photoCollectionView.register(UINib(nibName: AddPhotoCell.cellId, bundle:nil), forCellWithReuseIdentifier: AddPhotoCell.cellId)
        photoCollectionView.register(UINib(nibName: PhotoItemCell.cellId, bundle:nil), forCellWithReuseIdentifier: PhotoItemCell.cellId)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        audioTableView.register(UINib(nibName: AddAudioCell.cellId, bundle: nil), forCellReuseIdentifier: AddAudioCell.cellId)
        audioTableView.register(UINib(nibName: AudioCell.cellId, bundle: nil), forCellReuseIdentifier: AudioCell.cellId)
        audioTableView.separatorStyle = .none
        
        audioTableView.delegate = self
        audioTableView.dataSource = self
        
    }
    
    
    @IBAction func saveClick(_ sender: Any) {
        
        if photos.count == 0 || audiosURL.count == 0 {
            let ac = UIAlertController(title: "Please choose image or audio!!!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                // don't nothing
                
            }))
            self.present(ac, animated: true)
        } else {
            let loadingView = LoadingAnimationView()
            loadingView.setMessage("Generating video ...")
            loadingView.show()
            
            VideoGenerator.fileName = "Generated_\(photos.count) photos to video"
           // VideoGenerator.fileName = "Generated_video_01"
            VideoGenerator.videoBackgroundColor = .black
            VideoGenerator.videoImageWidthForMultipleVideoGeneration = 2000
            
            VideoGenerator.current.generate(withImages: photos, andAudios: audiosURL, andType: .multiple, { (progress) in
                print(progress)
            }) { (result) in
                switch result {
                case .success(let url):
                    loadingView.dismiss()
                    self.view.displayToast("Generated success!")
                case .failure(let error):
                    print(error)
                    loadingView.dismiss()
                    self.view.displayToast("Generated error!")
                }
            }
        }
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GenerateVideoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return photos.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.cellId, for: indexPath) as! PhotoItemCell
            cell.image = photos[indexPath.row]
            cell.onDelete = { image in
                if let index = self.photos.firstIndex(where: { $0.isEqualToImage(image: image) }) {
                    self.photos.remove(at: index)
                    self.photoCollectionView.reloadData()
                }
                
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.cellId, for: indexPath) as! AddPhotoCell
            cell.onAddPhoto = {
                guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                    return
                }
                let photosVC = PhotosVC()
                photosVC.onImageSelected = { images in
                    self.photos = self.photos + images
                    self.photoCollectionView.reloadData()
                }
                navi.pushViewController(photosVC, animated: true)
            }
            return cell
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: padding,
                     left: padding,
                     bottom: 0,
                     right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width - padding * 8
        let height = width
        return CGSize(width: width, height: height)
        
    }
    
    
}

extension GenerateVideoVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return audios.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AudioCell.cellId) as! AudioCell
            cell.selectionStyle = .none
            cell.musicId = audios[indexPath.row]
            cell.onDelete = { audio in
                if let index = self.audios.firstIndex(where: { $0.lowercased() == audio.lowercased() }) {
                    self.audios.remove(at: index)
                    self.audiosURL.remove(at: index)
                    self.audioTableView.reloadData()
                }
                
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAudioCell.cellId) as! AddAudioCell
            cell.selectionStyle = .none
            cell.onAddAudio =  { [weak self] in
                guard let self = self else { return }
                guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                    return
                }
                let audioVC: AudioVC = AudioVC()
                audioVC.onSelectedAudio = { audios, urls in
                    self.audios = self.audios + audios
                    self.audiosURL = self.audiosURL + urls
                    self.audioTableView.reloadData()
                }
                navi.pushViewController(audioVC, animated: true)
                
            }
            return cell
        }
    }
    
    
}

extension GenerateVideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
