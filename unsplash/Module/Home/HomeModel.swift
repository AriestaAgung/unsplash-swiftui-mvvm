//
//  HomeModel.swift
//  unsplash
//
//  Created by BRIMO on 01/06/22.
//

import Foundation

struct HomeRandomImageResponse: Codable {
    let total: Int?
    let totalPages: Int?
    let results: [HomeRandomImageResponseResult]?
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct HomeRandomImageResponseResult: Codable {
    let id: String?
    let width: Double?
    let height: Double?
    let description: String?
    let color: String?
    let urls: ImageUrls?
    
    
}

struct ImageUrls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
