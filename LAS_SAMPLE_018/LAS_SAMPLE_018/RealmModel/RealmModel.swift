//
//  RealmModel.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 15/08/2023.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    
    dynamic var musicIDs: List<String> = List()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

