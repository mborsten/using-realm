//
//  RWSApi.swift
//  UsingRealm
//
//  Created by Marcel Borsten on 30-04-17.
//  Copyright © 2017 Impart IT. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftDate

struct RWSApi {

    let url = "https://waterinfo.rws.nl/api/point/latestmeasurements?parameterid=golfhoogte"
    let realm = try! Realm()

    func syncWaves() {

        Alamofire.request(url)
            .validate()
            .responseJSON() { jsonResponse in

                switch jsonResponse.result {

                case .failure(let error):
                    print("\(error)")

                case .success(let json):
                    if let json = json as? [String:Any] {

                        if let features = json["features"] as? [[String:Any]] {

                            for f in features {

                                if let properties = f["properties"] as? [String:Any] {

                                    if  let name = properties["name"] as? String,
                                        let measurements = properties["measurements"] as? [[String:Any]],
                                        let measurement = measurements.first,
                                        let latestValue = measurement["latestValue"] as? Double,
                                        let dateString = measurement["dateTime"] as? String,
                                        let locationCode = properties["locationCode"] as? Int {

                                        let loc = Location()
                                        loc.locationCode = locationCode
                                        loc.name = name
                                        loc.latestValue = latestValue
                                        loc.date = dateString.date(formats: [.iso8601Auto])?.absoluteDate ?? Date()

                                        try! self.realm.write {
                                            self.realm.add(loc, update: true)
                                        }

                                    }
                                }

                            }

                        }
                    }

                }

        }

    }

}
