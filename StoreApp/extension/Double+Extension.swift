//
//  Double+Extension.swift
//  StoreApp
//
//  Created by Avantika on 20/11/25.
//

import Foundation

extension Double {
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
