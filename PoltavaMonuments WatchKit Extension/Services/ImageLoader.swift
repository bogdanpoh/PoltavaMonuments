//
//  ImageLoader.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 03.01.2022.
//

import WatchKit
import Foundation

final class ImageLoader {
    
    static let shared = ImageLoader()
    private let cache: ImageCacheProtocol
    
    private init(cache: ImageCacheProtocol = ImageCache.shared) {
        self.cache = cache
    }
    
    func loadImages(from urls: [String], imageSize: Int = 300, completion: @escaping (([UIImage]) -> Void)) {
        let group = DispatchGroup()
        var images = [UIImage]()

        for urlString in urls {
            group.enter()

            DispatchQueue.global().async {
                guard let requestUrl = URL(string: urlString + "/\(imageSize)") else { return }

                URLSession.shared.dataTask(with: requestUrl) { data, _, error in
                    guard error == nil else {
                        print("[dev] error on loading: \(error)")
                        return
                    }
                    
                    guard let imageData = data else { return }

                    if let image = UIImage(data: imageData) {
                        images.append(image)
                        group.leave()
                    }
                }.resume()
            }
        }

        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    func loadImage(url: String, imageSize: Int = 300, completion: @escaping ((UIImage?) -> Void)) {
        var urlComponents = URLComponents(string: url + "/\(imageSize)")
        guard let url = URL(string: url + "/\(imageSize)") else { return }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else {
                    print("[dev] error on loading: \(error)")
                    return
                }
                
                guard let imageData = data else { return }
                
                if let image = UIImage(data: imageData) {
                    completion(image)
                }
            }.resume()
        }
    }
    
}
