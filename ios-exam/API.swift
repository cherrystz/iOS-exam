//
//  API.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import Foundation

class API {
    
    class Endpoint {
        
        let method: String
        let url: String
        
        init(method: String, url: String) {
            self.method = method
            self.url = url
        }
    }
    
    static let fetchDataExam = Endpoint(method: "GET",      url: "https://wv-interview.web.app/resource/data.json")
    
    public func fetch() {
        
    }
}
