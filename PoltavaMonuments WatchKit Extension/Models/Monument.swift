//
//  Monument.swift
//  PoltavaMonuments WatchKit Extension
//
//  Created by Bogdan Pohidnya on 02.01.2022.
//

import Foundation

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
    let isEasterEgg: Bool
    let createdAt: String
    let updatedAt: String
    let condition: Condition
    let monumentPhotos: [MonumentPhoto]
    let tags: [String]
    let destroyYear: Int?
    let destroyPeriod: Int?
}

struct Condition: Decodable {
    let id: Int
    let abbreviation: String
}

struct MonumentPhoto: Decodable {
    let id: Int
    let photoId: Int
    let majorPhoto: Bool
    let url: String
}
