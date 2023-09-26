//
//  WallpaperVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import SDWebImage

enum CategoryType: String {
    case animal, beautiful, city, galaxy, moon, natural
    
    func title() -> String {
        switch self {
        case .animal: return "Animal"
        case .beautiful: return "Beautiful"
        case .city: return "City"
        case .galaxy: return "Galaxy"
        case .moon: return "Moon"
        case .natural: return "Nature"
        }
    }
}

class WallpaperVC: UIViewController {
    //MARK: - properties
    
    var categorySelected: CategoryType = .animal
    
    
    var typeLayout: [CategoryType] = [.animal, .beautiful, .city, .galaxy, .moon, .natural]
    var currentSelected:Int = 0
    
    var animalList: [URL] = []
    var beautifulList: [URL] = []
    var cityList: [URL] = []
    var galaxyList: [URL] = []
    var moonList: [URL] = []
    var naturalList: [URL] = []
    
    //MARK: - outlets
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        loadData(category: .animal)
    }
    
    
    private func setupUI() {
        
        detailView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        detailView.backgroundColor = UIColor(rgb: 0xF3F8FF)
        
        
        typeCollectionView.register(UINib(nibName: CategoryItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: CategoryItemCell.cellId)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        detailCollectionView.register(UINib(nibName: WallpaperItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: WallpaperItemCell.cellId)
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
    }
    
    
    private func loadData(category: CategoryType) {
        animalList = []
        beautifulList = []
        cityList = []
        galaxyList = []
        moonList = []
        naturalList = []
        
        for i in 1...15 {
            
            let imageStr = "https://github.com/tuannm167/Wallpaper/blob/main/" + category.title() + "/"   + category.title() + "\(i).jpg?raw=true"
            guard let url = URL(string: imageStr) else { return }
            
            switch category {
            case .animal:
                animalList.append(url)
            case .beautiful:
                beautifulList.append(url)
            case .city:
                cityList.append(url)
            case .galaxy:
                galaxyList.append(url)
            case .moon:
                moonList.append(url)
            case .natural:
                naturalList.append(url)
            }
        }
        detailCollectionView.reloadData()
    }
    
    
}

extension WallpaperVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView {
            return typeLayout.count
        }
        else {
            switch categorySelected {
                
            case .animal:
                return animalList.count
            case .beautiful:
                return beautifulList.count
            case .city:
                return cityList.count
            case .galaxy:
                return galaxyList.count
            case .moon:
                return moonList.count
            case .natural:
                return naturalList.count
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.cellId, for: indexPath) as! CategoryItemCell
            cell.categoryType = typeLayout[indexPath.row]
            if indexPath.row == currentSelected {
                cell.isItemSelected = true
            } else {
                cell.isItemSelected = false
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperItemCell.cellId, for: indexPath ) as! WallpaperItemCell
            switch categorySelected {
                
            case .animal:
                cell.imageUrl = animalList[indexPath.row]
            case .beautiful:
                cell.imageUrl = beautifulList[indexPath.row]
            case .city:
                cell.imageUrl = cityList[indexPath.row]
            case .galaxy:
                cell.imageUrl = galaxyList[indexPath.row]
            case .moon:
                cell.imageUrl = moonList[indexPath.row]
            case .natural:
                cell.imageUrl = naturalList[indexPath.row]
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            currentSelected = indexPath.row
            
            categorySelected = typeLayout[indexPath.row]
            self.loadData(category: categorySelected)
            
            self.typeCollectionView.reloadData()
            
        } else {
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == typeCollectionView {
            return .init(top: 0, left: 20, bottom: 0, right: 0)
        }
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == typeCollectionView {
            return .init(width: 100 , height: 45)
        } else {
            let w = (UIScreen.main.bounds.width - 60)/2
            let h = w * 1.5
            return .init(width: w, height: h)
        }
        
    }
}
