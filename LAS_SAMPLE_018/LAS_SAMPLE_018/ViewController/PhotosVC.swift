//
//  PhotosVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit
import Photos

class PhotosVC: UIViewController {
    
    //MARK: - properties
    var onImageSelected: ((_ images: [UIImage])->Void)?
    
    fileprivate var  selectedImage: [UIImage] = []{
        didSet {
            if bottomView != nil {
                if selectedImage.count == 0 {
                    bottomView.isHidden = true
                } else {
                    bottomView.isHidden = false
                }
                if selectedPhotoCollectionView != nil {
                    selectedPhotoCollectionView.reloadData()
                }
            }
        }
    }
    var galleryPhoto:[PHAsset] = []

    //MARK: - outlets
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var selectedPhotoCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if bottomView != nil {
            if selectedImage.count == 0 {
                bottomView.isHidden = true
            } else {
                bottomView.isHidden = false
            }
        }
    }
    private func setupUI() {
        photoCollectionView.register(UINib(nibName: PhotoSelectedCell.cellId, bundle: nil), forCellWithReuseIdentifier: PhotoSelectedCell.cellId)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        selectedPhotoCollectionView.register(UINib(nibName: PhotoItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: PhotoItemCell.cellId)
        selectedPhotoCollectionView.delegate = self
        selectedPhotoCollectionView.dataSource = self
        
        bottomView.backgroundColor = UIColor(rgb: 0xF3F8FF)
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.backgroundColor = UIColor(rgb: 0x329CFF)
    }
    
    
    private func requestData() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                
                // Handle restricted or denied state
                if status == .restricted || status == .denied
                {
                    print("Status: Restricted or Denied")
                }
                
                // Handle limited state
                if status == .limited
                {
                    self?.fetchPhotos()
                    print("Status: Limited")
                }
                
                // Handle authorized state
                if status == .authorized
                {
                    self?.fetchPhotos()
                    print("Status: Full access")
                }
            }
        } else {
            // Fallback on earlier versions
            self.fetchPhotos()
        }
    }
    
    private func fetchPhotos()
    {
        // Fetch all video assets from the Photos Library as fetch results
        let option = PHFetchOptions()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        option.sortDescriptors = [sort]
        
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: option)
        galleryPhoto = Array(_immutableCocoaArray: fetchResults)
        
        
        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    


    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        onImageSelected?(selectedImage)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.photoCollectionView {
            return galleryPhoto.count
        } else {
            return selectedImage.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectedCell.cellId, for: indexPath) as! PhotoSelectedCell
            cell.imageAsset = galleryPhoto[indexPath.row]
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.cellId, for: indexPath) as! PhotoItemCell
            cell.image = selectedImage[indexPath.row]
            cell.onDelete = { image in
                if let index = self.selectedImage.firstIndex(where: { $0.isEqualToImage(image: image) }) {
                    self.selectedImage.remove(at: index)
                    self.selectedPhotoCollectionView.reloadData()
                }
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.photoCollectionView {
            let w: CGFloat = (collectionView.bounds.size.width - 2 * padding - ((columns - 1) * padding/2)) / columns
            let h: CGFloat = w
            return .init(width: w, height: h)
        }
        else {
            return .init(width: 70, height: 70)
        }
    }

}

extension PhotosVC: PhotoSelectedCellDelegate {
    func addOrRemove(_ imageItem: UIImage) {
        if let index = selectedImage.firstIndex(where: { $0.isEqualToImage(image: imageItem) }) {
            selectedImage.remove(at: index)
        }
        else {
            selectedImage.append(imageItem)
        }
    }
    
    func isExists(_ imageItem: UIImage) -> Bool {
        return selectedImage.first(where: {  $0.isEqualToImage(image: imageItem)  }) != nil
    }
    
}

