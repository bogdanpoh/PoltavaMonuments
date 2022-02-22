//
//  NetworkManager.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit
import CoreLocation


final class NetworkManager {
    
    struct Endpoint {
        let path: String
        let httpMethod: String
        let queryItems: [URLQueryItem]?
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "monuments.pl.ua"
            components.path = "/api" + path
            components.queryItems = queryItems
            return components.url
        }
        
        var urlRequest: URLRequest? {
            guard let url = url else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            return urlRequest
        }
    }
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestCondition(completion: @escaping ((Result<[Condition], Error>) -> Void)) {
        let endpoint = Endpoint(path: "/condition", httpMethod: "GET", queryItems: nil)
        guard let request = endpoint.urlRequest else { return }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let conditions = try JSONDecoder().decode([Condition].self, from: data)
                completion(.success(conditions))
            } catch {
                print("[dev] error fetch data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func requestMonuments(coordinate: CLLocationCoordinate2D, completion: @escaping ((Result<[Monument], Error>) -> Void)) {
        let lat = String(coordinate.latitude)
        let lon = String(coordinate.longitude)
        
        let endpoint = Endpoint(path: "/monument", httpMethod: "GET", queryItems: [
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "pageNumber", value: "1"),
            URLQueryItem(name: "CurrentPosition.Latitude", value: lat),
            URLQueryItem(name: "CurrentPosition.Longitude", value: lon),
            URLQueryItem(name: "SortBy", value: "DISTANCE")
        ])
        
        guard let request = endpoint.urlRequest else { return }
        
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
        let endpoint = Endpoint(path: "/monument/\(id)", httpMethod: "GET", queryItems: nil)
        guard let request = endpoint.urlRequest else { return }
        
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

