//
//  AppData.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import Foundation

class AppData {
    
    static var error: Error? = nil
    static var bannersJson: [JSONObject] = []
    static var carouselsJson: [JSONObject] = []
    static var eventSingleCardsJson: [JSONObject] = []
    
    static func fetchData() {
        API.fetch(.fetchDataExam) { error, json in
            if let error = error {
                // Handle error
                AppData.error = error
                return
            }
                guard let code = json?["code"] as? Int,
                  let responseObject = json?["responseObject"] as? JSONObject,
                  let contentShelfs = responseObject["contentShelfs"] as? [JSONObject],
                  code == 200 else {
                return
            }
            
            let bannersJson = contentShelfs.filter { json in
                guard let type = json["type"] as? String, type == "banner_1" else {
                    return false
                }
                return true
            }
            AppData.bannersJson = bannersJson
            
            let eventSingleCardsJson = contentShelfs.filter { json in
                guard let type = json["type"] as? String, type == "eventSingleCard" else {
                    return false
                }
                return true
            }
            AppData.eventSingleCardsJson = eventSingleCardsJson
            
            let carouselsJson = contentShelfs.filter { json in
                guard let type = json["type"] as? String, type == "carousel" else {
                    return false
                }
                return true
            }
            AppData.carouselsJson = carouselsJson
            
            AppData.error = nil
            NotificationCenter.default.post(name: .dataFetched, object: nil)
        }
    }
}
