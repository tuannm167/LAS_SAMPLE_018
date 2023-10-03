//
//  RealService.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 15/08/2023.
//

import Foundation
import RealmSwift

class RealmService: NSObject {
    
    private let idFavouriteFolder = "43AD7742-8B66-4F20-817F-805CBB60955C"
    
    private let config = Realm.Configuration(schemaVersion: 1)
    
    static let shared = RealmService()
    
    override init() { }
    
    func configuration() {
        do {
            let realm = try Realm(configuration: config)
            
            /// create favourite folder
            if realm.objects(RealmModel.self).first(where: { $0.id == idFavouriteFolder }) == nil {
                let obj = RealmModel()
                obj.id = idFavouriteFolder
                obj.name = "Favourite"
                
                try? realm.write({
                    realm.add(obj)
                    print("added favourite folder")
                })
            }
            
        } catch (let error) {
            print("Realm error: \(error.localizedDescription)")
        }
    }
    
    func realmObj() -> Realm? {
        let realm = try? Realm(configuration: config)
        return realm
    }
    
    func favouriteFolder() -> RealmModel? {
        guard let realm = self.realmObj() else { return nil }
        
        return realm.objects(RealmModel.self).first(where: { $0.id == idFavouriteFolder })
    }
    
    func dontAllowDeleteFolder(_ id: String) -> Bool {
        return id == idFavouriteFolder
    }
    
    
}

