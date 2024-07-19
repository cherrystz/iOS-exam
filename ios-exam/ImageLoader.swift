//
//  ImageLoader.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    private init() {}

    enum ImageLoaderError: Error {
        case invalidURL
        case networkError
        case invalidData
    }

    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(.networkError))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(image))
        }
        task.resume()
    }
}
