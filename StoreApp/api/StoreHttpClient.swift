//
//  StoreHttpClient.swift
//  StoreApp
//
//  Created by Avantika on 30/03/25.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case invalidServerResponse
    case unknown
}

enum HttpMethd{
    case get([URLQueryItem])
    case post(Data?)
    case delete
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable>{
    let url: URL
    var headers: [String: String] = [:]
    var httpMethod: HttpMethd = .get([])
}


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

    
    func addProductApi(product: AddProductReq) async throws -> GetProductsByIdRes {
        // 1. Prepare request
        var request = URLRequest(url: URL.addProductUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(product)
        
        // 2. Perform request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 3. Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        
        print("➡️ Status Code: \(httpResponse.statusCode)")
        print("➡️ Headers: \(httpResponse.allHeaderFields)")
        print("➡️ Raw Response Body: \(String(data: data, encoding: .utf8) ?? "nil")")
        
        // Accept both 200 OK and 201 Created
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        // 4. Decode JSON into your model
        do {
            let productDetail = try JSONDecoder().decode(GetProductsByIdRes.self, from: data)
            return productDetail
        } catch {
            print("❌ Decoding failed with error: \(error)")
            throw NetworkError.decodingFailed
        }
    }
    
    func deleteProductApi(productId: Int) async throws -> Bool {
     
        var request = URLRequest(url: URL.deleteProductUrl(productId))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         
        let (data, response) = try await URLSession.shared.data(for: request)
         
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
              throw NetworkError.invalidServerResponse
        }
         
        let isDeleted = try JSONDecoder().decode(Bool.self, from: data)
        return isDeleted
    }

}

        
