//
//  DeleteProductRes.swift
//  StoreApp
//
//  Created by Avantika on 25/01/26.
//

import Foundation

struct DeleteProductRes: Decodable {
    var message: String?
    var rta: Bool?
    var statusCode: Int?
    var error: String?
    
}
