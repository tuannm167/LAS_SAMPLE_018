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
    
    dynamic var musicIDs: List<String> = List()
    
    func realmObj() -> Realm? {
        let realm = try? Realm(configuration: config)
        return realm
    }
    
    func favouriteFolder() -> RealmModel? {
        guard let realm = self.realmObj() else { return nil }
        
        return realm.objects(RealmModel.self).first(where: { $0.id == idFavouriteFolder })
    }
}


