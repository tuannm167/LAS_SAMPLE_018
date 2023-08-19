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
        
    }


    @IBAction func saveClick(_ sender: Any) {
        
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GenerateVideoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count == 0 {
            return 1
        }
        else {
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if photos.count == 0 {
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
        else {
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
