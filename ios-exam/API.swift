//
//  API.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import Foundation

typealias JSONObject = [String: Any]

class API {
    
    class Endpoint {
        
        let method: String
        let url: String
        
        init(method: String, url: String) {
            self.method = method
            self.url = url
        }
        
        static let fetchDataExam = Endpoint(method: "GET",              url: "https://wv-interview.web.app/resource/data.json")
    }
    
    
    static func fetch(_ endpoint: Endpoint, completionHandler: @escaping (Error?, JSONObject?) -> Void) {
            guard let url = URL(string: endpoint.url) else {
                completionHandler(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]), nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completionHandler(error, nil)
                    return
                }
                
                guard let data = data else {
                    completionHandler(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]), nil)
                    return
                }
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? JSONObject {
                        completionHandler(nil, jsonObject)
                    } else {
                        completionHandler(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]), nil)
                    }
                } catch {
                    completionHandler(error, nil)
                }
            }
            
            task.resume()
        }
}
