//
//  Monument.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import WatchKit

struct Monument: Decodable {
    let id: Int
    let year: Int
    let period: Int
    let name: String
    let description: String?
    let cityId: Int
    let statusId: Int
    let conditionId: Int
    let accepted: Bool
    let latitude: Double
    let longitude: Double
    let majorPhotoImageId: Int
    let majorPhotoImageUrl: String
    let protectionNumber: String
    let slug: String
    let createdAt: String
    let updatedAt: String
    let condition: Condition
    let monumentPhotos: [MonumentPhoto]
    let tags: [String]
    let destroyYear: Int?
    let destroyPeriod: Int?
}

struct Condition: Decodable {
    
    enum Status: String, Decodable {
        case goodCondition = "good_condition"
        case lost = "lost"
        case lostRecently = "lost-recently"
        case vergeOfLoss = "verge-of-loss"
        case needsRepair = "needs-repair"
        
        var color: UIColor {
            switch self {
            case .goodCondition:
                return UIColor(red: 0.34, green: 0.80, blue: 0.60, alpha: 1.00)
                
            case .lost:
                return UIColor(red: 0.86, green: 0.04, blue: 0.08, alpha: 1.00)
                
            case .lostRecently:
                return UIColor(red: 0.86, green: 0.04, blue: 0.08, alpha: 1.00)
                
            case .vergeOfLoss:
                return UIColor(red: 0.96, green: 0.77, blue: 0.19, alpha: 1.00)
                
            case .needsRepair:
                return UIColor(red: 0.96, green: 0.77, blue: 0.19, alpha: 1.00)
            }
        }
    }
    
    let id: Int
    let name: String?
    let abbreviation: String
    
    var status: Status {
        return Status(rawValue: abbreviation) ?? .goodCondition
    }
    
}

struct MonumentPhoto: Decodable {
    let id: Int
    let photoId: Int
    let majorPhoto: Bool
    let url: String
}

extension Monument {
    
    static var mocked: Monument {
        .init(
            id: 1,
            year: 1,
            period: 1,
            name: "Mocked name",
            description: "Mocked desk",
            cityId: 1,
            statusId: 1,
            conditionId: 1,
            accepted: false,
            latitude: 1.00,
            longitude: 1.00,
            majorPhotoImageId: 1,
            majorPhotoImageUrl: "https://monuments.pl.ua/api/photo/33/image",
            protectionNumber: "",
            slug: "",
            createdAt: "2012",
            updatedAt: "2020",
            condition: .init(id: 1, name: "Test name", abbreviation: "lost"),
            monumentPhotos: [.init(id: 0, photoId: 0, majorPhoto: false, url: "")],
            tags: [""],
            destroyYear: nil,
            destroyPeriod: nil
        )
    }
    
}
