//
//  StoreHttpClient.swift
//  StoreApp
//
//  Created by Avantika on 30/03/25.
//

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case invalidServerResponse
    case unknown
}

import Foundation

class StoreHttpClient {
    
    func getAllCategoriesApi() async throws -> [GetAllCategoryRes] {
       // guard let url = URL(string: "https://api.escuelajs.co/api/v1/categories") else {
         //   throw NetworkError.invalidURL
        //}
       
        let (data, response) = try await URLSession.shared.data(from: URL.allCategoriesUrl)
     
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let categories = try? JSONDecoder().decode([GetAllCategoryRes].self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return categories
    }
    
    func getAllProductsApi(categoryId: Int) async throws -> [GetProductsByIdRes] {
        let (data, response) = try await URLSession.shared.data(from: URL.productById(categoryId))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let productDetail = try? JSONDecoder().decode([GetProductsByIdRes].self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return productDetail
    }
}

        
