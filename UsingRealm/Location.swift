//
//  Transaction.swift
//  UsingRealm
//
//  Created by Marcel Borsten on 30-04-17.
//  Copyright © 2017 Impart IT. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {

    dynamic var name: String = ""
    dynamic var latestValue: Double = 0.0
    dynamic var date: Date = Date()
    dynamic var locationCode: Int = 0

    override static func primaryKey() -> String? {
        return "locationCode"
    }

}
