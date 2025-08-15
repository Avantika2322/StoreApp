//
//  Locale+Extension.swift
//  StoreApp
//
//  Created by Avantika on 28/06/25.
//

import Foundation

extension Locale{
    static var currencyCode: String {
        return Locale.current.currency?.identifier ?? "USD"
    }
}
