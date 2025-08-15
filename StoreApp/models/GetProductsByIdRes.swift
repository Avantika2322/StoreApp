//
//  GetProductDetailByIdRes.swift
//  StoreApp
//
//  Created by Avantika on 21/06/25.
//

import Foundation

struct GetProductsByIdRes: Codable{
    var id: Int?
    let title: String
    let price: Double
    let description: String
    let images: [URL]?
    let category: GetAllCategoryRes
}
