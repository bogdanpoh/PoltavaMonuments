//
//  ImageCache.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 03.01.2022.
//

import WatchKit

protocol ImageCacheProtocol {
    func save(for key: String, _ image: UIImage)
    func load(for key: String) -> UIImage?
}

final class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
}

// MARK: - ImageCacheProtocol

extension ImageCache: ImageCacheProtocol {
    
    func save(for key: String, _ image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    func load(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
}
