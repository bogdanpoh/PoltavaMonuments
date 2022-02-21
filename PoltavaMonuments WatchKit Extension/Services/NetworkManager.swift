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
    
    func requestMonuments(location: CLLocationCoordinate2D, completion: @escaping ((Result<[Monument], Error>) -> Void)) {
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
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let monuments = try JSONDecoder().decode([Monument].self, from: data)
                completion(.success(monuments))
            } catch {
                print("[dev] error fetch response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func requestMonument(id: Int, completion: @escaping ((Result<Monument, Error>) -> Void)) {
        guard let urlComponents = urlComponents else { return }
        guard let baseUrl = urlComponents.url else { return }
        guard let url = URL(string: baseUrl.absoluteString + "/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let monument = try JSONDecoder().decode(Monument.self, from: data)
                completion(.success(monument))
            } catch {
                print("[dev] error fetch response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
}

