//
//  NetworkManager.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit
import CoreLocation


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrlString: String
    private let urlComponents: URLComponents?
    
    private init() {
        baseUrlString = "https://monuments.pl.ua/api/monument"
        urlComponents = URLComponents(string: baseUrlString)
    }
    
    func requestImageUrls(location: CLLocationCoordinate2D, completion: @escaping (([String]?) -> Void)) {
        guard var urlComponents = urlComponents else { return }
        
        let lat = String(location.latitude)
        let lon = String(location.longitude)
        
        urlComponents.queryItems = [
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "pageNumber", value: "1"),
            URLQueryItem(name: "CurrentPosition.Latitude", value: lat),
            URLQueryItem(name: "CurrentPosition.Longitude", value: lon),
            URLQueryItem(name: "SortBy", value: "DISTANCE")
        ]
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            
            do {
                let monumentsResponse = try JSONDecoder().decode([MonumentResponse].self, from: data)
//                monumentsResponse.forEach { print("[dev] \($0.majorPhotoImageUrl)") }
                let urls: [String] = monumentsResponse.flatMap { $0.monumentPhotos.map { $0.url }}
                completion(urls)
            } catch {
                print("[dev] error fetch response: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        session.resume()
    }
    
}

