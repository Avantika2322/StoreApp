//
//  AddProductReq.swift
//  StoreApp
//
//  Created by Avantika on 28/09/25.
//

import Foundation


struct AddProductReq: Encodable {
    let title: String
    let price: Double
    let description: String
    let images: [URL]
    let categoryId: Int
    
    init(product: GetProductsByIdRes){
        title = product.title
        price = product.price
        description = product.description
        images = product.images ?? []
        categoryId = product.category.id
    }
}
