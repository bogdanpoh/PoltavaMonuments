//
//  ImageLoader.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 03.01.2022.
//

import WatchKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private let cache: ImageCacheProtocol
    
    private init(cache: ImageCacheProtocol = ImageCache.shared) {
        self.cache = cache
    }
    
    func loadImages(from urls: [String], completion: @escaping (([UIImage]) -> Void)) {
        let group = DispatchGroup()
        var images = [UIImage]()
        
        for urlString in urls {
            group.enter()
            
            DispatchQueue.global().async { [unowned self] in
                if let url = URL(string: urlString) {
                    if let cacheImage = self.cache.load(for: url.absoluteString) {
                        images.append(cacheImage)
                    } else {
                        do {
                            let data = try Data(contentsOf: url)
                            if let downloadImage = UIImage(data: data) {
                                self.cache.save(for: url.absoluteString, downloadImage)
                                images.append(downloadImage)
                            }
                        } catch {
                            if let defaultImage = UIImage(named: "defaultImage") {
                                images.append(defaultImage)
                            }
                            print("[dev] error fetch image: \(error.localizedDescription)")
                        }
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
}
