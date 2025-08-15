//
//  UrlExtension.swift
//  StoreApp
//
//  Created by Avantika on 30/03/25.
//

import Foundation


extension URL{
    
    static var develomentUrl: URL {
        URL(string: "https://api.escuelajs.co/")!
    }
    
    static var productionUrl: URL {
        URL(string: "https://api.nasa.gov/")!
    }
    
    static var `default`: URL {
        #if DEBUG
           return develomentUrl
       #else
           return productionUrl
       #endif
    }
    
    static var allCategoriesUrl: URL {
        URL(string: "api/v1/categories" , relativeTo: Self.default)!
    }
    
    static func productById(_ id: Int) -> URL{
        return URL(string: "api/v1/categories/\(id)/products" , relativeTo: Self.default)!
    }
}
